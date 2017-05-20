//
//  API.swift
//  InstagramClone
//
//  Created by Паша on 02/05/2017.
//  Copyright © 2017 Pavel Kraev. All rights reserved.
//

import Foundation

struct Api {
    static var User = UserAPI()
    static var Post = PostAPI()
    static var Comment = CommentAPI()
    static var PostComment = PostCommentAPI()
    static var MyPosts = MyPostsAPI()
    static var Follow = FollowAPI()
    static var Feed = FeedAPI()
}
