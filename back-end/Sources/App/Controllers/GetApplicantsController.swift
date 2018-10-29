//
//  GetApplicantsController.swift
//  App
//
//  Created by Kevin Bai on 2018-10-15.
//

import Vapor
import MongoKitten
import ExtendedJSON

final class GetApplicantsController {
    func getQueries(from req: Request) -> [String:String] {
        var queries: [String:String] = [:]
        if let query = req.http.url.query {
            let separatedQueries = query.components(separatedBy: "&")
            separatedQueries.forEach { query in
                let split = query.components(separatedBy: "=")
                if split.count == 2 {
                    let label = split.first!
                    let value = split.last!
                    queries[label] = value
                }
            }
        }
        return queries
    }
    
    func getApplicant(req: Request, queries: [String:String]) -> String {
        return ""
    }
    func getApplicantsIds(req: Request, queries: [String:String]) -> String {
        let applicantIds = fetchApplicantsIdsFromDatabase(queries: queries)
        return applicantIds.serializedString()
    }
    
    func getApplicantsById(req: Request, queries: [String:String]) -> String {
        do {
            guard let data = req.http.body.data else { return "{\"applicants\": [], \"applicantsRaw\": [] }" }
            let json = try JSONDecoder().decode(GetApplicantsBody.self, from: data)
            
            let documents = try json.ids.map { id -> (MongoKitten.Document, MongoKitten.Document) in
                guard let applicant = try Database.collectionApplicants?.findOne(["_id": ObjectId(id)]) else { return ( [:], [:]) }
                guard let commentId = String(applicant["commentId"]) else { return (applicant, [:]) }
                guard let raw = try Database.collectionApplicantsRaw?.findOne(["commentId": commentId]) else { return (applicant, [:])}
                return (applicant,raw)
            }
            let filtered = documents.filter { applicant in
                return !applicant.0.isEmpty && !applicant.1.isEmpty
            }
            var finalApplicants: ([Document], [Document]) = ([],[])
            filtered.forEach { applicant in
                finalApplicants.0.append(applicant.0)
                finalApplicants.1.append(applicant.1)
            }
            
            let dictionary: [String:CheetahValue] = [
                "applicants": finalApplicants.0.makeExtendedJSON(),
                "applicantsRaw": finalApplicants.1.makeExtendedJSON()
            ]
            
            return JSONObject(dictionary).serializedString()
        }
        catch { }
        
        return "{\"ok\": \"success\"}"
    }
    
    func fetchApplicantsIdsFromDatabase(queries: [String:String]) -> [String] {
        do {
            let query = Query(queries: queries)
            
            var applicants: CollectionSlice<Document>?
            if queries.isEmpty { applicants = try Database.collectionApplicants?.find() }
            else {  applicants = try Database.collectionApplicants?.find(query) }
            
            var applicantIds: [String] = []
            
            try applicants?.forEach { doc in
                guard let _id = String(doc["_id"]) else { return }
                applicantIds.append(_id)
            }
            return applicantIds
        }
        catch {}
        return []
    }
    
    func dictionariesEqual(a: [String:String], b: [String:String]) -> Bool {
        if a.count != b.count { return false }
        for item in a {
            if b[item.key] != item.value { return false }
        }
        
        return true
    }
    
    func getDocumentsMatching(key: String, from: CollectionSlice<Document>, to: CollectionSlice<Document>) -> Document {
        return [:]
    }
}
