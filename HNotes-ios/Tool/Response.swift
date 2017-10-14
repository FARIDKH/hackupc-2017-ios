//
//  Response.swift
//  HNotes-ios
//
//  Created by Karim Karimov on 10/14/17.
//  Copyright © 2017 Karim Karimov. All rights reserved.
//

import Foundation
import SwiftyJSON

class Response{
    
    func getResponseMessage(code: Int) -> String{
        return "Error \(code)"
    }
    
    func checkResponseFromJson(json: Any) -> Int {
        let json = JSON(json)
        switch json["status"].intValue {
        case 200:
            return 1
        default:
            return 0
        }
    }
    
    func getErrorMessageFromJson(json: Any) ->String{
        let json = JSON(json)
        return getResponseMessage(code: json["code"].intValue)
    }
}
