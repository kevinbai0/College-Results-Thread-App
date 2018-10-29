//
//  Normalizer.swift
//  App
//
//  Created by Kevin Bai on 2018-10-13.
//

import Foundation
import MongoKitten


struct Normalizer {
    static func normalize(normalizedApplicant: ApplicantModel, rawApplicant: ApplicantRawModel) -> ApplicantModel {
        var newApplicant = normalizedApplicant
        // convert sat score
        if let satHTML = rawApplicant["sat1"] {
            let satScores = Normalizer.normalizeSAT(string: satHTML.lowercased())
            if let rw = satScores.0 { newApplicant["sat (R/W)"] = rw }
            if let math = satScores.1 { newApplicant["sat (math)"] = math }
            if let comb = satScores.2 { newApplicant["sat (combined)"] = comb }
        }
        
        
        if let actHTML = rawApplicant["act"] {
            let actScores = Normalizer.normalizeACT(string: actHTML.lowercased())
            if let e = actScores.0 { newApplicant["act (english)"] = e }
            if let m = actScores.1 { newApplicant["act (math)"] = m }
            if let r = actScores.2 { newApplicant["act (reading)"] = r }
            if let s = actScores.3 { newApplicant["act (science)"] = s }
            if let c = actScores.4 { newApplicant["act (combined)"] = c }
        }
        
        if let unweightedGPAHTML = rawApplicant["unweightedGPA"] {
            if let unweightedGPA = Normalizer.normalizeGPA(string: unweightedGPAHTML) {
                newApplicant["unweightedGPA"] = unweightedGPA
            }
        }
        
        if let weightedGPAHTML = rawApplicant["weightedGPA"] {
            if let weightedGPA = Normalizer.normalizeGPA(string: weightedGPAHTML) {
                newApplicant["weightedGPA"] = weightedGPA
            }
        }
        
        
        if let rankHTML = rawApplicant["rank"] {
            let rank = Normalizer.normalizeRank(string: rankHTML)
            newApplicant["rank"] = [
                "rankInClass": rank.0 == nil ? -1 : rank.0,
                "classSize": rank.1 == nil ? -1 : rank.1,
                "percent": rank.2 == nil ? -1 : rank.2
            ]
        }
        
        if let genderHTML = rawApplicant["gender"] {
            let gender = Normalizer.normalizeGender(string: genderHTML)
            newApplicant["gender"] = gender
        }
        
        return newApplicant
    }
    
    static func normalizeSAT(string: String) -> (Int?, Int?, Int?) {
        var results: (Int?, Int?, Int?) = (nil, nil, nil)
        let keywords = [
            ("reading", ["r/w", "r", "r/e", "reading", "reading/writing", "e", "english", "verbal"]),
            ("math", ["m", "math"])
        ]
        var digitRegex: NSRegularExpression?
        do {
            digitRegex = try NSRegularExpression(pattern: "\\d+")
        } catch {}
        guard let regex = digitRegex else { return (nil, nil, nil) }
        let nsString = string as NSString
        let matches = regex.matches(in: string, options: [], range: NSRange(location: 0, length: string.count)).map { nsString.substring(with: $0.range) }
        var indicesOfKeywords = keywords.map { subKeywords in
            return (subKeywords.0, findLocationOfKeywords(string: string, keywords: subKeywords.1))
        }
        indicesOfKeywords.sort { (num0: (String, Int?), num1: (String, Int?)) -> Bool in
            if num0.1 == nil && num1.1 == nil {
                return num0.0 < num1.0
            }
            else if num0.1 == nil {
                return false
            }
            else if num1.1 == nil {
                return true
            }
            else {
                return num0.1! < num1.1!
            }
        }
        var order = 0
        
        matches.forEach { match in
            guard let number = Int(match) else { return }
            if number > 800 {
                results.2 = number
            }
            else {
                if order < indicesOfKeywords.count {
                    let currentStr = indicesOfKeywords[order].0
                    if currentStr == "reading" { results.0 = Int(match) }
                    else if currentStr == "math" { results.1 = Int(match) }
                }
                
                order += 1
            }
        }
        return results
    }
    
