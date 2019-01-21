//
//  FirebaseUser.swift
//  ProjectCup
//
//  Created by Jiatao Xu on 1/19/19.
//  Copyright © 2019 xyy. All rights reserved.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore

class FirebaseUser {
    
    let objectId: String
    var pushId: String?
    
    let createdAt: Date
    var updatedAt: Date
    
    var email: String
    var name: String
    var avatar: String
    var isOnline: Bool
    var phoneNumber: String
    var countryCode: String
    var country:String
    var city: String
    
    var contacts: [String]
    var blockedUsers: [String]
    let loginMethod: String
    
    //MARK: Initializers
    
    init(_objectId: String, _pushId: String?, _createdAt: Date, _updatedAt: Date, _email: String, _name: String, _avatar: String = "", _loginMethod: String, _phoneNumber: String, _city: String, _country: String) {
        
        objectId = _objectId
        pushId = _pushId
        
        createdAt = _createdAt
        updatedAt = _updatedAt
        
        name = _name
        email = _email
        avatar = _avatar
        isOnline = true
        
        city = _city
        country = _country
        
        loginMethod = _loginMethod
        phoneNumber = _phoneNumber
        countryCode = ""
        blockedUsers = []
        contacts = []
        
    }
    
    init(_dictionary: NSDictionary) {
        
        objectId = _dictionary[kOBJECTID] as! String
        pushId = _dictionary[kPUSHID] as? String
        
        if let created = _dictionary[kCREATEDAT] {
            if (created as! String).count != 14 {
                createdAt = Date()
            } else {
                createdAt = DateFormatter().date(from: created as! String)!
            }
        } else {
            createdAt = Date()
        }
        if let updateded = _dictionary[kUPDATEDAT] {
            if (updateded as! String).count != 14 {
                updatedAt = Date()
            } else {
                updatedAt = DateFormatter().date(from: updateded as! String)!
            }
        } else {
            updatedAt = Date()
        }
        
        if let mail = _dictionary[kEMAIL] {
            email = mail as! String
        } else {
            email = ""
        }
        if let nname = _dictionary[kNAME] {
            name = nname as! String
        } else {
            name = ""
        }
        if let avat = _dictionary[kAVATAR] {
            avatar = avat as! String
        } else {
            avatar = ""
        }
        if let onl = _dictionary[kISONLINE] {
            isOnline = onl as! Bool
        } else {
            isOnline = false
        }
        if let phone = _dictionary[kPHONE] {
            phoneNumber = phone as! String
        } else {
            phoneNumber = ""
        }
        if let countryC = _dictionary[kCOUNTRYCODE] {
            countryCode = countryC as! String
        } else {
            countryCode = ""
        }
        if let cont = _dictionary[kCONTACT] {
            contacts = cont as! [String]
        } else {
            contacts = []
        }
        if let block = _dictionary[kBLOCKEDUSERID] {
            blockedUsers = block as! [String]
        } else {
            blockedUsers = []
        }
        
        if let lgm = _dictionary[kLOGINMETHOD] {
            loginMethod = lgm as! String
        } else {
            loginMethod = ""
        }
        if let cit = _dictionary[kCITY] {
            city = cit as! String
        } else {
            city = ""
        }
        if let count = _dictionary[kCOUNTRY] {
            country = count as! String
        } else {
            country = ""
        }
        
    }
    
    
    //MARK: Returning current user funcs
    
    class func currentId() -> String {
        
        return Auth.auth().currentUser!.uid
    }
    
    class func currentUser () -> FirebaseUser? {
        
        if Auth.auth().currentUser != nil {
            
            if let dictionary = UserDefaults.standard.object(forKey: kCURRENTUSER) {
                
                return FirebaseUser.init(_dictionary: dictionary as! NSDictionary)
            }
        }
        
        return nil
        
    }
    
    
    
    //MARK: Login function
    
    class func loginUserWith(email: String, password: String, completion: @escaping (_ error: Error?) -> Void) {
        
        Auth.auth().signIn(withEmail: email, password: password, completion: { (firUser, error) in
            
            if error != nil {
                
                completion(error)
                return
                
            } else {
                
                //get user from firebase and save locally
                fetchCurrentUserFromFirestore(userId: firUser!.user.uid)
                completion(error)
            }
            
        })
        
    }
    
    //MARK: Register functions
    
    class func registerUserWith(email: String, password: String, name: String, completion: @escaping (_ error: Error?) -> Void ) {
        
        Auth.auth().createUser(withEmail: email, password: password, completion: { (firuser, error) in
            
            if error != nil {
                
                completion(error)
                return
            }
            
            let firebaseUser = FirebaseUser(_objectId: firuser!.user.uid, _pushId: "", _createdAt: Date(), _updatedAt: Date(), _email: firuser!.user.email!, _name: name, _loginMethod: kEMAIL, _phoneNumber: "", _city: "", _country: "")
            
            
            saveUserLocally(firebaseUser: firebaseUser)
            saveUserToFirestore(firebaseUser: firebaseUser)
            completion(error)
            
        })
        
    }
    
    
    
    //MARK: LogOut func
    
    class func logOutCurrentUser(completion: @escaping (_ success: Bool) -> Void) {
        
        userDefaults.removeObject(forKey: kPUSHID)
        removeOneSignalId()
        
        userDefaults.removeObject(forKey: kCURRENTUSER)
        userDefaults.synchronize()
        
        do {
            try Auth.auth().signOut()
            
            completion(true)
            
        } catch let error as NSError {
            completion(false)
            print(error.localizedDescription)
            
        }
        
        
    }
    
