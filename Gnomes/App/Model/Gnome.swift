//
//  Gnome.swift
//  Gnomes
//
//  Created by José Valderrama on 3/16/18.
//  Copyright © 2018 José Valderrama. All rights reserved.
//

import Foundation
import ObjectMapper

class Gnome: Mappable, CustomStringConvertible {
    
    var id: Int?
    var name: String?
    var thumbnail: String?
    var age: Int?
    var weight: Float?
    var height: Float?
    var hairColor: String?
    var professions: [String]?
    var friends: [String]?
    
    var description: String {
        guard let id = id, let name = name, let age = age else {
            return "No Description for this GNOME!"
        }
        
        return "\(id) - \(name), \(age)"
    }
    
    required init?(map: Map) {
    }
    
    func mapping(map: Map) {
        id <- map["id"]
        name <- map["name"]
        thumbnail <- map["thumbnail"]
        age <- map["age"]
        weight <- map["weight"]
        height <- map["height"]
        hairColor <- map["hair_color"]
        professions <- map["professions"]
        friends <- map["friends"]
    }
}
