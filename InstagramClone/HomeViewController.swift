//
//  HomeViewController.swift
//  InstagramClone
//
//  Created by Паша on 14/04/2017.
//  Copyright © 2017 Pavel Kraev. All rights reserved.
//

import UIKit
import SDWebImage

class HomeViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var activityIndicatorView: UIActivityIndicatorView!
    
    var posts = [Post]()
    var users = [User]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.estimatedRowHeight = 521
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.dataSource = self
        loadPosts()
    }
    
    // extracting data from database
    func loadPosts() {
        Api.Feed.observeUserFeedPosts(withID: Api.User.currentUser!.uid) { (post) in
            guard let postId = post.uid else {
                return
            }
            self.fetchUser(uid: postId, completed: {
                self.posts.append(post)
                self.tableView.reloadData()
            })
        }
        
        Api.Feed.observeFeedRemoved(withId: Api.User.currentUser!.uid) { (post) in
            self.posts = self.posts.filter {$0.id != post.id}
            self.users = self.users.filter {$0.id != post.uid}
            
            self.tableView.reloadData()
        }
    }
    
    func fetchUser(uid: String, completed: @escaping () -> Void) {
        Api.User.observeUser(withId: uid) { (user) in
            self.users.append(user)
            completed()
        }
    }
    
    // MARK: Logout
    @IBAction func logOutPreseed(_ sender: UIBarButtonItem) {        
        AuthService.logout(onSuccess: { 
            let storyBoard = UIStoryboard(name: "Start", bundle: nil)
            let signInVC = storyBoard.instantiateViewController(withIdentifier: "SignInViewController")
            self.present(signInVC, animated: true, completion: nil)
        }) { (errorMessage) in
            ProgressHUD.showError(errorMessage)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "CommentSegue" {
            let commentVC = segue.destination as! CommentViewController
            let postId = sender as! String
            commentVC.postId = postId
        }
    }
    
    
}

extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PostCell", for:
            indexPath) as! HomeTableViewCell
        let post = posts[indexPath.row]
        let user = users[indexPath.row]
        cell.post = post
        cell.user = user
        cell.homeVC = self
        return cell
    }
    
    
}







