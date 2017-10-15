//
//  FirstViewController.swift
//  HNotes-ios
//
//  Created by Karim Karimov on 10/14/17.
//  Copyright © 2017 Karim Karimov. All rights reserved.
//

import UIKit
import ImagePicker
import RealmSwift

class HomeViewController: UIViewController, ImagePickerDelegate{

    @IBOutlet weak var authView: UIView!
    @IBOutlet weak var authText: UILabel!
    @IBOutlet weak var authIc: UIImageView!
    
    @IBOutlet weak var takePhotoView: UIView!
    @IBOutlet weak var historyView: UIView!
    
    var isLogged = false
    
    var tapGestureRecognizer = UITapGestureRecognizer()
    
    override func viewDidLoad() {
        super.viewDidLoad()
     
        initVars()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        updateAuthView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func initVars(){
        HelpFunctions.createGradientBg(view: self.view, startColor: "#0093e9", endColor: "#80d0c7")
        
        tapGestureRecognizer.numberOfTapsRequired = 1
        
        self.tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(onTakePhoto(_:)))
        takePhotoView.addGestureRecognizer(tapGestureRecognizer)
        
        self.tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(onAuth(_:)))
        authView.addGestureRecognizer(tapGestureRecognizer)
        
        self.tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(onHistory(_:)))
        historyView.addGestureRecognizer(tapGestureRecognizer)
        
        isLogged = AuthApi.hasLocalUserData()
    }
    
    func updateAuthView(){
        isLogged = AuthApi.hasLocalUserData()
        
        if(isLogged) {
            print("isLogged")
            self.authText.text = AuthApi.getMyUserName()
            self.authIc.image = UIImage.init(named: "ic_logout")
        } else {
            print("notLogged")
            self.authText.text = "Login"
            self.authIc.image = UIImage.init(named: "ic_login")
        }
    }

    // MARK: - Click handler
    @objc func onTakePhoto(_ recognizer: UITapGestureRecognizer){
        var config = Configuration()
        config.doneButtonTitle = "DONE"
        config.noImagesTitle = "Sorry! There are no images here!"
        config.recordLocation = false
        config.allowMultiplePhotoSelection = false
        
        let imagePicker = ImagePickerController(configuration: config)
        imagePicker.delegate = self
        
        present(imagePicker, animated: true, completion: nil)
    }
    
    @objc func onAuth(_ recognizer: UITapGestureRecognizer) {
        if(AuthApi.hasLocalUserData()){
            onLogout()
        } else {
            onLogin()
        }
    }
    
    @objc func onHistory(_ recognizer: UITapGestureRecognizer) {
        if let vc = self.storyboard?.instantiateViewController(withIdentifier: "NotesViewController") as? NotesViewController{
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    func onLogin() {
        if let vc = self.storyboard?.instantiateViewController(withIdentifier: "LoginViewController") as? LoginViewController{
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    func onLogout(){
        AuthApi.removePostParams()
        isLogged = false
        if let vc = self.storyboard?.instantiateViewController(withIdentifier: "LoginViewController") as? LoginViewController{
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    // MARK: - ImagePickerDelegate
    func cancelButtonDidPress(_ imagePicker: ImagePickerController) {
        imagePicker.dismiss(animated: true, completion: nil)
    }
    
    func wrapperDidPress(_ imagePicker: ImagePickerController, images: [UIImage]) {
        guard images.count > 0 else { return }
    }
    
    func doneButtonDidPress(_ imagePicker: ImagePickerController, images: [UIImage]) {
        imagePicker.dismiss(animated: true, completion: nil)
        
        if(images.count < 1){ return }
        
        UploadApi().upload(image: images[0]) { (result, message, resultNote) in
            if(result == 1){
                print("result home")
                print(resultNote)
                let realm = try! Realm()
                
                try! realm.write {
                    realm.add(resultNote)
                }
                
                HelpFunctions.showSuccessCardAlert("Image uploaded successfully", showButton: false)
            }else{
                HelpFunctions.showErrorCardAlert("Error occured", showButton: true)
            }
        }
    }
}

