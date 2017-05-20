//
//  HeaderProfileCollectionReusableView.swift
//  InstagramClone
//
//  Created by Паша on 04/05/2017.
//  Copyright © 2017 Pavel Kraev. All rights reserved.
//

import UIKit

class HeaderProfileCollectionReusableView: UICollectionReusableView {
   
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var myPostCountLabel: UILabel!
    @IBOutlet weak var followingCountLabel: UILabel!
    @IBOutlet weak var followerCountLabel: UILabel!
    
    var user: User? {
        didSet {
            updateView()
        }
    }
    
    func updateView() {
        nameLabel.text = user!.username
        if let photoUrlString = user!.profileImageUrl {
            let photoUrl = URL(string: photoUrlString)
            self.profileImage.sd_setImage(with: photoUrl)
        }
    }
}


