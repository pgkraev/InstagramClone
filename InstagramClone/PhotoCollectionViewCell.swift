//
//  PhotoCollectionViewCell.swift
//  InstagramClone
//
//  Created by Паша on 10/05/2017.
//  Copyright © 2017 Pavel Kraev. All rights reserved.
//

import UIKit

class PhotoCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var photo: UIImageView!
    
    var post: Post? {
        didSet {
            updateView()
        }
    }
    
    func updateView() {
        if let photoUrlString = post?.photoUrl {
            let photoUrl = URL(string: photoUrlString)
            photo.sd_setImage(with: photoUrl)
        }
    }
}
