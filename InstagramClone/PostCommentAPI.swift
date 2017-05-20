//
//  PostCommentAPI.swift
//  InstagramClone
//
//  Created by Паша on 02/05/2017.
//  Copyright © 2017 Pavel Kraev. All rights reserved.
//

import Foundation
import FirebaseDatabase

class PostCommentAPI {
    
    var refPostComments = FIRDatabase.database().reference().child("post-comments")
    
    /*
    func observePostComment(withPostCommentsId id: String, completion: @escaping (Comment) -> Void)
    
    func observPostComments(withPostCommentsId id: String, completion: @escaping (Comment) -> Void) {
        refComments.child(id).observeSingleEvent(of: .value, with: { (snapshot) in
            if let dict = snapshot.value as? [String: Any] {
                let newComment = Comment.transformComment(dict: dict)
                completion(newComment)
            }
        })
    }
    */
    
}
