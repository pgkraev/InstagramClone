//
//  CommentTableViewCell.swift
//  InstagramClone
//
//  Created by Паша on 26/04/2017.
//  Copyright © 2017 Pavel Kraev. All rights reserved.
//

import UIKit
import FirebaseDatabase

class CommentTableViewCell: UITableViewCell {

    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var commentLabel: UILabel!
    
    var comment: Comment? {
        didSet {
            updateView()
        }
    }
    
    var user: User? {
        didSet {
            setupUserInfo()
        }
    }
    
    
    func updateView() {
        commentLabel.text = comment?.commentText
        }
    
    
    
    func setupUserInfo() {
        nameLabel.text = user?.username
        if let photoUrlString = user?.profileImageUrl {
            let photoUrl = URL(string: photoUrlString)
            profileImageView.sd_setImage(with: photoUrl, placeholderImage: UIImage(named: "UserPH"))
        }
        
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        nameLabel.text = ""
        commentLabel.text = ""
        
        profileImageView.layer.cornerRadius = 18
        profileImageView.clipsToBounds = true
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        profileImageView.image = UIImage(named: "UserPH")
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
