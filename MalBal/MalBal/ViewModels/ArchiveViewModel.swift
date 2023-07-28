//
//  ArchiveViewModel.swift
//  MalBal
//
//  Created by Joy on 2023/07/28.
//

import SwiftUI

class ArchiveViewModel: ObservableObject {
    
    @Published var items = [
        ArchiveModel(title: "Mini Challeng 03 발표", date: "2023.08.04"),
        ArchiveModel(title: "Mini Challeng 02 발표", date: "2023.07.18"),
        ArchiveModel(title: "Mini Challeng 03 발표", date: "2023.08.04"),
        ArchiveModel(title: "Mini Challeng 02 발표", date: "2023.07.18")
    ]
}
