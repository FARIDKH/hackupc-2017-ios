//
//  AuthApi.swift
//  HNotes-ios
//
//  Created by Karim Karimov on 10/14/17.
//  Copyright © 2017 Karim Karimov. All rights reserved.
//

import Foundation
import Alamofire
import FBSDKLoginKit
import SwiftyJSON

struct AuthKeys{
    let id = "user_id"
    let name = "user_name"
    let token = "token"
}

class AuthApi {
    var commonData: CommonData
    
    init() {
        self.commonData = CommonData()
    }
    
    static func getMyUserName() -> String {
        if hasLocalUserData() {
            let defaults = UserDefaults.standard
            return defaults.string(forKey: AuthKeys().name) ?? ""
        } else {
            return ""
        }
    }
    
    static func getMyUserId() -> Int{
        if hasLocalUserData() {
            let defaults = UserDefaults.standard
            return defaults.integer(forKey: AuthKeys().id)
        } else {
            return 0
        }
    }
    
    static func setPostParams(userId: Int, token: String, userName: String){
        let defaults = UserDefaults.standard
        defaults.setValue(token, forKey: AuthKeys().token)
        defaults.setValue(userId, forKey: AuthKeys().id)
        defaults.setValue(userName, forKey: AuthKeys().name)
        defaults.synchronize()
    }
    
    static func getPostParams() -> Dictionary<String, String>{
        let defaults = UserDefaults.standard
        return ["user_id": defaults.string(forKey: AuthKeys().id) ?? "", "token": defaults.string(forKey: AuthKeys().token) ?? ""]
    }
    
    static func removePostParams() {
        let defaults = UserDefaults.standard
        defaults.removeObject(forKey: AuthKeys().token)
        defaults.removeObject(forKey: AuthKeys().id)
        defaults.removeObject(forKey: AuthKeys().name)
        defaults.synchronize()
        FBSDKLoginManager().logOut()
    }
    
    static func hasLocalUserData() -> Bool{
        let defaults = UserDefaults.standard
        return defaults.string(forKey: AuthKeys().token) != nil
    }
    
    func login (
        access_token: String,
        onComplete: ((_ result: Int, _ message: String) -> Void)? = nil) {
        
        let parameters: Parameters = ["access_token": access_token]
        
        Alamofire.request(self.commonData.getServerUrl() + "login/facebook", method: .post, parameters: parameters).responseJSON { responseJson in
            
            switch responseJson.result {
            case .success(_):
                let json = JSON(responseJson.data as Any)
                
//                print(json)
                
                if Response().checkResponseFromJson(json: json.rawValue) == 1 {
                    AuthApi.setPostParams(userId: json["data"]["user"]["id"].intValue, token: json["data"]["user"]["api_token"].stringValue, userName: json["data"]["user"]["full_name"].stringValue)
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
}

