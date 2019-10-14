//
//  UserChoices.swift
//  ProjectCup
//
//  Created by Sailung Yeung on 10/13/19.
//  Copyright © 2019 xyy. All rights reserved.
//

import UIKit

class UserChoices: NSObject {
    var words: [String?]
    
    init(dictionary: [String: AnyObject]) {
        self.words = []
        for (k,_) in dictionary{
            self.words.append(k)
        }
    }
}

