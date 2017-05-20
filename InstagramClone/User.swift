//
//  User.swift
//  InstagramClone
//
//  Created by Паша on 26/04/2017.
//  Copyright © 2017 Pavel Kraev. All rights reserved.
//

import Foundation

class User {
    var email: String?
    var profileImageUrl: String?
    var username: String?
    var id: String?
    var isFollowing: Bool?
}

extension User {
    static func transformUser (dict: [String: Any], key: String) -> User {
        let user = User()
        user.email = dict["email"] as! String?
        user.profileImageUrl = dict["profileImageUrl"] as! String?
        user.username = dict["username"] as! String?
        user.id = key
        
        return user
    }
    
    
}
