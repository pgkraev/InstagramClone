//
//  HelperService.swift
//  InstagramClone
//
//  Created by Паша on 10/05/2017.
//  Copyright © 2017 Pavel Kraev. All rights reserved.
//

import Foundation
import FirebaseStorage

class HelperService {
    
    static func uploadDataToServer(data: Data, caption: String, onSuccess: @escaping () -> Void ) {
        let photoIdString = UUID().uuidString
        let storageRef = FIRStorage.storage().reference(forURL: Config.storageRootRef).child("photoPosts").child(photoIdString)
        storageRef.put(data, metadata: nil) { (metadata, error) in
            if error != nil {
                ProgressHUD.showError(error!.localizedDescription)
                return
            }
            let photoUrl = metadata?.downloadURL()?.absoluteString
            self.sendDataToDatabase(photoUrl: photoUrl!, caption: caption, onSuccess: onSuccess)
        }
    }
    
    static func sendDataToDatabase(photoUrl: String, caption: String, onSuccess: @escaping () -> Void ) {
        let newPostId = Api.Post.refPosts.childByAutoId().key
        let newPostReference = Api.Post.refPosts.child(newPostId)
        guard let currentUser = Api.User.currentUser else {
            return
        }
        
        let currentUserId = currentUser.uid
        newPostReference.setValue(["uid": currentUserId, "photoUrl": photoUrl, "caption": caption], withCompletionBlock: {
            (error, ref) in
            if error != nil {
                ProgressHUD.showError(error!.localizedDescription)
                return
            }
            
            Api.Feed.refFeed.child((Api.User.currentUser?.uid)!).child(newPostId).setValue(true)
            
            let myPostRef = Api.MyPosts.refMyPosts.child(currentUserId).child(newPostId)
            myPostRef.setValue(true, withCompletionBlock: { (error, ref) in
                if error != nil {
                    ProgressHUD.showError(error?.localizedDescription)
                    return
                }
                
            })
            
            ProgressHUD.showSuccess("Success")
            onSuccess()
        })
    }
}
