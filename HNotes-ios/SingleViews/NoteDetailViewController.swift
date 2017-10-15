//
//  WebViewController.swift
//  HNotes-ios
//
//  Created by Karim Karimov on 10/14/17.
//  Copyright © 2017 Karim Karimov. All rights reserved.
//

import UIKit
import WebKit
import RealmSwift

class NoteDetailViewController: UIViewController, WKUIDelegate {
    
    @IBOutlet weak var toolbarView: UIView!
    @IBOutlet weak var toolbarTitle: UILabel!
    @IBOutlet weak var backIc: UIImageView!
    @IBOutlet weak var shareIc: UIImageView!
    @IBOutlet weak var deleteIc: UIImageView!
    @IBOutlet weak var web: WKWebView!
    
    var note = Note()

    var tapGestureRecognizer = UITapGestureRecognizer()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initVars()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func initVars() {
        toolbarTitle.text = note.title
        print(note.content)
        web.loadHTMLString(note.content, baseURL: nil)
        
        HelpFunctions.createGradientBg(view: toolbarView, startColor: "#0093e9", endColor: "#80d0c7")
        
        tapGestureRecognizer.numberOfTapsRequired = 1
        
        self.tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(onBack(_:)))
        backIc.addGestureRecognizer(tapGestureRecognizer)
        
        self.tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(onDelete(_:)))
        deleteIc.addGestureRecognizer(tapGestureRecognizer)
        
        self.tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(onShare(_:)))
        shareIc.addGestureRecognizer(tapGestureRecognizer)
    }
    
    // MARK: - Click handler
    @objc func onBack(_ recognizer: UITapGestureRecognizer){
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func onDelete(_ recognizer: UITapGestureRecognizer){
        if(AuthApi.hasLocalUserData()){
            NoteApi().deleteNote(id: note.unique_id, onComplete: { (result, message) in
                if result == 1 {
                    HelpFunctions.showSuccessCardAlert("Note has been deleted", showButton: false)
                    self.navigationController?.popViewController(animated: true)
                }else{
                    HelpFunctions.showErrorCardAlert("Error occured", showButton: false)
                }
            })
        } else {
            let realm = try! Realm()
            let deleteObjs = realm.objects(Note.self).filter("id == %@", note.id)
            
            try! realm.write {
                realm.delete(deleteObjs)
                self.navigationController?.popViewController(animated: true)
            }
        }
    }
    
    @objc func onShare(_ recognizer: UITapGestureRecognizer){
        NoteApi().getShareUrl(id: note.id) { (result, message, shareUrl) in
            if result == 1 {
                print(shareUrl)
                if let link = URL(string: shareUrl)
                {
                    let objectsToShare = ["\(self.note.title)", link] as [Any]
                    let activityVC = UIActivityViewController(activityItems: objectsToShare, applicationActivities: nil)
                    activityVC.excludedActivityTypes = [UIActivityType.airDrop, UIActivityType.addToReadingList]
                    self.present(activityVC, animated: true, completion: nil)
                }
            }else{
                HelpFunctions.showErrorCardAlert("Error occured", showButton: false)
            }
        }
    }
}
