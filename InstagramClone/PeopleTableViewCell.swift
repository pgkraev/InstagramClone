//
//  PeopleTableViewCell.swift
//  InstagramClone
//
//  Created by Паша on 12/05/2017.
//  Copyright © 2017 Pavel Kraev. All rights reserved.
//

import UIKit

class PeopleTableViewCell: UITableViewCell {

    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var followButton: UIButton!
    
    var user: User? {
        didSet {
            updateView()
        }
    }
    
    func updateView() {
        nameLabel.text = user?.username
        if let photoUrlString = user?.profileImageUrl {
            let photoUrl = URL(string: photoUrlString)
            profileImage.sd_setImage(with: photoUrl, placeholderImage: UIImage(named: "UserPH"))
        }
        
        if user!.isFollowing! {
            configureUnFollowButton()
        } else {
            self.configureFollowButton()
        }
        
        
    }
    
    func configureFollowButton() {
        followButton.layer.borderWidth = 1
        followButton.layer.borderColor = UIColor(red: 226/255, green: 228/255, blue: 232/255, alpha: 1).cgColor
        followButton.layer.cornerRadius = 5
        followButton.clipsToBounds = true
        
        followButton.setTitleColor(UIColor.white, for: UIControlState.normal)
        followButton.backgroundColor = UIColor.blue
        followButton.setTitle("Follow", for: UIControlState.normal)
        followButton.addTarget(self, action: #selector(self.followAction), for: UIControlEvents.touchUpInside)
    }
    
    func configureUnFollowButton() {
        followButton.layer.borderWidth = 1
        followButton.layer.borderColor = UIColor(red: 226/255, green: 228/255, blue: 232/255, alpha: 1).cgColor
        followButton.layer.cornerRadius = 5
        followButton.clipsToBounds = true
        
        followButton.setTitleColor(UIColor.black, for: UIControlState.normal)
        followButton.backgroundColor = UIColor.green
        followButton.setTitle("Following", for: UIControlState.normal)
        followButton.addTarget(self, action: #selector(self.unFollowAction), for: UIControlEvents.touchUpInside)
    }
    
    func followAction() {
        if user!.isFollowing! == false {
            Api.Follow.followAction(withUserId: user!.id!)
            configureUnFollowButton()
            user?.isFollowing = true
        }
        
    }
    
    func unFollowAction() {

        if user!.isFollowing! == true {
            Api.Follow.unFollowAction(withUserId: user!.id!)
            configureFollowButton()
            user?.isFollowing = false
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
