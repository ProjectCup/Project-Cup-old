//
//  User.swift
//  ProjectCup
//
//  Created by younith on 1/22/19.
//  Copyright © 2019 xyy. All rights reserved.
//

import UIKit

class User: NSObject {
    var id: String?
    var name: String?
    var email: String?
    
    init(dictionary: [String: AnyObject]) {
        self.id = dictionary["id"] as? String
        self.name = dictionary["name"] as? String
        self.email = dictionary["email"] as? String
    }
}
