//
//  PeopleViewController.swift
//  InstagramClone
//
//  Created by Паша on 12/05/2017.
//  Copyright © 2017 Pavel Kraev. All rights reserved.
//

import UIKit

class PeopleViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
   
    var users: [User] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        loadUsers()
    }

    func loadUsers() {
        Api.User.observeUsersWithChildAddedEvent { (user) in
            self.isFollowing(userId: user.id!, completed: { (value) in
                user.isFollowing = value
                self.users.append(user)
                self.tableView.reloadData()
            })            
        }
    }

    func isFollowing(userId: String, completed: @escaping(Bool) -> Void) {
        Api.Follow.isFollowing(userId: userId, completed: completed)
    }
}


extension PeopleViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PeopleTableViewCell", for:
            indexPath) as! PeopleTableViewCell
        let user = users[indexPath.row]
        cell.user = user
        
        return cell
    }
    
    
}
