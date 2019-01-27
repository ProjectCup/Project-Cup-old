//
//  User.swift
//  ProjectCup
//
//  Created by younith on 1/22/19.
//  Copyright © 2019 xyy. All rights reserved.
//

import UIKit

class User: NSObject {
    var name: String?
    var email: String?
    init(dictionary: [String: Any]) {
        self.name = dictionary["name"] as? String ?? ""
        self.email = dictionary["email"] as? String ?? ""
    }
}

