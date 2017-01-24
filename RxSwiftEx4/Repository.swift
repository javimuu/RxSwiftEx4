//
//  Repository.swift
//  RxSwiftEx4
//
//  Created by muu van duy on 2017/01/23.
//  Copyright © 2017 muuvanduy. All rights reserved.
//

import Foundation
import ObjectMapper

class Repository: Mappable {
    var id: Int!
    var language: String!
    var url: String!
    var name: String!
    
    required init? (map: Map) { }
    
    func mapping(map: Map) {
        id <- map["id"]
        language <- map["language"]
        url <- map["url"]
        name <- map["name"]
    }
}
