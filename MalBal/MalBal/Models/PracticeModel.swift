//
//  PracticeModel.swift
//  MalBal
//
//  Created by Joy on 2023/07/30.
//

import Foundation
import RealmSwift

class PracticeRealmModel: Object, ObjectKeyIdentifiable {
    @Persisted(primaryKey: true) var id : ObjectId
    
    @Persisted var speedImage: String
    @Persisted var title: String
    @Persisted var speed: String
    @Persisted var time: String
    @Persisted var isLiked: Bool
}
