//
//  UpdateThreadController.swift
//  App
//
//  Created by Kevin Bai on 2018-10-08.
//

import Vapor
import SwiftSoup
import MongoKitten

final class UpdateThreadController {
    var applicantSelectors: ApplicantRawModel
    init(applicantSelectors: ApplicantRawModel? = nil) {
        // connect to mongodb database
        if let selectors = applicantSelectors {
            self.applicantSelectors = selectors
        }
        else {
            let selector = ApplicantModels.getDefaultSelectorModel()
            self.applicantSelectors = selector
        }
    }
    func parseHTMLAndProcessComments(body: ThreadUpdateStruct, findLastPage: Bool = true, urlString: String? = nil) -> String {
        guard let url = URL(string: urlString == nil ? body.threadURL : urlString!) else { return "Err in Body"}
        var urlRequest = URLRequest(url: url)
        urlRequest.setValue("text/html", forHTTPHeaderField: "Content-Type")
        urlRequest.setValue("Mozilla/5.0 (Macintosh; Intel Mac OS X 10_11_1) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/69.0.3497.100 Safari/537.36", forHTTPHeaderField: "User-Agent")
        
        let task = URLSession.shared.dataTask(with: urlRequest, completionHandler: { (data, response, err) in
            if let _ = err { return }
            guard let data = data else { return }
            guard let html = String(data: data, encoding: .utf8) else { return }
            // get last page
            do {
                let doc = try SwiftSoup.parse(html)
                if findLastPage {
                    if let lastPageStr = try doc.select("a.LastPage").first()?.text() {
                        if let lastPage = Int(lastPageStr) {
                            var spliced = body.threadURL
                            if spliced.contains(".html") && lastPage > 1 {
                                spliced.removeLast(5)
                                for i in 2...lastPage {
                                    let newStr = "\(spliced)-p\(i).html"
                                    _ = self.parseHTMLAndProcessComments(body: body, findLastPage: false, urlString: newStr)
                                }
                            }
                        }
                    }
                }
                
                let applicants = self.getApplicants(doc: doc, body: body)
                self.addApplicantsToDatabase(applicants: applicants)
            }
            catch {}
        })
        task.resume()
        
        return "Done"
    }
    
    private func getApplicants(doc: SwiftSoup.Document, body: ThreadUpdateStruct) -> [(ApplicantRawModel, ApplicantModel)] {
        var applicants: [(ApplicantRawModel, ApplicantModel)] = []
        do {
            let commentsList = try doc.select("div.commentsWrap ul.MessageList > li")
            commentsList.forEach { listItem in
                let applicant = parseComment(element: listItem, body: body)
                if applicant.0 != nil && applicant.1 != nil {
                    applicants.append((applicant.0!, applicant.1!))
                }
            }
        }
        catch {
            return applicants
        }
        return applicants
    }
    
    private func addApplicantsToDatabase(applicants: [(ApplicantRawModel, ApplicantModel)]) {
        do {
            try applicants.forEach { applicant in
                var rawApplicantDocument: MongoKitten.Document = [:]
                for item in applicant.0 {
                    rawApplicantDocument.append(item.value, forKey: item.key)
                }
                // find one from mongo
                let query: Query = [
                    "commentId": applicant.0["commentId"]
                ]
                //insert new school if it doesn't exist as well
                if let _ = try Database.collectionApplicantsRaw?.findOne(query) { return }
                if let primitive = applicant.1["school"] {
                    if let school = String(primitive) {
                        if let _ = try Database.collectionSchools?.findOne(["school": school]) {}
                        else {
                            try Database.collectionSchools?.insert(["school": school])
                        }
                    }
                }
                let normalizedApplicantDocument = MongoKitten.Document(dictionaryElements: applicant.1.map { ($0.key, $0.value )})
                try Database.collectionApplicantsRaw?.insert(rawApplicantDocument)
                try Database.collectionApplicants?.insert(normalizedApplicantDocument)
            }
        }
        catch {
            
        }
    }
    
