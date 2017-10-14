//
//  WebViewController.swift
//  HNotes-ios
//
//  Created by Karim Karimov on 10/14/17.
//  Copyright © 2017 Karim Karimov. All rights reserved.
//

import UIKit
import WebKit

class NoteDetailViewController: UIViewController, WKUIDelegate {
    
    var webKit: WKWebView!
    var htmlContent: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initVars()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func initVars() {
        webKit.loadHTMLString(htmlContent, baseURL: nil)
        
        //#0093e9;
        //background-image: linear-gradient(160deg, #0093e9 0%, #80d0c7 100%);
    }
}
