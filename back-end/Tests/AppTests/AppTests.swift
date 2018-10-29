@testable import App
@testable import SwiftSoup
import XCTest
import Vapor

final class AppTests: XCTestCase {
    func testNothing() throws {
        // add your tests here
        XCTAssert(true)
    }
    
    func testSATNormalization() {
        let tests: [(String, (Int?, Int?, Int?))] = [
            ("1430 (710 math, 720 verbal, 22 essay)",(720, 710, 1430)),
            ("1560 780/780 One sitting 40/37", (780, 780, 1560)),
            ("1580 (790/790)", (790,790, 1580)),
            ("1400 (700 both english and math.. yikes)", (700, nil, 1400)),
            ("1580 (800 M, 780 R/W)", (780, 800, 1580)),
            ("1450 ", (nil, nil, 1450))
        ]
        
        for test in tests {
            let result = Normalizer.normalizeSAT(string: test.0)
            XCTAssert(result == test.1)
        }
    }
    
    func testACTNormalization() {
        let tests: [(String, (Int?, Int?, Int?, Int?, Int?))] = [
            ("33 (35 E, 29 M, 36 R, 30 S)", (35, 29, 36, 30, 33)),
            ("36 (36 everything, 10/12 essay)", (36, nil, 10, 12, 36)),
            ("36 (E 36, M 36, R 36, S 36)", (36, 36, 36, 36, 36)),
            ("35", (nil, nil, nil, nil, 35))
        ]
        for test in tests {
            let result = Normalizer.normalizeACT(string: test.0)
            XCTAssert(result == test.1)
        }
    }
    
    func testGPANormalization() {
        let tests: [(String, Double?)] = [
            ("4.0", 4.0),
            ("NA", nil),
            ("School does not show", nil),
            ("4.8 or so", 4.8),
            ("3.97", 3.97)
        ]
        for test in tests {
            let result = Normalizer.normalizeGPA(string: test.0)
            XCTAssert(result == test.1)
        }
    }
    
    func testRankNormalization() {
        let tests: [(String, (Double?, Double?, Double?))] = [
            ("9/400", (9,400,nil)),
            ("At least top 15% out of a class of about 600 (my school has not updated rankings since the end of freshman year but a lot of kids get valedictorian just by taking no AP’s)", (nil,nil,15)),
            ("16/250 (but my school only ranks based on unweightrd gpa so take this with a grain of salt)", (16,250, nil))
        ]
        for test in tests {
            let result = Normalizer.normalizeRank(string: test.0)
            XCTAssert(result == test.1)
        }
    }
    
    func testGenderNormalization() {
        let tests: [(String, String)] = [
            ("Female", "Female"),
            ("Male (double rip)", "Male"),
            ("don’t assume it (male)", "Male"),
            ("", "N/A"),
            ("afjoa ajfasjfa ofalsdf", "N/A"),
            ("F", "Female"),
            ("M", "Male"),
            ("M (ouch)", "Male")
        ]
        
        for test in tests {
            let result = Normalizer.normalizeGender(string: test.0)
            XCTAssert(result == test.1)
        }
    }
    
    func testParsePost() {
        let expectation = self.expectation(description: "Parsing")

        let controller = UpdateThreadController()
        let commentId = "21017776"
        guard let url = URL(string: "https://talk.collegeconfidential.com/discussion/comment/\(commentId)/#Comment_\(commentId)") else { return }
        var urlRequest = URLRequest(url: url)
        urlRequest.setValue("text/html", forHTTPHeaderField: "Content-Type")
        urlRequest.setValue("Mozilla/5.0 (Macintosh; Intel Mac OS X 10_11_1) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/69.0.3497.100 Safari/537.36", forHTTPHeaderField: "User-Agent")
        
        var testResult: ApplicantModel = [:]
        let task = URLSession.shared.dataTask(with: urlRequest) { (data, response, error) in
            if let _ = error { return }
            guard let data = data else { return }
            guard let html = String(data: data, encoding: .utf8) else { return }
            do {
                let doc = try SwiftSoup.parse(html)
                let listItems = try doc.select("ul.MessageList > li")
                try listItems.forEach { item in
                    if item.id() == "Comment_\(commentId)" {
                        let message = try item.select(".Item-BodyWrap .Message").html()
                        let rawApplicant = controller.completeApplicantFromCommentChunks(commentChunks: message.components(separatedBy: "<br>"), currentApplicant: ApplicantRawModel())
                        var normalizedApplicant = ApplicantModel()
                        normalizedApplicant = Normalizer.normalize(normalizedApplicant: normalizedApplicant, rawApplicant: rawApplicant)
                        testResult = normalizedApplicant
                    }
                }
            }
            catch {}
            expectation.fulfill()
        }
        
        task.resume()
        waitForExpectations(timeout: 5, handler: nil)
        XCTAssert("Male" == String(testResult["gender"] ?? ""))
        
    }
    
    static let allTests = [
        ("testNothing", testNothing)
    ]
}
