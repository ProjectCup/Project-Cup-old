//
//  MoodJournal.swift
//  ProjectCup
//
//  Created by Jiatao Xu on 8/11/19.
//  Copyright © 2019 xyy. All rights reserved.
//

import UIKit
import Firebase

class MoodJournal: NSObject {
    @objc var mood: String?
    @objc var journalText: String?
    @objc var time: String?
    @objc var journalId: String?
    
        init(dictionary: [String: Any]) {
            self.mood = dictionary["mood"] as? String
            self.journalText = dictionary["journalText"] as? String
            self.time = dictionary["time"] as? String
            self.journalId = dictionary["journalId"] as? String
        }
//    func journalautoId() {
//        let ref = Database.database().reference().child("Journal").child(Auth.auth().currentUser!.uid).childByAutoId()
//        return journalId = ref.key
//        
//    }

}