    //MARK: Delete user
    
    class func deleteUser(completion: @escaping (_ error: Error?) -> Void) {
        
        let user = Auth.auth().currentUser
        
        user?.delete(completion: { (error) in
            
            completion(error)
        })
        
    }
    
} //end of class funcs




//MARK: Save user funcs

func saveUserToFirestore(firebaseUser: FirebaseUser) {
    reference(.User).document(firebaseUser.objectId).setData(userDictionaryFrom(user: firebaseUser) as! [String : Any]) { (error) in
        
        print("error is \(error?.localizedDescription)")
    }
}


func saveUserLocally(firebaseUser: FirebaseUser) {
    
    UserDefaults.standard.set(userDictionaryFrom(user: firebaseUser), forKey: kCURRENTUSER)
    UserDefaults.standard.synchronize()
}


//MARK: Fetch User funcs

//New firestore
func fetchCurrentUserFromFirestore(userId: String) {
    
    reference(.User).document(userId).getDocument { (snapshot, error) in
        
        guard let snapshot = snapshot else {  return }
        
        if snapshot.exists {
            print("updated current users param")
            
            UserDefaults.standard.setValue(snapshot.data() as! NSDictionary, forKeyPath: kCURRENTUSER)
            UserDefaults.standard.synchronize()
            
        }
        
    }
    
}


func fetchCurrentUserFromFirestore(userId: String, completion: @escaping (_ user: FirebaseUser?)->Void) {
    
    reference(.User).document(userId).getDocument { (snapshot, error) in
        
        guard let snapshot = snapshot else {  return }
        
        if snapshot.exists {
            
            let user = FirebaseUser(_dictionary: snapshot.data()! as NSDictionary)
            completion(user)
        } else {
            completion(nil)
        }
        
    }
}


//MARK: Helper funcs

func userDictionaryFrom(user: FirebaseUser) -> NSDictionary {
    
    let createdAt = DateFormatter().string(from: user.createdAt)
    let updatedAt = DateFormatter().string(from: user.updatedAt)
    
    return NSDictionary(objects: [user.objectId,  createdAt, updatedAt, user.email, user.loginMethod, user.pushId!, user.name, user.avatar, user.contacts, user.blockedUsers, user.isOnline, user.phoneNumber, user.countryCode, user.city, user.country], forKeys: [kOBJECTID as NSCopying, kCREATEDAT as NSCopying, kUPDATEDAT as NSCopying, kEMAIL as NSCopying, kLOGINMETHOD as NSCopying, kPUSHID as NSCopying, kNAME as NSCopying, kAVATAR as NSCopying, kCONTACT as NSCopying, kBLOCKEDUSERID as NSCopying, kISONLINE as NSCopying, kPHONE as NSCopying, kCOUNTRYCODE as NSCopying, kCITY as NSCopying, kCOUNTRY as NSCopying])
    
}

func getUsersFromFirestore(withIds: [String], completion: @escaping (_ usersArray: [FirebaseUser]) -> Void) {
    
    var count = 0
    var usersArray: [FirebaseUser] = []
    
    //go through each user and download it from firestore
    for userId in withIds {
        
        reference(.User).document(userId).getDocument { (snapshot, error) in
            
            guard let snapshot = snapshot else {  return }
            
            if snapshot.exists {
                
                let user = FirebaseUser(_dictionary: snapshot.data() as! NSDictionary)
                count += 1
                
                //dont add if its current user
                if user.objectId != FirebaseUser.currentId() {
                    usersArray.append(user)
                }
                
            } else {
                completion(usersArray)
            }
            
            if count == withIds.count {
                //we have finished, return the array
                completion(usersArray)
            }
            
        }
        
    }
}


func updateCurrentUserInFirestore(withValues : [String : Any], completion: @escaping (_ error: Error?) -> Void) {
    
    if let dictionary = UserDefaults.standard.object(forKey: kCURRENTUSER) {
        
        var tempWithValues = withValues
        
        let currentUserId = FirebaseUser.currentId()
        
        let updatedAt = DateFormatter().string(from: Date())
        
        tempWithValues[kUPDATEDAT] = updatedAt
        
        let userObject = (dictionary as! NSDictionary).mutableCopy() as! NSMutableDictionary
        
        userObject.setValuesForKeys(tempWithValues)
        
        reference(.User).document(currentUserId).updateData(withValues) { (error) in
            
            if error != nil {
                
                completion(error)
                return
            }
            
            //update current user
            UserDefaults.standard.setValue(userObject, forKeyPath: kCURRENTUSER)
            UserDefaults.standard.synchronize()
            
            completion(error)
        }
        
    }
}


//MARK: OneSignal

func updateOneSignalId() {
    
    if FirebaseUser.currentUser() != nil {
        
        if let pushId = UserDefaults.standard.string(forKey: kPUSHID) {
            setOneSignalId(pushId: pushId)
        } else {
            removeOneSignalId()
        }
    }
}


func setOneSignalId(pushId: String) {
    updateCurrentUserOneSignalId(newId: pushId)
}


func removeOneSignalId() {
    updateCurrentUserOneSignalId(newId: "")
}

//MARK: Updating Current user funcs

func updateCurrentUserOneSignalId(newId: String) {
    
    updateCurrentUserInFirestore(withValues: [kPUSHID : newId]) { (error) in
        if error != nil {
            print("error updating push id \(error!.localizedDescription)")
        }
    }
}

//MARK: Chaeck User block status

func checkBlockedStatus(withUser: FirebaseUser) -> Bool {
    return withUser.blockedUsers.contains(FirebaseUser.currentId())
}
