//
//  LoginViewController.swift
//  HNotes-ios
//
//  Created by Karim Karimov on 10/14/17.
//  Copyright © 2017 Karim Karimov. All rights reserved.
//

import UIKit
import GoogleSignIn
import FBSDKLoginKit

class LoginViewController: UIViewController, GIDSignInUIDelegate, UIGestureRecognizerDelegate {

    @IBOutlet weak var backIc: UIImageView!
    @IBOutlet weak var googleView: UIView!
    @IBOutlet weak var fbView: UIView!
    
    var indicator: UIActivityIndicatorView = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.white)
    var tapGestureRecognizer = UITapGestureRecognizer()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(self.receiveToggleAuthUINotification(_:)),
                                               name: NSNotification.Name(rawValue: "ToggleAuthUINotification"),
                                               object: nil)
        initViews()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func initViews(){
        self.navigationController?.interactivePopGestureRecognizer?.delegate = self
        
        HelpFunctions.createGradientBg(view: self.view, startColor: "#0093e9", endColor: "#80d0c7")

        //facebook button
        self.tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(onBack(_:)))
        backIc.addGestureRecognizer(tapGestureRecognizer)
        
        //facebook button
        self.tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(onLoginViaFacebook(_:)))
        fbView.addGestureRecognizer(tapGestureRecognizer)
        
        //google button
        self.tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(onLoginViaGoogle(_:)))
        googleView.addGestureRecognizer(tapGestureRecognizer)
        
        //google login button
        GIDSignIn.sharedInstance().uiDelegate = self
    }
    
    //fb login
    @objc func onLoginViaFacebook(_ sender: Any) {
        HelpFunctions.showProgress(indicator: indicator, type: true)
        FBSDKLoginManager().logIn(withReadPermissions: ["public_profile"], from: self){
            (result, err) in
            
            if err != nil{
                HelpFunctions.showProgress(indicator: self.indicator, type: false)
                HelpFunctions.showErrorAlert(NSLocalizedString("error_facebook_login", comment: ""), self)
                return;
            }
            
            if(result?.token.tokenString != nil){
                AuthApi().login(access_token: (result?.token.tokenString)!!, onComplete: { (result, message) in
                    HelpFunctions.showProgress(indicator: self.indicator, type: false)
                    if(result == 1) {
                        self.navigationController?.popViewController(animated: true)
                    } else {
                        HelpFunctions.showErrorCardAlert("Sorry, error occured while login", showButton: true)
                    }
                })
            }
        }
    }
    
    //Google login
    @objc func onLoginViaGoogle(_ sender: Any) {
        GIDSignIn.sharedInstance().signIn()
    }
    
    @objc func receiveToggleAuthUINotification(_ notification: NSNotification) {
        if notification.name.rawValue == "ToggleAuthUINotification" {
            if notification.userInfo != nil {
                guard let userInfo = notification.userInfo as? [String:String] else { return }
                
//                Auth().socialLogin(full_name: userInfo["full_name"]!, email: userInfo["email"]!, google_id: userInfo["google_id"]!, onComplete: { (result, message) in
//                    Auth.setSocialParams(isSocialLogin: true, google_id: userInfo["google_id"]!)
//                    self.onComplete(result: result, message: message)
//                })
            }else{
                HelpFunctions.showProgress(indicator: self.indicator, type: false)
                HelpFunctions.showErrorAlert(NSLocalizedString("error_google_login", comment: ""), self)
            }
        }
    }
    
    //complete login
    func onComplete(result: Bool, message: String){
        HelpFunctions.showProgress(indicator: indicator, type: false)
        if(result){
            if let parent = self.navigationController?.parent as? HomeViewController{
                parent.isLogged = true
            }
            
            self.navigationController?.popViewController(animated: true)
        }else{
            HelpFunctions.showErrorAlert(message, self)
        }
    }

    @objc func onBack(_ sender: Any){
        self.navigationController?.popViewController(animated: true)
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
