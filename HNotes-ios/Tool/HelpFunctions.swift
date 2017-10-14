//
//  HelpFunctions.swift
//  HNotes-ios
//
//  Created by Karim Karimov on 10/14/17.
//  Copyright © 2017 Karim Karimov. All rights reserved.
//

import Foundation
import UIKit
import SwiftMessages

extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}

extension UIView {
    func roundCorners(_ corners: UIRectCorner, radius: CGFloat) {
        let path = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        self.layer.mask = mask
    }
}

class HelpFunctions {
    //color
    static func hexStringToUIColor (hex:String) -> UIColor {
        var cString:String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        
        if (cString.hasPrefix("#")) {
            cString.remove(at: cString.startIndex)
        }
        
        if ((cString.characters.count) != 6) {
            return UIColor.gray
        }
        
        var rgbValue:UInt32 = 0
        Scanner(string: cString).scanHexInt32(&rgbValue)
        
        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
    
    //UI
    static func makeRoundedCorner(view: UIView, radius: Int){
        view.layer.cornerRadius = CGFloat(radius);
        view.clipsToBounds = true;
    }
    
    static func makeRoundedColorfulBorder(view: UIView, radius: Int, width: Int, color: String){
        view.backgroundColor = .clear
        view.layer.cornerRadius = CGFloat(radius)
        view.layer.borderWidth = CGFloat(width)
        view.layer.borderColor = hexStringToUIColor(hex: color).cgColor
    }
    
    //custom views
    static func createGradientBg(view: UIView, startColor: String, endColor: String){
        let gradient = CAGradientLayer()
        gradient.frame = view.bounds
        gradient.startPoint = CGPoint.zero;
        gradient.endPoint = CGPoint.init(x: 1, y: 0)
        gradient.colors = [HelpFunctions.hexStringToUIColor(hex: startColor).cgColor, HelpFunctions.hexStringToUIColor(hex: endColor).cgColor]
        view.layer.insertSublayer(gradient, at: 0)
    }
    
    static func addShadowToView(_ view: UIView){
        view.layer.cornerRadius = 8
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOffset = CGSize.init(width: 0.5, height: 0.5)
        view.layer.shadowOpacity = 0.2
        view.layer.shadowRadius = 2.0
    }
    
    //progress
    static func createProgress(indicator: UIActivityIndicatorView, view: UIView){
        indicator.frame = CGRect.init(x: 0.0, y: 0.0, width: 60.0, height: 60.0);
        indicator.center = view.center
        indicator.backgroundColor = UIColor.gray.withAlphaComponent(0.4)
        HelpFunctions.makeRoundedCorner(view: indicator, radius: 5);
        view.addSubview(indicator)
        indicator.bringSubview(toFront: view)
    }
    
    //progress pop-up
    static func showProgress(indicator: UIActivityIndicatorView, type: Bool){
        if(type){
            indicator.startAnimating()
            UIApplication.shared.isNetworkActivityIndicatorVisible = true
            UIApplication.shared.beginIgnoringInteractionEvents()
        }else{
            indicator.stopAnimating()
            UIApplication.shared.isNetworkActivityIndicatorVisible = false
            UIApplication.shared.endIgnoringInteractionEvents()
        }
    }
    
    //Alerts
    static func showErrorAlert(_ text: String, _ vc: UIViewController){
        let alert = UIAlertController(title: NSLocalizedString("error", comment: ""),
                                      message: text, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: NSLocalizedString("okay", comment: ""),
                                      style: UIAlertActionStyle.cancel,
                                      handler: nil))
        
        alert.popoverPresentationController?.sourceView = vc.view
        alert.popoverPresentationController?.sourceRect = vc.view.bounds
        
        vc.present(alert, animated: true, completion: nil)
    }
    
    static func showErrorWithCloseAlert(_ text: String, _ vc: UIViewController){
        let alert = UIAlertController(title: NSLocalizedString("error", comment: ""),
                                      message: text, preferredStyle: UIAlertControllerStyle.alert)
        
        alert.addAction(UIAlertAction(title: NSLocalizedString("okay", comment: ""),
                                      style: UIAlertActionStyle.cancel,
                                      handler: { (action) in
                                        vc.dismiss(animated: true, completion: nil)
        }))
        
        if let presenter = alert.popoverPresentationController {
            presenter.sourceView = vc.view
            presenter.sourceRect = vc.view.bounds
        }
        
        vc.present(alert, animated: true, completion: nil)
    }
    
