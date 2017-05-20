//
//  HomeTableViewCell.swift
//  InstagramClone
//
//  Created by Паша on 24/04/2017.
//  Copyright © 2017 Pavel Kraev. All rights reserved.
//

import UIKit

class HomeTableViewCell: UITableViewCell {
    
    @IBOutlet weak var profileimageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var posImageView: UIImageView!
    @IBOutlet weak var likeImageView: UIImageView!
    @IBOutlet weak var commentImageView: UIImageView!
    @IBOutlet weak var shareImageView: UIImageView!
    @IBOutlet weak var likeCountButton: UIButton!
    @IBOutlet weak var captionLabel: UILabel!
    
    var homeVC: HomeViewController?
    
    var post: Post? {
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
        captionLabel.text = post?.caption
        if let photoUrlString = post?.photoUrl {
            let photoUrl = URL(string: photoUrlString)
            posImageView.sd_setImage(with: photoUrl)
        }
        
        self.updateLike(post: self.post!)

        
        
//        Api.Post.observeLikeCount(withPostId: post!.id!) { (value) in
//            self.likeCountButton.setTitle("\(value) likes", for: UIControlState.normal)
//        }
    }
    
    func updateLike(post: Post) {
        let imageName = post.likes == nil || !post.isLiked! ? "like" : "likeSelected"
        likeImageView.image = UIImage(named: imageName)
        guard let count = post.likeCount else {
            return
        }
        if count != 0 {
            likeCountButton.setTitle("\(count) likes", for: UIControlState.normal)
        } else {
            likeCountButton.setTitle("Be the first like this", for: UIControlState.normal)
        }
    }
    
    func setupUserInfo() {
        nameLabel.text = user?.username
        if let photoUrlString = user?.profileImageUrl {
            let photoUrl = URL(string: photoUrlString)
                   profileimageView.sd_setImage(with: photoUrl, placeholderImage: UIImage(named: "UserPH"))
        }
 
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        nameLabel.text = ""
        captionLabel.text = ""
        
        profileimageView.layer.cornerRadius = 18
        profileimageView.clipsToBounds = true
        
        //commentImageView shows commentViewController by touch
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.commentImageViewTapped))
        commentImageView.addGestureRecognizer(tapGesture)
        commentImageView.isUserInteractionEnabled = true
        
        //likeImageViewT likes post by touch
        let tapGestureForLikeeImageView = UITapGestureRecognizer(target: self, action: #selector(self.likeImageViewTapped))
        likeImageView.addGestureRecognizer(tapGestureForLikeeImageView)
        likeImageView.isUserInteractionEnabled = true
        
    }

    func likeImageViewTapped() {
        Api.Post.incrementLikes(postId: post!.id!, onSuccess: { (post) in
            self.updateLike(post: post)
            self.post?.likes = post.likes
            self.post?.isLiked = post.isLiked
            self.post?.likeCount = post.likeCount
        }) { (errorMessage) in
            ProgressHUD.showError(errorMessage)
        }
        //incrementLikes(forRef: postRef)

    }
    
    func commentImageViewTapped () {
        print("CommentImageViewTapped")
        if let id = post?.id {
        homeVC?.performSegue(withIdentifier: "CommentSegue", sender: id)
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        profileimageView.image = UIImage(named: "UserPH")
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
