//
//  UserAPI.swift
//  InstagramClone
//
//  Created by Паша on 02/05/2017.
//  Copyright © 2017 Pavel Kraev. All rights reserved.
//

import Foundation
import FirebaseDatabase
import FirebaseAuth

class UserAPI {
    
    var currentUser: FIRUser? {
        if let currentUser = FIRAuth.auth()?.currentUser {
            return currentUser
        }
        return nil
    }
    
    var refUsers = FIRDatabase.database().reference().child("users")
    
    var refCurrentUser: FIRDatabaseReference? {
        guard let currentUser = FIRAuth.auth()?.currentUser else {
            return nil
        }
        return refUsers.child(currentUser.uid)
    }
    
    func observeUser(withId uid: String, completion: @escaping (User) -> Void) {
        refUsers.child(uid).observeSingleEvent(of: .value, with: { snapshot in
            if let dict = snapshot.value as? [String: Any] {
                let user = User.transformUser(dict: dict, key: snapshot.key)
                completion(user)
            }
        })
    }
    
    func observeCurrentUser(completion: @escaping (User) -> Void) {
        guard let currentUser = FIRAuth.auth()?.currentUser else {
            return
        }
        refUsers.child(currentUser.uid).observeSingleEvent(of: .value, with: { snapshot in
            if let dict = snapshot.value as? [String: Any] {
                let user = User.transformUser(dict: dict, key: snapshot.key)
                completion(user)
            }
        })

    }
    
    func observeUsersWithChildAddedEvent(completion: @escaping (User) -> Void) {
        refUsers.observe(.childAdded, with: { (snapshot) in
            if let dict = snapshot.value as? [String: Any] {
                let user = User.transformUser(dict: dict, key: snapshot.key)
                if user.id != Api.User.currentUser?.uid {
                     completion(user)
                }
            }
        })

    }
    
}
