//
//  DeleteController.swift
//  ProjectCup
//
//  Created by Jiatao Xu on 2/7/19.
//  Copyright © 2019 xyy. All rights reserved.
//

import Foundation
import UIKit
import Firebase

class DeleteController: UIViewController {
    
    
    var DeleteButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = UIColor.red
        button.setTitle("Delete", for: UIControl.State())
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitleColor(UIColor.black, for: UIControl.State())
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        
        button.addTarget(self, action: #selector(handleDelete), for: .touchUpInside)
        
        return button
    }()
    
    @objc func handleDelete() {
        
        let optionMenu = UIAlertController(title: "Delete Account", message: "Are you sure you want to delete this account?", preferredStyle: .actionSheet)
        let delete = UIAlertAction(title: "Delete", style: .destructive) { (alert) in
            self.deleteUser()
        }
        let cancel = UIAlertAction(title: "Cancel", style: .cancel) { (alert) in
            print ("Cancel")
            self.dismiss(animated: true, completion: nil)
            // need to be dismiss uialertontroller
        }
        
        optionMenu.addAction(delete)
        optionMenu.addAction(cancel)
        present(optionMenu, animated: true, completion: nil)
        
    }
    
    func checkIfUserIsLoggedIn() {
        if Auth.auth().currentUser?.uid == nil {
            perform(#selector(handleLogout), with: nil, afterDelay: 0)
        } else {
            print("user logged in")
        }
    }
    
    @objc func handleLogout() {
        
        do {
            try Auth.auth().signOut()
        } catch let logoutError {
            print(logoutError)
        }
        
        let loginController = UINavigationController(rootViewController: LoginController())
        present(loginController, animated: true, completion: nil)
    }
    
    func deleteUser() {
        
        let ref = Database.database().reference()
        guard let uid = Auth.auth().currentUser?.uid else {
            return
        }
        let usersReference = ref.child("users").child(uid)
        usersReference.removeValue(completionBlock: {(error, reference)   in
            
            if error != nil{
                print("Failed to delete user", error!)
                return
            }
        })
        let user = Auth.auth().currentUser

        user?.delete { error in
            if error != nil {
                print("Database Delete Fail")
                return
            }
                self.handleLogout()
                print("Database Delete Success")
            
        }
    }
    
    func finishLogout() {
        let rootViewController = UIApplication.shared.keyWindow?.rootViewController
        guard let mainNavigationController = rootViewController as? MainNavigationController else { return }
        
        mainNavigationController.viewControllers = [LoginController()]
        
        dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
        view.addSubview(DeleteButton)
        setupDeleteButton()
        checkIfUserIsLoggedIn()
        
        
    }
    
    func setupDeleteButton() {
        
        DeleteButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        DeleteButton.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        DeleteButton.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -50).isActive = true
    }
    
}
