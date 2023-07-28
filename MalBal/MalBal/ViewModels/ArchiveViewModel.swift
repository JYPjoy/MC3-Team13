//
//  ArchiveViewModel.swift
//  MalBal
//
//  Created by Joy on 2023/07/28.
//

import SwiftUI

class ArchiveViewModel: ObservableObject {
    
    @Published var items = [
        ArchiveModel(title: "Mini Challeng 01 발표", date: "2023.08.04", offset: 0, isSwiped: false),
        ArchiveModel(title: "Mini Challeng 02 발표", date: "2023.07.18", offset: 0, isSwiped: false),
        ArchiveModel(title: "Mini Challeng 03 발표", date: "2023.08.04", offset: 0, isSwiped: false),
        ArchiveModel(title: "Mini Challeng 04 발표", date: "2023.07.18", offset: 0, isSwiped: false)
    ]
}
