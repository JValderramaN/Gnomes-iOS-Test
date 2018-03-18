//
//  APILayer.swift
//  Gnomes
//
//  Created by José Valderrama on 3/16/18.
//  Copyright © 2018 José Valderrama. All rights reserved.
//

import Foundation
import Alamofire
import AlamofireObjectMapper

typealias ComplationHandler = (_ object: Any?, _ error: Error?) -> Void

class APILayer {
    
    static func getBrastlewarkData(with complationHandler: @escaping ComplationHandler) {
        let url = "https://raw.githubusercontent.com/rrafols/mobile_test/master/data.json"
        
        Alamofire.request(url).responseObject { (response: DataResponse<Brastlewark>) in

            guard let brastlewark = response.result.value else {
                complationHandler(nil, response.error)
                return
            }

            complationHandler(brastlewark, response.error)
        }
    }
}
