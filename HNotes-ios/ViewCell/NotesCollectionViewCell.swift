//
//  NotesCollectionViewCell.swift
//  HNotes-ios
//
//  Created by Karim Karimov on 10/14/17.
//  Copyright © 2017 Karim Karimov. All rights reserved.
//

import UIKit
import WebKit

class NotesCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var cardBG: UIView!
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var imagePreview: UIImageView!
    @IBOutlet weak var date: UILabel!
    @IBOutlet weak var deleteIc: UIImageView!
    @IBOutlet weak var shareIc: UIImageView!
}
