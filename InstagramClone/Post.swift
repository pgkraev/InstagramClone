//
//  Post.swift
//  InstagramClone
//
//  Created by Паша on 21/04/2017.
//  Copyright © 2017 Pavel Kraev. All rights reserved.
//

import Foundation
import FirebaseAuth

class Post {
    var caption: String?
    var photoUrl: String?
    var uid: String?
    var id: String?
    var likeCount: Int?
    var likes: Dictionary <String, Any>?
    var isLiked: Bool?
}

extension Post {
    static func transformPostPhoto(dict:[String: Any], key: String) -> Post {
        let post = Post()
        post.caption = dict["caption"] as? String
        post.photoUrl = dict["photoUrl"] as? String
        post.uid = dict["uid"] as! String?
        post.id = key
        post.likeCount = dict["likeCount"] as! Int?
        post.likes = dict["likes"] as! Dictionary<String, Any>?
        if let currentUserId = FIRAuth.auth()?.currentUser?.uid {
            if post.likes != nil {
                if post.likes?[currentUserId] != nil {
                    post.isLiked = true
                } else {
                    post.isLiked = false
                }
            }
        }

        return post
    }
    
}
