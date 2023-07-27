//
//  ArchiveModel.swift
//  MalBal
//
//  Created by Joy on 2023/07/27.
//

import Foundation
import RealmSwift

class ArchiveModel: Object, ObjectKeyIdentifiable {
    @Persisted(primaryKey: true) var id : ObjectId
    
    @Persisted var title = ""
    @Persisted var date = ""
}


