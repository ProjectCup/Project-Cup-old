//
//  MatchController.swift
//  ProjectCup
//
//  Created by younith on 2/24/19.
//  Copyright © 2019 xyy. All rights reserved.
//

import UIKit
import Firebase

class MatchController: UITableViewController {
    
    let cellId = "cellId"
    var users = [User]()
    var randUser = [User]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(handleCancel))
        
        tableView.register(UserCell.self, forCellReuseIdentifier: cellId)
        
        fetchUser()
    }
    
    
    func fetchUser() {
        guard let uid = Auth.auth().currentUser?.uid else {
            return
        }
        
        let useranswerRef = Database.database().reference().child("users").child(uid).child("user_answer")
        useranswerRef.child("\(1)").observeSingleEvent(of: .value, with: { (snapshot) in
            
            let answer = snapshot.value!
            let answerRef = Database.database().reference().child("answers").child("\(answer)")
            answerRef.observe(.childAdded, with: { (snapshot) in
                
                let userMatch = snapshot.key
                Database.database().reference().child("users").observe(.childAdded, with: { (snapshot) in
                    
                    if let dictionary = snapshot.value as? [String: AnyObject] {
                        let user = User(dictionary: dictionary)
                        user.id = snapshot.key
                        if user.id == userMatch && user.id != uid {
                            self.users.append(user)
                        }
                        //this will crash because of background thread, so lets use dispatch_async to fix
                        DispatchQueue.main.async(execute: {
                            self.tableView.reloadData()
                        })
                    }
                }, withCancel: nil)
            }, withCancel: nil)
        }, withCancel: nil)
    }
    
    
    @objc func handleCancel() {
        dismiss(animated: true, completion: nil)
    }
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! UserCell
        
        if indexPath.row == 0 {
            let user = self.users.randomElement()!
            self.randUser.append(user)
            cell.textLabel?.text = user.name
            cell.detailTextLabel?.text = user.email
        }
        return cell
    }
    
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 72
    }
    
    
    var messagesController: MessagesController?
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        dismiss(animated: true) {
            print("Dismiss completed")
            let user = self.randUser[0]
            self.messagesController?.showChatControllerForUser(user)
        }
    }
}
