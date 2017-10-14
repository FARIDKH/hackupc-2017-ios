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
    let token = "token"
    let id = "user_id"
}

class AuthApi {
    var commonData: CommonData;
    
    init() {
        self.commonData = CommonData();
    }
    
    static func getMyUserId() -> Int{
        if hasLocalUserData() {
            let defaults = UserDefaults.standard
            return defaults.integer(forKey: AuthKeys().id)
        } else {
            return 0
        }
    }
    
    static func setPostParams(userId: Int, token: String){
        let defaults = UserDefaults.standard
        defaults.setValue(token, forKey: AuthKeys().token)
        defaults.setValue(userId, forKey: AuthKeys().id)
        defaults.synchronize()
    }
    
    static func getPostParams() -> Dictionary<String, String>{
        let defaults = UserDefaults.standard
        return ["userid": defaults.string(forKey: AuthKeys().id) ?? "", "token": defaults.string(forKey: AuthKeys().token) ?? ""]
    }
    
    static func removePostParams() {
        let defaults = UserDefaults.standard
        defaults.removeObject(forKey: AuthKeys().token)
        defaults.synchronize()
        FBSDKLoginManager().logOut()
        //        AuthApi().logout()
    }
    
    static func hasLocalUserData() -> Bool{
        let defaults = UserDefaults.standard
        return defaults.string(forKey: AuthKeys().token) != nil
    }
    
    func login (
        email: String,
        password: String,
        onComplete: ((_ result: Int, _ message: String) -> Void)? = nil) {
        
        let parameters: Parameters = [
            "email": email,
            "password": password];
        
        Alamofire.request(self.commonData.getServerUrl() + "user/login", method: .post, parameters: parameters).responseJSON { responseJson in
            
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
}

