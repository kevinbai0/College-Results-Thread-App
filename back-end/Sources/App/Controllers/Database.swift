//
//  Database.swift
//  App
//
//  Created by Kevin Bai on 2018-10-15.
//

import MongoKitten

final class Database {
    static var server: MongoKitten.Server?
    static var database: MongoKitten.Database?
    static var collectionApplicantsRaw: MongoKitten.Collection? {
        get {
            return database?["rawApplicants"]
        }
    }
    static var collectionApplicants: MongoKitten.Collection? {
        get {
            return database?["applicants"]
        }
    }
    static var collectionSchools: MongoKitten.Collection? {
        get {
            return database?["schools"]
        }
    }
    
    class func login() -> Bool {
        do {
            server = try MongoKitten.Server("mongodb://admin:12341234@cluster0-shard-00-00-kfgg1.mongodb.net:27017,cluster0-shard-00-01-kfgg1.mongodb.net:27017,cluster0-shard-00-02-kfgg1.mongodb.net:27017/test?ssl=true&replicaSet=Cluster0-shard-0&authSource=admin&retryWrites=true")
            
            if server!.isConnected {
                database = MongoKitten.Database(named: "applicants", atServer: server!)
                return true
            }
        }
        catch {}
        return false
    }
    
    class func stayLoggedIn() {
        if let _ = server?.isConnected {}
        else { _ = self.login() }
    }
}
