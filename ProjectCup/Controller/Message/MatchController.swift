//
//  MatchController.swift
//  ProjectCup
//
//  Created by younith on 2/24/19.
//  Copyright © 2019 xyy. All rights reserved.
//

import UIKit
import Firebase

class MatchController: UIViewController, UITextFieldDelegate {
    
    let cellId = "cellId"
    var users = [User]()
    var randUser = [User]()
    
    let firstMessageTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Enter your first message..."
        tf.translatesAutoresizingMaskIntoConstraints = false
        tf.clearButtonMode = .whileEditing
        return tf
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(handleCancel))
        
        fetchUser()
        
        view.backgroundColor = UIColor.white
        
        view.addSubview(matchNameLabel)
        view.addSubview(inputsContainerView)
        view.addSubview(ContinueButton)
        
        firstMessageTextField.delegate = self
        
        setupMatchNameLabel()
        setupInputsContainerView()
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
    
    let inputsContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.white
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 10
        view.layer.masksToBounds = true
        return view
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
    
    
    var inputsContainerViewHeightAnchor: NSLayoutConstraint?
    var firstMessageTextFieldHeightAnchor: NSLayoutConstraint?
    
    func setupMatchNameLabel() {
        //need x, y, width, height constraints
        matchNameLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        matchNameLabel.bottomAnchor.constraint(equalTo: inputsContainerView.topAnchor, constant: -12).isActive = true
        matchNameLabel.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -24).isActive = true
    }
    
    func setupInputsContainerView() {
        //need x, y, width, height constraints
        inputsContainerView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        inputsContainerView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        inputsContainerView.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -24).isActive = true
        inputsContainerViewHeightAnchor = inputsContainerView.heightAnchor.constraint(equalToConstant: 100)
        inputsContainerViewHeightAnchor?.isActive = true
        
        inputsContainerView.addSubview(firstMessageTextField)
        
        //need x, y, width, height constraints
        firstMessageTextField.leftAnchor.constraint(equalTo: inputsContainerView.leftAnchor, constant: 12).isActive = true
        firstMessageTextField.topAnchor.constraint(equalTo: inputsContainerView.topAnchor).isActive = true
        firstMessageTextField.widthAnchor.constraint(equalTo: inputsContainerView.widthAnchor, constant: -10).isActive = true
        firstMessageTextFieldHeightAnchor = firstMessageTextField.heightAnchor.constraint(equalTo: inputsContainerView.heightAnchor, multiplier: 1)
        
        firstMessageTextFieldHeightAnchor?.isActive = true
    }
    
    func setupContinueButton() {
        //need x, y, width, height constraints
        ContinueButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        ContinueButton.topAnchor.constraint(equalTo: inputsContainerView.bottomAnchor, constant: 12).isActive = true
        ContinueButton.widthAnchor.constraint(equalTo: matchNameLabel.widthAnchor).isActive = true
        ContinueButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
    }
    
    
    
    
    
    
    var messagesController: MessagesController?
    
    @objc func handleContinue() {
        dismiss(animated: true) {
            print("Dismiss completed")
            
            guard let uid = Auth.auth().currentUser?.uid,
                let firstMessage = self.firstMessageTextField.text
                else {
                    return
            }
            
            // Put in the right place later
            let match = self.users.randomElement()!
            self.randUser.removeAll()
            self.randUser.append(match)
            
            while !(self.randUser.isEmpty) {
                let match = self.users.randomElement()!
                self.randUser.removeAll()
                
                Database.database().reference().child("matched-user").child(uid).observe(.childAdded, with: { (snapshot) in
                    
                    let matchedAlreadyUser = snapshot.key
                    if match.id == matchedAlreadyUser {
                        self.randUser.append(match)
                    }
                }, withCancel: nil)
            }
            
            let matchedUser = Database.database().reference().child("matched-user").child(uid).child(match.id!)
            matchedUser.setValue(1)
            
            
            
            
            let ref = Database.database().reference().child("messages")
            let childRef = ref.childByAutoId()
            //is it there best thing to include the name inside of the message node
            let toId = match.id!
            let fromId = uid
            let timestamp = Int(Date().timeIntervalSince1970)
            let values = ["text": self.firstMessageTextField.text!, "toId": toId, "fromId": fromId, "timestamp": timestamp] as [String : Any]
            
            childRef.updateChildValues(values) { (error, ref) in
                if error != nil {
                    print(error ?? "")
                    return
                }
                
                self.firstMessageTextField.text = nil
                
                guard let messageId = childRef.key else { return }
                
                let userMessagesRef = Database.database().reference().child("user-messages").child(fromId).child(toId).child(messageId)
                userMessagesRef.setValue(1)
                
                let recipientUserMessagesRef = Database.database().reference().child("user-messages").child(toId).child(fromId).child(messageId)
                recipientUserMessagesRef.setValue(1)
            }
            
            let journal = Database.database().reference().child("journal").child(uid)
            journal.child("timestamp").setValue(timestamp)
            journal.child("journal").setValue(self.firstMessageTextField.text)
            
            self.messagesController?.showChatControllerForUser(match)
            
        }
    }
}
