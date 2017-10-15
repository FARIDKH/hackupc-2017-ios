//
//  NoteApi.swift
//  HNotes-ios
//
//  Created by Karim Karimov on 10/14/17.
//  Copyright © 2017 Karim Karimov. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

class NoteApi {
    var commonData: CommonData;
    
    init() {
        self.commonData = CommonData();
    }
    
    func uploadLocalNotes (
        notes: [Note],
        onComplete: ((_ result: Int, _ message: String) -> Void)? = nil) {
        
        var parameters: Parameters = AuthApi.getPostParams()
        parameters["notes"] = notes
        
        Alamofire.request(self.commonData.getServerUrl() + "user/notes", method: .post, parameters: parameters).responseJSON { responseJson in
            
            switch responseJson.result {
            case .success(_):
                let json = JSON(responseJson.data as Any)
                
                if Response().checkResponseFromJson(json: json.rawValue) == 1 {
                    onComplete?(1, "")
                }else{
                    onComplete?(Response().checkResponseFromJson(json: json.rawValue), Response().getErrorMessageFromJson(json: json))
                }
            case .failure(_):
                onComplete?(
                    0, "Error occurred")
            }
        }
    }
    
    func getNotes (
        onComplete: ((_ result: Int, _ message: String, _ notes: [Note]) -> Void)? = nil) {
        
        let parameters: Parameters = AuthApi.getPostParams()
        var notes = [Note]()
        print("\(self.commonData.getServerUrl())notes?user_id=\(parameters[AuthKeys().id] as! String)&api_token=\(parameters[AuthKeys().token] as! String)")
        
        Alamofire.request("\(self.commonData.getServerUrl())notes?user_id=\(parameters[AuthKeys().id] as! String)&api_token=\(parameters[AuthKeys().token] as! String)").responseJSON { responseJson in
            
            print(responseJson)
            
            switch responseJson.result {
            case .success(_):
                let json = JSON(responseJson.data as Any)
                
                if Response().checkResponseFromJson(json: json.rawValue) == 1 {
                    notes = Note().getInstanceArray(from_data: json["data"]["notes"])
                    onComplete?(1, "", notes)
                } else {
                    onComplete?(Response().checkResponseFromJson(json: json.rawValue), Response().getErrorMessageFromJson(json: json), notes)
                }
            case .failure(_):
                onComplete?(
                    0, "Error occurred", notes)
            }
        }
    }
    
    func deleteNote (
        id: String,
        onComplete: ((_ result: Int, _ message: String) -> Void)? = nil) {
        
        let parameters: Parameters = AuthApi.getPostParams()
        
        print("\(self.commonData.getServerUrl())notes/delete/\(id)?user_id=\(String(describing: parameters[AuthKeys().id]))&api_token=\(String(describing: parameters[AuthKeys().token]))")
        
        Alamofire.request("\(self.commonData.getServerUrl())notes/delete/\(id)?user_id=\(String(describing: parameters[AuthKeys().id]))&api_token=\(String(describing: parameters[AuthKeys().token]))").responseJSON { responseJson in
            
            switch responseJson.result {
                
            case .success(_):
                let json = JSON(responseJson.data as Any)
                
                if Response().checkResponseFromJson(json: json.rawValue) == 1 {
                    onComplete?(1, "")
                } else {
                    onComplete?(Response().checkResponseFromJson(json: json.rawValue), Response().getErrorMessageFromJson(json: json))
                }
            case .failure(_):
                onComplete?(
                    0, "Error occurred")
            }
        }
    }
    
    func uploadPhoto(_ image_file: UIImage,
                     onComplete: ((_ result: Int, _ message: String, _ note: Note) -> Void)? = nil){
        
        let parameters: Parameters = [
            "title": "Test-ios"
        ];
        
        Alamofire.upload(multipartFormData: { (multipartFormData) in
            multipartFormData.append(
                UIImageJPEGRepresentation(image_file, 1)!,
                withName: "image",
                fileName: "testios.jpeg",
                mimeType: "image/jpeg")
            for (key, value) in parameters {
                multipartFormData.append((value as AnyObject).data(using: String.Encoding.utf8.rawValue)!, withName: key)
            }
        }, to: self.commonData.getServerUrl() + "/notes")
        { (result) in
            
            let note = Note()
            
            switch result {
            case .success(let upload, _, _):
                
                upload.uploadProgress(closure: { (progress) in
                    //Print progress
                })
                
                upload.responseJSON { responseJson in
                    let json = JSON(responseJson.data as Any)
                    
                    print(json)
                    
                    if Response().checkResponseFromJson(json: json.rawValue) == 1 {
                        AuthApi.setPostParams(userId: json["data"]["user"]["id"].intValue, token: json["data"]["user"]["api_token"].stringValue, userName: json["data"]["user"]["full_name"].stringValue)
                        onComplete?(1, "", note)
                    } else {
                        onComplete?(Response().checkResponseFromJson(json: json.rawValue), Response().getErrorMessageFromJson(json: json), note)
                    }
                }
                
            case .failure(_):
                onComplete?(0, NSLocalizedString("connection_error", comment: ""), note)
            }
        }
    }
    
    func getShareUrl(id: Int,
                     onComplete: ((_ result: Int, _ message: String, _ url: String) -> Void)? = nil) {
        
        var parameters: Parameters = AuthApi.getPostParams()
        parameters["note_id"] = id
        print(parameters)
        print("\(self.commonData.getServerUrl())notes/share")
        
        Alamofire.request("\(self.commonData.getServerUrl())notes/share", method: .post, parameters: parameters).responseJSON { responseJson in
            
            print(responseJson)
            var shareUrl = ""
            
            switch responseJson.result {
            case .success(_):
                let json = JSON(responseJson.data as Any)
                
                if Response().checkResponseFromJson(json: json.rawValue) == 1 {
                    shareUrl = json["data"]["url"].stringValue
                    onComplete?(1, "", shareUrl)
                } else {
                    onComplete?(Response().checkResponseFromJson(json: json.rawValue), Response().getErrorMessageFromJson(json: json), shareUrl)
                }
            case .failure(_):
                onComplete?(
                    0, "Error occurred", shareUrl)
            }
        }
    }
}