    static func normalizeACT(string: String) -> (Int?, Int?, Int?, Int?, Int?) {
        var results: (Int?, Int?, Int?, Int?, Int?) = (nil, nil, nil, nil, nil)
        let keywords = [
            ("english", ["e", "english", "eng"]),
            ("math", ["m","math"]),
            ("reading", ["r", "reading", "read"]),
            ("science", ["s", "science", "sci"])
        ]
        var digitRegex: NSRegularExpression?
        do {
            digitRegex = try NSRegularExpression(pattern: "\\d+")
        } catch {}
        guard let regex = digitRegex else { return (nil, nil, nil, nil, nil) }
        let nsString = string as NSString
        let matches = regex.matches(in: string, options: [], range: NSRange(location: 0, length: string.count)).map { nsString.substring(with: $0.range) }
        var indicesOfKeywords = keywords.map { subKeywords in
            return (subKeywords.0, findLocationOfKeywords(string: string, keywords: subKeywords.1))
        }
        indicesOfKeywords.sort { (num0: (String, Int?), num1: (String, Int?)) -> Bool in
            if num0.1 == nil && num1.1 == nil {
                return num0.0 < num1.0
            }
            else if num0.1 == nil {
                return false
            }
            else if num1.1 == nil {
                return true
            }
            else {
                return num0.1! < num1.1!
            }
        }
        var counter = -1
        var order = 0
        
        matches.forEach { match in
            counter += 1
            if counter == 0 {
                results.4 = Int(match)
            }
            else {
                if order < indicesOfKeywords.count {
                    let currentStr = indicesOfKeywords[order].0
                    if currentStr == "english" { results.0 = Int(match) }
                    else if currentStr == "math" { results.1 = Int(match) }
                    else if currentStr == "reading" { results.2 = Int(match) }
                    else if currentStr == "science" { results.3 = Int(match) }
                }
                
                order += 1
            }
        }
        return results
    }
    
    static func normalizeGPA(string: String) -> Double? {
        var digitRegex: NSRegularExpression?
        do {
            digitRegex = try NSRegularExpression(pattern: "[1-9]\\d*(\\.\\d+)?")
        } catch {}
        guard let regex = digitRegex else { return nil }
        let nsString = string as NSString
        let matches = regex.matches(in: string
            , options: [], range: NSRange(location: 0, length: string.count)).map { nsString.substring(with: $0.range) }
        if matches.count > 0 {
            if let result = Double(matches.first!) {
                return result
            }
        }
        return nil
    }
    
    static func normalizeRank(string: String) -> (Double?, Double?, Double?) {
        var digitRegex: NSRegularExpression?
        do {
            digitRegex = try NSRegularExpression(pattern: "[1-9]\\d*(\\.\\d+)?")
        } catch {}
        guard let regex = digitRegex else { return (nil, nil, nil) }
        let nsString = string as NSString
        let matches = regex.matches(in: string, options: [], range: NSRange(location: 0, length: string.count)).map { (nsString.substring(with: $0.range), $0.range) }

        if string.contains("%") {
            let numbers = matches.filter { Double($0.0) != nil }.map { (Double($0.0)!, $0.1) }
            // find closest number before the %
            if let closestNumber = closestNumber(to: "%", in: nsString, numbersInString: numbers, before: true) {
                return (nil, nil, closestNumber)
            }
        }
        else if string.contains("/") {
            let numbers = matches.filter { Double($0.0) != nil }.map { (Double($0.0)!, $0.1) }
            let closestFirstHalfNumber = closestNumber(to: "/", in: nsString, numbersInString: numbers, before: true)
            let closestSecondHalfNumber = closestNumber(to: "/", in: nsString, numbersInString: numbers, before: false)
            
            return (closestFirstHalfNumber, closestSecondHalfNumber, nil)
        }
        
        return (nil, nil, nil)
    }
    
    static func normalizeGender(string: String) -> String {
        let keywords = ["female", "girl", "f", "g","male", "boy", "m", "b","other"]
        let lowercased = string.lowercased()
        var matchedKeywords:[String] = []
        for keyword in keywords {
            if lowercased.contains(keyword) {
                matchedKeywords.append(keyword)
            }
        }
        if matchedKeywords.contains("female") { return "Female" }
        else if matchedKeywords.contains("male") { return "Male" }
        else if matchedKeywords.contains("other") { return "Other" }
        
        let splitted = lowercased.components(separatedBy: " ")
        for word in splitted {
            let newWord = self.getWordWithoutInstances(of: "\n", in: word)
            if newWord == "f" || newWord == "g" {
                return "Female"
            }
            else if newWord == "m" || newWord == "m" {
                return "Male"
            }
        }
        
        return "N/A"
    }
    
    static func closestNumber(to symbol: String, in string: NSString,numbersInString: [(Double, NSRange)], before: Bool) -> Double? {
        var closest = string.length
        var closestNumber: Double?
        let index = string.range(of: symbol).location
        for number in numbersInString {
            let distance = index - number.1.location
            if before ? (distance > 0 && distance < closest) : (distance < 0 && abs(distance) < closest) {
                closest = distance
                closestNumber = number.0
            }
        }
        return closestNumber
    }
    
    static func findLocationOfKeywords(string: String, keywords: [String]) -> Int? {
        var lowest: Int?
        for keyword in keywords {
            if let range = string.range(of: keyword) {
                let distance = Int(string.distance(from: string.startIndex, to:  range.lowerBound))
                if let low = lowest {
                    if distance < low {
                        lowest = distance
                    }
                }
                else {
                    lowest = distance
                }
            }
        }
        return lowest
    }
    
    static func getWordWithoutInstances(of sequence: String, in word: String) -> String {
        if let range = word.range(of: sequence) {
            var mutable = word
            mutable.removeSubrange(range)
            return getWordWithoutInstances(of: sequence, in: mutable)
        }
        return word
    }
}
