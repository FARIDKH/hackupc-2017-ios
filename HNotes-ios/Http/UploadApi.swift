//
//  UploadApi.swift
//  HNotes-ios
//
//  Created by Karim Karimov on 10/14/17.
//  Copyright © 2017 Karim Karimov. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

class UploadApi {
    var commonData: CommonData;
    
    init() {
        self.commonData = CommonData();
    }
    
    func upload (
        image: UIImage,
        onComplete: ((_ result: Int, _ message: String, _ note: Note) -> Void)? = nil) {
        
        let imgData = UIImageJPEGRepresentation(image, 0.5)!
        var resultNote = Note()
        
        let parameters = ["title": "test-ios"]
        
        Alamofire.upload(multipartFormData: { multipartFormData in
            multipartFormData.append(imgData, withName: "image", fileName: "sometest.jpg", mimeType: "image/jpeg")
            for (key, value) in parameters {
                multipartFormData.append(value.data(using: String.Encoding.utf8)!, withName: key)
            }
        },
                         to: commonData.getServerUrl() + "notes")
        { (result) in
            switch result {
            case .success(let upload, _, _):
                
                upload.uploadProgress(closure: { (progress) in
                    print("Upload Progress: \(progress.fractionCompleted)")
                })
                
                upload.responseJSON { responseJson in
                    let json = JSON(responseJson.data as Any)
                    
                    print(json)
                    print("success")
                    
                    if Response().checkResponseFromJson(json: json.rawValue) == 1 {
                        resultNote = Note().getInstance(from_data: json["note"])
                        
                        onComplete?(1, "", resultNote)
                    }else{
                        onComplete?(Response().checkResponseFromJson(json: json.rawValue), Response().getErrorMessageFromJson(json: json), resultNote)
                    }
                }
                
            case .failure(let encodingError):
                onComplete?(0, "Encoding error has been occurred, please retry later", resultNote)
            }
        }
    }
}
