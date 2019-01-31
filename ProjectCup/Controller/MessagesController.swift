//
//  MessagesController.swift
//  ProjectCup
//
//  Created by Jiatao Xu on 1/19/19.
//  Copyright © 2019 xyy. All rights reserved.
//

import UIKit
import Firebase

class MessagesController: UITableViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Setting", style: .plain, target: self, action: #selector (gotoSetting))
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "New", style: .plain, target: self, action: #selector(handleNewMessage))
        

    }
    @objc func gotoSetting(){
    let settingController = UINavigationController(rootViewController: SettingController())
    self.present(settingController, animated: true, completion: nil)
    }
    @objc func handleNewMessage() {
        let newMessageController = NewMessageController()
        let navController = UINavigationController(rootViewController: newMessageController)
        present(navController, animated: true, completion: nil)
    }
}


