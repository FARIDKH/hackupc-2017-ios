//
//  SecondViewController.swift
//  HNotes-ios
//
//  Created by Karim Karimov on 10/14/17.
//  Copyright © 2017 Karim Karimov. All rights reserved.
//

import UIKit
import RealmSwift

class NotesViewController: UIViewController,
    UICollectionViewDelegate,
    UICollectionViewDataSource,
    UICollectionViewDelegateFlowLayout{

    @IBOutlet weak var collectionView: UICollectionView!
    var notes = [Note]()
    var collectionViewHeight = 0.0
    
    var tapGestureRecognizer = UITapGestureRecognizer();
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initVars()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func initVars(){
        if(AuthApi.hasLocalUserData()){
            NoteApi().getNotes(onComplete: { (result, message, resultNotes) in
                if(result == 1){
                    self.notes.append(contentsOf: resultNotes)
                }else{
                    HelpFunctions.showErrorCardAlert("Error occured while getting your history notes", showButton: false)
                }
            })
        }else{
            let realm = try! Realm()
            
            let localNotes = realm.objects(Note.self)
            notes.append(contentsOf: localNotes)
        }
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
        
        cell.title.text = note.title
        cell.date.text = note.date
        cell.preview.loadHTMLString(note.content, baseURL: nil)
        
        self.tapGestureRecognizer = UITapGestureRecognizer(
            target: self,
            action: #selector(onClick))
        cell.cardBG.addGestureRecognizer(tapGestureRecognizer)
        
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
        
    }
}

