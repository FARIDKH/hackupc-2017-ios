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
                    AuthApi.setPostParams(userId: json["userid"].intValue, token: json["token"].stringValue)
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
        
        Alamofire.request("\(self.commonData.getServerUrl())user/notes?user_id=\(String(describing: parameters[AuthKeys().id]))&api_token=\(String(describing: parameters[AuthKeys().token]))").responseJSON { responseJson in
            
            switch responseJson.result {
            
            case .success(_):
                let json = JSON(responseJson.data as Any)
                
                if Response().checkResponseFromJson(json: json.rawValue) == 1 {
                    AuthApi.setPostParams(userId: json["userid"].intValue, token: json["token"].stringValue)
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
}
