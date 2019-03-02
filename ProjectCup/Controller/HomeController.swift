//
//  HomeController.swift
//  ProjectCup
//
//  Created by Jiatao Xu on 3/2/19.
//  Copyright © 2019 xyy. All rights reserved.
//

import Foundation
import UIKit

class HomeController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.white
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Setting", style: .plain, target: self, action: #selector(gotoSetting))

    }
    
    @objc func gotoSetting(){
        let settingController = SettingController()
        let navController = UINavigationController(rootViewController: settingController)
        present(navController, animated: true, completion: nil)
    }
    
}
