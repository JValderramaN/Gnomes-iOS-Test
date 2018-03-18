//
//  Brastlewark.swift
//  Gnomes
//
//  Created by José Valderrama on 3/16/18.
//  Copyright © 2018 José Valderrama. All rights reserved.
//

import Foundation
import ObjectMapper

class Brastlewark: Mappable {
    
    static var shared: Brastlewark?
    var gnomes: [Gnome]?
    
    required init?(map: Map) {
    }
    
    func mapping(map: Map) {
        gnomes <- map["Brastlewark"]
        Brastlewark.shared = self
    }
    
    func gnome(by gnomeName: String?) -> Gnome? {
        guard let gnomes = gnomes, let gnomeName = gnomeName else {
            return nil
        }
        
        for gnome in gnomes {
            if gnome.name == gnomeName {
                return gnome
            }
        }
        
        return nil
    }
}