    func parseComment(element: Element, body: ThreadUpdateStruct) -> (ApplicantRawModel?, ApplicantModel?) {
        do {
            let commentId = try element.attr("id")
            let commentLinkTag = try element.select("span.CommentNumber>a")
            let commentLink = try commentLinkTag.attr("href")
            let userTag = try element.select("div.Item-Header span.Author > a.Username")
            let userLink = try userTag.attr("href")
            let userId = try userTag.text()
            
            let applicant = ApplicantModels.getEmptyRawApplicant(commentId: commentId)
            
            let commentContent = try element.select("div.Item-BodyWrap div.userContent").html()
            let commentChunks = commentContent.components(separatedBy: "<br>")
            var rawApplicant = completeApplicantFromCommentChunks(commentChunks: commentChunks, currentApplicant: applicant)
            rawApplicant["originalCommentHTML"] = commentContent

            var decision = ""
            if let rawDecision = rawApplicant["decision"] {
                if rawDecision.contains("Accepted") { decision = "Accepted" }
                else if rawDecision.contains("Rejected") { decision = "Rejected" }
                else if rawDecision.contains("Deferred") { decision = "Deferred" }
            }
            
            var newApplicant = ApplicantModels.getEmptyNormalizedApplicantModel(userId: userId, userLink: userLink, commentId: commentId, commentLink: "https://talk.collegeconfidential.com\(commentLink)", threadURL: body.threadURL, school: body.school, classYear: body.classYear, action: body.action, decision: decision)
            
            newApplicant = Normalizer.normalize(normalizedApplicant: newApplicant, rawApplicant: rawApplicant)
            return (rawApplicant, newApplicant as ApplicantModel)
        }
        catch {
            return (nil, nil)
        }
    }
    
    public func completeApplicantFromCommentChunks(commentChunks: [String], currentApplicant: ApplicantRawModel) -> ApplicantRawModel {
        
        var newApplicant = currentApplicant
        
        var currentKey: String?
        for chunk in commentChunks {
            var splitted = chunk.components(separatedBy: ":")
            var foundMatch = false
            if splitted.count > 1 {
                outerKeys: for (key, value) in self.applicantSelectors {
                    var counter = 0
                    splitChunks: for item in splitted {
                        if counter > 0 && key != "decision" { break }
                        let itemLowercased = item.lowercased()
                        let valueLowercased = value.lowercased()
                        if itemLowercased.contains(valueLowercased) {
                            if key == "decision" {
                                let range = itemLowercased.range(of: "decision")
                                if itemLowercased.endIndex != range?.upperBound {
                                    break splitChunks
                                }
                            }
                            if wordsMatchSelectorString(rawString: itemLowercased, selectorString: valueLowercased) || key == "decision" {
                                _ = splitted.remove(at: counter)
                                let combined = splitted.reduce("") { $0 + " " + $1 }
                                
                                if let currentValue = newApplicant[key] {
                                    newApplicant[key] = currentValue + " " + combined
                                }
                                else {
                                    newApplicant[key] = combined
                                }
                                foundMatch = true
                                currentKey = key
                                break outerKeys
                            }
                        }
                        counter += 1
                    }
                    
                }
            }
            if (!foundMatch) {
                if let key = currentKey {
                    if key != "decision" {
                        if let currentValue = newApplicant[key] {
                            newApplicant[key] = currentValue + " " + chunk
                        }
                        else {
                            newApplicant[key] = chunk
                        }
                    }
                }
            }
        }
        return newApplicant
    }
    
    func wordsMatchSelectorString(rawString: String, selectorString: String) -> Bool {
        let rawWords = rawString.components(separatedBy: " ")
        let selectorWords = selectorString.components(separatedBy: " ")
        
        // all selector words match
        for selectorWord in selectorWords {
            var foundMatch = false
            for word in rawWords {
                if word == selectorWord {
                    foundMatch = true
                }
            }
            if !foundMatch { return false }
        }
        return true
    }
}
