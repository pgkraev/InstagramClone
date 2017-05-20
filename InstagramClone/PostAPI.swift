//
//  PostAPI.swift
//  InstagramClone
//
//  Created by Паша on 02/05/2017.
//  Copyright © 2017 Pavel Kraev. All rights reserved.
//

import Foundation
import FirebaseDatabase

class PostAPI {
    var refPosts = FIRDatabase.database().reference().child("posts")
    
    func observeForNewPosts(completion: @escaping (Post) -> Void) {
        refPosts.observe(.childAdded) { (snapshot: FIRDataSnapshot) in
            if let dict = snapshot.value as? [String: Any] {
                let newPost = Post.transformPostPhoto(dict: dict, key: snapshot.key)
                completion(newPost)
            }
        }
    }
    
    func observePost(withId id: String, completion: @escaping (Post) -> Void) {
        refPosts.child(id).observeSingleEvent(of: .value, with: { snapshot in
            if let dict = snapshot.value as? [String: Any] {
                let post = Post.transformPostPhoto(dict: dict, key: snapshot.key)
                completion(post)
            }
        })
    }
    
    func observeLikeCount(withPostId id: String, completion: @escaping (Int) -> Void) {
        refPosts.child(id).observe(.childChanged, with: { (snapshot) in
            if let value = snapshot.value as? Int {
                completion(value)
            }
        })
    }
    
    func incrementLikes(postId: String, onSuccess: @escaping (Post) -> Void, onError: @escaping (_ errorMessage: String) -> Void) {
        let postRef = Api.Post.refPosts.child(postId)
        postRef.runTransactionBlock({ (currentData: FIRMutableData) -> FIRTransactionResult in
            if var post = currentData.value as? [String : AnyObject], let uid = Api.User.currentUser?.uid {
                
                var likes: Dictionary<String, Bool>
                likes = post["likes"] as? [String : Bool] ?? [:]
                var likeCount = post["likeCount"] as? Int ?? 0
                if let _ = likes[uid] {
                    // Unlike the post and remove self from stars
                    likeCount -= 1
                    likes.removeValue(forKey: uid)
                } else {
                    // Like the post and add self to stars
                    likeCount += 1
                    likes[uid] = true
                }
                post["likeCount"] = likeCount as AnyObject?
                post["likes"] = likes as AnyObject?
                
                // Set value and report transaction success
                currentData.value = post
                
                return FIRTransactionResult.success(withValue: currentData)
            }
            return FIRTransactionResult.success(withValue: currentData)
        }) { (error, committed, snapshot) in
            if let error = error {
                onError(error.localizedDescription)
            }
            if let dict = snapshot?.value as? [String: Any]  {
                let post = Post.transformPostPhoto(dict: dict, key: (snapshot?.key)!)
                onSuccess(post)
            }
        }
    
    }
    
}
