//
//  CommonData.swift
//  HNotes-ios
//
//  Created by Karim Karimov on 10/14/17.
//  Copyright © 2017 Karim Karimov. All rights reserved.
//

import Foundation

class CommonData{
    var server_url: String;
    
    init(){
        self.server_url = "http://www.hnotes.org/api/"
    }
    
    func getServerUrl() -> String{
        return self.server_url;
    }
}
