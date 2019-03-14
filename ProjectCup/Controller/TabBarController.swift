//
//  MainPageController.swift
//  ProjectCup
//
//  Created by Jiatao Xu on 3/1/19.
//  Copyright © 2019 xyy. All rights reserved.
//

import Foundation
import UIKit
import Firebase

class TabBarController: UIViewController {
    
    var tbController: UITabBarController!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.setNavigationBarHidden(true, animated: false)
        
        view.backgroundColor = UIColor.blue
        createTabBarController()
        checkIfUserIsLoggedIn()

    }
    
    func createTabBarController() {
        
        
        tbController = UITabBarController()
        
        let layout = UICollectionViewLayout()
        let homepageController = HomeController(collectionViewLayout: layout)
        let firstnavigationController = UINavigationController(rootViewController: homepageController)
        firstnavigationController.title = "Home"
        
        let messagesController = MessagesController()
        let secondnavigationController = UINavigationController(rootViewController: messagesController)
        secondnavigationController.title = "Messages"
        
        
        tbController.viewControllers = [firstnavigationController, secondnavigationController]
        self.view.addSubview(tbController.view)
        
    }
    
    func checkIfUserIsLoggedIn() {
        if Auth.auth().currentUser?.uid == nil {
            perform(#selector(handleLogout), with: nil, afterDelay: 0)
        } else {
            //nothing
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
}
