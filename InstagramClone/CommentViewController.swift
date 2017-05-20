//
//  CommentViewController.swift
//  InstagramClone
//
//  Created by Паша on 26/04/2017.
//  Copyright © 2017 Pavel Kraev. All rights reserved.
//

import UIKit

class CommentViewController: UIViewController {
   
    @IBOutlet weak var sendButton: UIButton!
    @IBOutlet weak var commentTextField: UITextField!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var constraintToBottom: NSLayoutConstraint!
   
    var comments = [Comment]()
    var users = [User]()
    
    var postId: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Comment"
        sendButton.isEnabled = false
        handleTextField()
        empty()
        loadComments()
        tableView.dataSource = self
        
        tableView.estimatedRowHeight = 78
        tableView.rowHeight = UITableViewAutomaticDimension
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow(_:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide(_:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    // hide kyeBoard by touch
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    // moove conteny by showing keyboard
    func keyboardWillShow(_ notification: NSNotification) {
        print(notification)
        let keyBoardFrame = (notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as AnyObject).cgRectValue
        //print(keyBoardFrame)
        UIView.animate(withDuration: 0.3) {
            self.constraintToBottom.constant = (keyBoardFrame?.height)!
            self.view.layoutIfNeeded()
        }
    }
    
    func keyboardWillHide(_ notification: NSNotification) {
        print(notification)
        UIView.animate(withDuration: 0.3) {
            self.constraintToBottom.constant = 0
            self.view.layoutIfNeeded()
        }
    }
    ///
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden = true
    }
    
    func loadComments() {
        
        Api.PostComment.refPostComments.child(self.postId).observe(.childAdded, with: { (snapshot) in

            Api.Comment.observeComments(withPostId: snapshot.key, completion: { (comment) in
                self.fetchUser(uid: comment.uid!, completed: {
                    self.comments.append(comment)
                    self.tableView.reloadData()
                })
            })
        })
    }
    
    func fetchUser(uid: String, completed: @escaping () -> Void) {
        
        Api.User.observeUser(withId: uid) { (user) in
            self.users.append(user)
            completed()
        }

    }

    @IBAction func sendButtonPressed(_ sender: UIButton) {
        // creating new comment in DB
        let commentsReference = Api.Comment.refComments // new node in DB
        let newCommentId = commentsReference.childByAutoId().key
        let newCommentReference = commentsReference.child(newCommentId)
        guard let currentUser = Api.User.currentUser else {
            return
        }
        // setting new coment with uid and text
        let currentUserId = currentUser.uid
        newCommentReference.setValue(["uid": currentUserId,  "commentText": commentTextField.text!], withCompletionBlock: {
            (error, ref) in
            if error != nil {
                ProgressHUD.showError(error!.localizedDescription)
                return
            }
            
            // crating post-comments node
            let postCommentRef = Api.PostComment.refPostComments.child(self.postId).child(newCommentId)
            postCommentRef.setValue(true, withCompletionBlock: { (error, ref) in
                if error != nil {
                    ProgressHUD.showError(error?.localizedDescription)
                    return
                }
           
            })
            self.empty()
            self.view.endEditing(true)
        })
        
    }
    // clear textField after the comment and sendButton disable
    func empty() {
        self.commentTextField.text = ""
        self.sendButton.setTitleColor(UIColor.lightGray, for: UIControlState.normal)
        self.sendButton.isEnabled = false
    }
    
    // MARK: Textfield validation
    func handleTextField() {
        commentTextField.addTarget(self, action: #selector(self.textFieldDidChange), for: UIControlEvents.editingChanged)
    }
    
    func textFieldDidChange() {
        if let commentText = commentTextField.text, !commentText.isEmpty {
            sendButton.setTitleColor(UIColor.green, for: UIControlState.normal)
            sendButton.isEnabled = true
            return
        }
        sendButton.setTitleColor(UIColor.lightGray, for: UIControlState.normal)
        sendButton.isEnabled = false
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.tabBarController?.tabBar.isHidden = false
    }
    
}


extension CommentViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return comments.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CommentCell", for:
            indexPath) as! CommentTableViewCell
        let comment = comments[indexPath.row]
        let user = users[indexPath.row]
        cell.comment = comment
        cell.user = user
        return cell
    }
    
    
}
