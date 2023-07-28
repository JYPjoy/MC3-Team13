//
//  AnalysisView.swift
//  MalBal
//
//  Created by Eric Lee on 2023/07/28.
//

import SwiftUI

struct AnalysisView: View {
    @StateObject var vm: AnalysisViewModel
    
    init(record: Record) {
        _vm = StateObject(wrappedValue: AnalysisViewModel(record: record))
    }
    
    var body: some View {
        VStack{
            AnalysisCardView(record: vm.record)
        }
    }
}

struct AnalysisView_Previews: PreviewProvider {
    static var previews: some View {
        AnalysisView(record: Record(createdAt: Date()))
    }
}


