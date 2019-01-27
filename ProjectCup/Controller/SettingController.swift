//
//  Setting.swift
//  ProjectCup
//
//  Created by Jiatao Xu on 1/22/19.
//  Copyright © 2019 xyy. All rights reserved.
//

import Foundation
import UIKit
import Firebase

class SettingController : UITableViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Logout", style: .plain, target: self, action: #selector(handleLogout))
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(handleCancel))
        
        if Auth.auth().currentUser?.uid == nil {
            perform(#selector(handleLogout), with: nil, afterDelay: 0)
        }
    }
    
    @objc func handleLogout() {
        
        do {
            try Auth.auth().signOut()
        } catch let logoutError {
            print(logoutError)
        }
        
        let loginController = UINavigationController(rootViewController: LoginController())
        self.present(loginController, animated: true, completion: nil)
    }
    
    @objc func handleCancel() {
        dismiss(animated: true, completion: nil)
    }
}
