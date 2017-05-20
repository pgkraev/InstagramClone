//
//  FollowAPI.swift
//  InstagramClone
//
//  Created by Паша on 15/05/2017.
//  Copyright © 2017 Pavel Kraev. All rights reserved.
//

import Foundation
import FirebaseDatabase

class FollowAPI {
    var refFollowers = FIRDatabase.database().reference().child("followers")
    var refFollowing = FIRDatabase.database().reference().child("following")
    
    func followAction(withUserId id: String) {
        Api.MyPosts.refMyPosts.child(id).observeSingleEvent(of: .value, with: { (snapshot) in
            if let dict = snapshot.value as? [String: Any] {
                for key in dict.keys {
                    FIRDatabase.database().reference().child("feed").child((Api.User.currentUser?.uid)!).child(key).setValue(true)
                }
            }
        })
        
        refFollowers.child(id).child(Api.User.currentUser!.uid).setValue(true)
        refFollowing.child(Api.User.currentUser!.uid).child(id).setValue(true)
    }
    
    func unFollowAction(withUserId id: String) {
        Api.MyPosts.refMyPosts.child(id).observeSingleEvent(of: .value, with: { (snapshot) in
            if let dict = snapshot.value as? [String: Any] {
                for key in dict.keys {
                    FIRDatabase.database().reference().child("feed").child((Api.User.currentUser?.uid)!).child(key).removeValue()
                }
            }
        })
        
        refFollowers.child(id).child(Api.User.currentUser!.uid).setValue(NSNull())
        refFollowing.child(Api.User.currentUser!.uid).child(id).setValue(NSNull())
    }
    
    func isFollowing(userId: String, completed: @escaping(Bool) -> Void) {
        refFollowers.child(userId).child(Api.User.currentUser!.uid).observeSingleEvent(of: .value, with: { (snapshot) in
            if let _ = snapshot.value as? NSNull {
                completed(false)
            } else {
                completed(true)
                }
            
        })
    }
    
    
    
    
    
    
    
}
