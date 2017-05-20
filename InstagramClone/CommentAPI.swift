//
//  CommentAPI.swift
//  InstagramClone
//
//  Created by Паша on 02/05/2017.
//  Copyright © 2017 Pavel Kraev. All rights reserved.
//

import Foundation
import FirebaseDatabase

class CommentAPI {
    var refComments = FIRDatabase.database().reference().child("comments")
    
    func observeComments(withPostId id: String, completion: @escaping (Comment) -> Void) {
        refComments.child(id).observeSingleEvent(of: .value, with: { (snapshot) in
            if let dict = snapshot.value as? [String: Any] {
                let newComment = Comment.transformComment(dict: dict)
                completion(newComment)
            }
        })
    }
}
