//
//  MainNavigationController.swift
//  ProjectCup
//
//  Created by Jiatao Xu on 2/4/19.
//  Copyright © 2019 xyy. All rights reserved.
//

import Foundation
import UIKit

class MainNavigationController: UINavigationController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
        
        if isLoggedIn() {
            //assume user is logged in
            perform(#selector(showTabbar), with: nil, afterDelay: 0)
        } else {
            perform(#selector(showIntroPages), with: nil, afterDelay: 0)
        }
        
    }
    fileprivate func isLoggedIn() -> Bool {
        return UserDefaults.standard.isLoggedIn()
    }
    
    @objc func showTabbar(){
        let tabbarController = TabBarController()
        tabbarController.modalPresentationStyle = .fullScreen
        present(tabbarController, animated: true, completion: nil)
    }
    
    @objc func showIntroPages(){
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let swipingController = SwipingController(collectionViewLayout: layout)
        //viewControllers = [swipingController]
        swipingController.modalPresentationStyle = .fullScreen
        present(swipingController, animated: true, completion: nil)
    }
    
}

