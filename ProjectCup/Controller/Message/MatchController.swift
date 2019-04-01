//
//  MatchController.swift
//  ProjectCup
//
//  Created by younith on 2/24/19.
//  Copyright © 2019 xyy. All rights reserved.
//

import UIKit
import Firebase

class MatchController: UIViewController {
    
    let cellId = "cellId"
    var users = [User]()
    var randUser = [User]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(handleCancel))
        
        fetchUser()
        
        view.backgroundColor = UIColor.white
        
        view.addSubview(matchNameLabel)
        view.addSubview(ContinueButton)
        
        setupMatchNameLabel()
        setupContinueButton()
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
                            
                            // Fix later for efficiency
                            self.randUser.removeAll()
                            let tempUser = self.users.randomElement()!
                            self.randUser.append(tempUser)
                        }
                    }
                }, withCancel: nil)
            }, withCancel: nil)
        }, withCancel: nil)
    }
    
    
    @objc func handleCancel() {
        dismiss(animated: true, completion: nil)
    }
    
    
    let matchNameLabel: UILabel = {
        let label = UILabel()
        label.text = "We found a match for you"
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.font = UIFont.boldSystemFont(ofSize: 20)
        return label
    }()
    
    
    var ContinueButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = UIColor(r: 171, g: 234, b: 190)
        button.setTitle("Continue", for: UIControl.State())
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitleColor(UIColor.black, for: UIControl.State())
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        button.layer.cornerRadius = 25
        
        button.addTarget(self, action: #selector(handleContinue), for: .touchUpInside)
        
        return button
    }()
    
    
    var messagesController: MessagesController?
    
    @objc func handleContinue() {
        dismiss(animated: true) {
            print("Dismiss completed")
            let match = self.randUser[0]
            self.messagesController?.showChatControllerForUser(match)
        }
    }
    
    
    
    func setupMatchNameLabel() {
        //need x, y, width, height constraints
        matchNameLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        matchNameLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        matchNameLabel.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -24).isActive = true
    }
    
    func setupContinueButton() {
        //need x, y, width, height constraints
        ContinueButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        ContinueButton.topAnchor.constraint(equalTo: matchNameLabel.bottomAnchor, constant: 12).isActive = true
        ContinueButton.widthAnchor.constraint(equalTo: matchNameLabel.widthAnchor).isActive = true
        ContinueButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
    }

}

