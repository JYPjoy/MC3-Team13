//
//  ArchiveModel.swift
//  MalBal
//
//  Created by Joy on 2023/07/27.
//

import Foundation
import RealmSwift

struct ArchiveModel: Identifiable {
    var id = UUID().uuidString
    var title: String
    var date: String
    var offset: CGFloat
    var isSwiped: Bool
}

class ArchiveRealmModel: Object, ObjectKeyIdentifiable {
    @Persisted(primaryKey: true) var id : ObjectId
    
    @Persisted var title: String
    @Persisted var date: String
    @Persisted var offset: CGFloat
    @Persisted var isSwiped: Bool
}

extension CGFloat: CustomPersistable {
   public typealias PersistedType = Double
   public init(persistedValue: Double) { self.init(persistedValue) }
   public var persistableValue: Double { Double(self) }
}
