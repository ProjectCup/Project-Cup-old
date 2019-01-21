//
//  CollectionReference.swift
//  ProjectCup
//
//  Created by Jiatao Xu on 1/19/19.
//  Copyright © 2019 xyy. All rights reserved.
//

import Foundation
import FirebaseFirestore


enum FCollectionReference: String {
    case User
    case Typing
    case Recent
    case Message

}


func reference(_ collectionReference: FCollectionReference) -> CollectionReference{
    return Firestore.firestore().collection(collectionReference.rawValue)
}
