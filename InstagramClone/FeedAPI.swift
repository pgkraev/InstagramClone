//
//  FeedAPI.swift
//  InstagramClone
//
//  Created by Паша on 17/05/2017.
//  Copyright © 2017 Pavel Kraev. All rights reserved.
//

import Foundation
import FirebaseDatabase

class FeedAPI {

    var refFeed = FIRDatabase.database().reference().child("feed")
    
    func observeUserFeedPosts(withID id: String, completion: @escaping (Post) -> Void) {
        refFeed.child(id).observe(FIRDataEventType.childAdded, with: { (snapshot) in
            let key = snapshot.key
            Api.Post.observePost(withId: key, completion: { (post) in
                completion(post)
            })
        })
    }

    func observeFeedRemoved(withId id: String, completion: @escaping (Post) -> Void) {
        refFeed.child(id).observe(.childRemoved, with: { (snapshot) in
            let key = snapshot.key
            Api.Post.observePost(withId: key, completion: { (post) in
                completion(post)
            })
        })
    }
    
}