    static func showLoginAlert(_ vc: UIViewController){
        let alert = UIAlertController(title: NSLocalizedString("session_expired", comment: ""),
                                      message: "Your session is over, please kogin again", preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: NSLocalizedString("login", comment: ""),
                                      style: UIAlertActionStyle.cancel,
                                      handler: {(alert: UIAlertAction!) in
                                        AuthApi.removePostParams()
                                        let loginViewControllerObj = vc.storyboard?.instantiateViewController(withIdentifier: "LoginViewController") as? LoginViewController
                                        vc.present(loginViewControllerObj!, animated: true)
        }))
        alert.popoverPresentationController?.sourceView = vc.view
        alert.popoverPresentationController?.sourceRect = vc.view.bounds
        
        vc.present(alert, animated: true, completion: nil)
    }
    
    static func showSuccessAlert(_ text: String, _ vc: UIViewController){
        let alert = UIAlertController(title: NSLocalizedString("success", comment: ""),
                                      message: text, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: NSLocalizedString("okay", comment: ""),
                                      style: UIAlertActionStyle.cancel,
                                      handler: nil))
        alert.popoverPresentationController?.sourceView = vc.view
        alert.popoverPresentationController?.sourceRect = vc.view.bounds
        
        vc.present(alert, animated: true, completion: nil)
    }
    
    static func showWarningCardAlert(_ text: String, showButton: Bool){
        let view: MessageView
        view = MessageView.viewFromNib(layout: .cardView)
        
        view.configureContent(title: "", body: text, iconImage: nil, iconText: nil, buttonImage: nil, buttonTitle: "Okay", buttonTapHandler: { _ in SwiftMessages.hide() })
        
        let iconStyle: IconStyle
        iconStyle = .light
        view.configureTheme(.warning, iconStyle: iconStyle)
        view.titleLabel?.isHidden = true
        view.button?.isHidden = !showButton
        
        // Config setup
        var config = SwiftMessages.defaultConfig
        config.presentationStyle = .bottom
        config.presentationContext = .window(windowLevel: UIWindowLevelNormal)
        config.shouldAutorotate = false
        config.interactiveHide = true
        
        // Show
        SwiftMessages.show(config: config, view: view)
    }
    
    static func showSuccessCardAlert(_ text: String, showButton: Bool){
        let view: MessageView
        view = MessageView.viewFromNib(layout: .cardView)
        
        view.configureContent(title: "", body: text, iconImage: nil, iconText: nil, buttonImage: nil, buttonTitle: "Okay", buttonTapHandler: { _ in SwiftMessages.hide() })
        
        let iconStyle: IconStyle
        iconStyle = .light
        view.configureTheme(.success, iconStyle: iconStyle)
        view.titleLabel?.isHidden = true
        view.button?.isHidden = !showButton
        
        // Config setup
        var config = SwiftMessages.defaultConfig
        config.presentationStyle = .bottom
        config.presentationContext = .window(windowLevel: UIWindowLevelNormal)
        config.shouldAutorotate = false
        config.interactiveHide = true
        
        // Show
        SwiftMessages.show(config: config, view: view)
    }
    
    static func showErrorCardAlert(_ text: String, showButton: Bool){
        let view: MessageView
        view = MessageView.viewFromNib(layout: .cardView)
        
        view.configureContent(title: "", body: text, iconImage: nil, iconText: nil, buttonImage: nil, buttonTitle: "Okay", buttonTapHandler: { _ in SwiftMessages.hide() })
        
        let iconStyle: IconStyle
        iconStyle = .light
        view.configureTheme(.error, iconStyle: iconStyle)
        view.titleLabel?.isHidden = true
        view.button?.isHidden = !showButton
        
        // Config setup
        var config = SwiftMessages.defaultConfig
        config.presentationStyle = .bottom
        config.presentationContext = .window(windowLevel: UIWindowLevelNormal)
        config.shouldAutorotate = false
        config.interactiveHide = true
        
        // Show
        SwiftMessages.show(config: config, view: view)
    }
}
