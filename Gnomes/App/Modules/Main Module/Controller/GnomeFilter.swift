//
//  GnomeFilter.swift
//  Gnomes
//
//  Created by José Valderrama on 3/18/18.
//  Copyright © 2018 José Valderrama. All rights reserved.
//

import Foundation

enum GnomeFilter: String, CustomStringConvertible {
    case all = "All"
    case haveFriends = "Friends"
    case haveProfessions = "Professions"
    case centenary = "Centenary"
    
    var description: String {
        return NSLocalizedString(self.rawValue, comment: "")
    }
}
