import Vapor
import MongoKitten
import Foundation
import ExtendedJSON

let updateThreadController = UpdateThreadController()
let getApplicantsController = GetApplicantsController()
/// Register your application's routes here.
public func routes(_ router: Router) throws {
    router.post("/api/posts") { (req: Request) -> String in
        Database.stayLoggedIn()
        do {
            guard let data = req.http.body.data else {
                return "Err in Body"
            }
            let body = try JSONDecoder().decode(ThreadUpdateStruct.self, from: data)
            // get request to the thread
            return updateThreadController.parseHTMLAndProcessComments(body: body)
        }
        catch {
            return "Err in Body"
        }
    }
    router.get("/api/posts") { (req: Request) -> String in
        Database.stayLoggedIn()
        let queries = getApplicantsController.getQueries(from: req)
        return getApplicantsController.getApplicantsIds(req: req, queries: queries)
    }
    router.post("/api/batches/getPosts") { req -> String in
        Database.stayLoggedIn()
        return getApplicantsController.getApplicantsById(req: req, queries: [:])
    }
    
    router.get("/api/posts/:_commentId") { (req: Request) -> String in
        Database.stayLoggedIn()
        let queries: [String:String] = getApplicantsController.getQueries(from: req)
        return getApplicantsController.getApplicant(req: req, queries: queries)
    }
    router.get("/api/schools") { (req: Request) -> String in
        Database.stayLoggedIn()
        do {
            var schools = "["
            let schoolsDocument = try Database.collectionSchools?.find()
            guard let docCount = try schoolsDocument?.count() else { return "" }
            var counter = 0
            
            try schoolsDocument?.forEach { doc in
                guard let school = String(doc["school"]) else { return }
                if counter < docCount - 1 {
                    schools += "\"\(school)\", "
                }
                else {
                    schools += "\"\(school)\""
                }
                counter += 1
            }
            schools += "]"
            return schools
        }
        catch {}
        
        return "Error"
    }
    router.delete("/api/posts") { (req: Request) -> String in
        Database.stayLoggedIn()
        do {
            try Database.collectionApplicantsRaw?.remove()
            try Database.collectionApplicants?.remove()
            try Database.collectionSchools?.remove()
        }
        catch { return "Error" }
        return "Removed All"
    }
}
