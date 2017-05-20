//
//  AuthService.swift
//  InstagramClone
//
//  Created by Паша on 18/04/2017.
//  Copyright © 2017 Pavel Kraev. All rights reserved.
//

import Foundation
import FirebaseAuth
import FirebaseStorage
import FirebaseDatabase

class AuthService {
    
    static func signIn(email: String, password: String, onSuccess: @escaping () -> Void, onError: @escaping (_ errorMessage: String?) -> Void) {
        FIRAuth.auth()?.signIn(withEmail: email, password: password, completion: { (user: FIRUser?, error) in
            if error != nil {
                onError(error?.localizedDescription)
                return
            }
            onSuccess()
        })
    }
    
  
    static func signUp(username: String, email: String, password: String, imageData: Data, onSuccess: @escaping () -> Void, onError:  @escaping (_ errorMessage: String?) -> Void) {
        FIRAuth.auth()?.createUser(withEmail: email, password: password, completion: { (user: FIRUser?, error: Error?) in
            if error != nil {
                onError(error!.localizedDescription)
                return
            }
            let uid = user?.uid
            
            // saving userImage
            let storageRef = FIRStorage.storage().reference(forURL: Config.storageRootRef).child("profileImage").child(uid!) // creaiting ref to a storage

            // put data to FB
            storageRef.put(imageData, metadata: nil, completion: { (metadata, error) in
                if error != nil {
                    return
                }
                let profileImageUrl = metadata?.downloadURL()?.absoluteString
                
                self.setUserInfomation(profileImageUrl: profileImageUrl!, username: username, email: email, uid: uid!, onSuccess: onSuccess)
            })
        })
        
    }
    
    static func setUserInfomation(profileImageUrl: String, username: String, email: String, uid: String, onSuccess: @escaping () -> Void) {
        let ref = FIRDatabase.database().reference()
        let usersReference = ref.child("users")
        let newUserReference = usersReference.child(uid)
        newUserReference.setValue(["username": username, "email": email, "profileImageUrl": profileImageUrl])
        onSuccess()
    }
    
    static func logout(onSuccess: @escaping () -> Void, onError:  @escaping (_ errorMessage: String?) -> Void) {
        do {
            try FIRAuth.auth()?.signOut()
           onSuccess()
        } catch let logOutError {
            onError(logOutError.localizedDescription)
        }
    
    }

    
}
