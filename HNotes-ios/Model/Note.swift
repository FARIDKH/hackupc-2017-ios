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
    @objc dynamic var photoUrl = ""
    @objc dynamic var unique_id = ""
    
    func getInstance(from_data: JSON) -> Note{
        let json = from_data
        
        let instance = Note()
        instance.id = json["id"].intValue
        instance.title = json["title"].stringValue
        instance.date = json["updated_at"].stringValue
        instance.content = json["content"].stringValue
        instance.photoUrl = json["image_url"].stringValue
        instance.unique_id = json["unique_id"].stringValue
                
        return instance
    }
    
    func getInstanceArray(from_data: JSON) -> [Note]{
        let json = from_data
        
        var array = [Note]()
        for (_,subJson):(String, JSON) in json {
            array.append(getInstance(from_data: subJson))
        }
        print(array)
        
        return array
    }
}
