//
//  Comment.swift
//  InstagramClone
//
//  Created by Паша on 27/04/2017.
//  Copyright © 2017 Pavel Kraev. All rights reserved.
//

import Foundation

class Comment {
    var commentText: String?
    var uid: String?
}

extension Comment {
    static func transformComment(dict:[String: Any]) -> Comment {
        let comment = Comment()
        comment.commentText = dict["commentText"] as? String
        comment.uid = dict["uid"] as! String?
        return comment
    }
}
