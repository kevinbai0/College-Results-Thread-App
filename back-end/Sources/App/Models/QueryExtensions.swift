//
//  QueryExtensions.swift
//  App
//
//  Created by Kevin Bai on 2018-10-15.
//

import MongoKitten

extension Query {
    init(queries: [String:String]) {
        var document: Document = [:]
        let filtered = queries.filter { query in
            return query.value != "All"
        }
        for query in filtered {
            document[query.key] = query.value
        }
        self.init(document)
    }
}
