//
//  Note.swift
//  HNotes-ios
//
//  Created by Karim Karimov on 10/14/17.
//  Copyright © 2017 Karim Karimov. All rights reserved.
//

import Foundation
import SwiftyJSON
import RealmSwift

class Note: Object {
    @objc dynamic var id = 0
    @objc dynamic var title = ""
    @objc dynamic var date = ""
    @objc dynamic var content = ""
    
    func getInstance(from_data: Any) -> Note{
        let json = JSON(from_data)
        
        let instance = Note()
        instance.id = json["id"].intValue
        instance.title = json["title"].stringValue
        instance.date = json["date"].stringValue
        instance.content = json["content"].stringValue
        
        return instance
    }
    
    func getInstanceArray(from_data: Any) -> [Note]{
        let json = JSON(from_data)
        
        var array = [Note]()
        for (_,subJson):(String, JSON) in json {
            array.append(getInstance(from_data: subJson))
        }
        
        return array
    }
}
