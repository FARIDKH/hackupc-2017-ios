//
//  SecondViewController.swift
//  HNotes-ios
//
//  Created by Karim Karimov on 10/14/17.
//  Copyright © 2017 Karim Karimov. All rights reserved.
//

import UIKit
import RealmSwift
import Kingfisher

class NotesViewController: UIViewController,
    UICollectionViewDelegate,
    UICollectionViewDataSource,
    UICollectionViewDelegateFlowLayout,
UIGestureRecognizerDelegate{

    @IBOutlet weak var collectionView: UICollectionView!
    var notes = [Note]()
    var collectionViewHeight = 0.0
    
    @IBOutlet weak var toolbarView: UIView!
    @IBOutlet weak var toolbarTitle: UILabel!
    @IBOutlet weak var backIc: UIImageView!
    
    var tapGestureRecognizer = UITapGestureRecognizer();
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initVars()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if(AuthApi.hasLocalUserData()){
            NoteApi().getNotes(onComplete: { (result, message, resultNotes) in
                if(result == 1){
                    self.notes.append(contentsOf: resultNotes)
                } else {
                    HelpFunctions.showErrorCardAlert("Error occured while getting your history notes", showButton: false)
                }
            })
        }else{
            let realm = try! Realm()
            
            //            let localNotes = realm.objects(Note.self)
            //            notes.append(contentsOf: localNotes)
            
            notes = Array(realm.objects(Note.self.self))
        }
        collectionView.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func initVars(){
        self.navigationController?.interactivePopGestureRecognizer?.delegate = self
        
        tapGestureRecognizer.numberOfTapsRequired = 1
        
        self.tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(onBack(_:)))
        backIc.addGestureRecognizer(tapGestureRecognizer)
    }

    // MARK: Collection view setup
    
    //data handling
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int{
        return notes.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell{
        let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: "note_cell",
            for: indexPath) as! NotesCollectionViewCell
        
        let note = notes[indexPath.row]
        
        cell.imagePreview.kf.setImage(with: URL(string: "http://www.hnotes.org/api/uploads/images/\(note.photoUrl)"))
        
        cell.title.text = note.title
        cell.date.text = note.date
        
        cell.shareIc.image = cell.shareIc.image!.withRenderingMode(.alwaysTemplate)
        cell.shareIc.tintColor = HelpFunctions.hexStringToUIColor(hex: "0093E9")
        
        cell.deleteIc.image = cell.deleteIc.image!.withRenderingMode(.alwaysTemplate)
        cell.deleteIc.tintColor = HelpFunctions.hexStringToUIColor(hex: "0093E9")
        
        self.tapGestureRecognizer = UITapGestureRecognizer(
            target: self,
            action: #selector(onClick))
        cell.cardBG.addGestureRecognizer(tapGestureRecognizer)
        
        self.tapGestureRecognizer = UITapGestureRecognizer(
            target: self,
            action: #selector(onShare))
        cell.shareIc.addGestureRecognizer(tapGestureRecognizer)
        
        self.tapGestureRecognizer = UITapGestureRecognizer(
            target: self,
            action: #selector(onDelete))
        cell.deleteIc.addGestureRecognizer(tapGestureRecognizer)
        
        HelpFunctions.addShadowToView(cell.cardBG)
        return cell
    }
    
    //size handling
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize{
        
        let pageWidth:Int = Int(self.view.bounds.width)
        
        return CGSize(width: pageWidth,
                      height: 200)
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0.0
    }
    
    //CLick handlers
    @objc func onClick(sender : UITapGestureRecognizer){
        let tapLocation = sender.location(in: self.collectionView)
        let indexPath = self.collectionView.indexPathForItem(at: tapLocation)! as NSIndexPath
        
        if let vc = self.storyboard?.instantiateViewController(withIdentifier: "NoteDetailViewController") as? NoteDetailViewController{
            vc.note = self.notes[indexPath.row]
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    @objc func onShare(sender : UITapGestureRecognizer){
        let tapLocation = sender.location(in: self.collectionView)
        let indexPath = self.collectionView.indexPathForItem(at: tapLocation)! as NSIndexPath
        
    }
    
    @objc func onDelete(sender : UITapGestureRecognizer){
        let tapLocation = sender.location(in: self.collectionView)
        let indexPath = self.collectionView.indexPathForItem(at: tapLocation)! as NSIndexPath
        
        if(AuthApi.hasLocalUserData()){
            let realm = try! Realm()
            let deleteObjs = realm.objects(Note.self).filter("id == %@", notes[indexPath.row].id)
            
            try! realm.write {
                realm.delete(deleteObjs)
                notes.remove(at: indexPath.row)
                collectionView.reloadData()
            }
        }else{
            NoteApi().deleteNote(id: notes[indexPath.row].unique_id, onComplete: { (result, message) in
                if result == 1 {
                    HelpFunctions.showSuccessCardAlert("Note has been deleted", showButton: false)
                    self.notes.remove(at: indexPath.row)
                    self.collectionView.reloadData()
                }else{
                    HelpFunctions.showErrorCardAlert("Error occured", showButton: false)
                }
            })
        }
        
    }
    
    // MARK: - Click handler
    @objc func onBack(_ recognizer: UITapGestureRecognizer){
        self.navigationController?.popViewController(animated: true)
    }
}

