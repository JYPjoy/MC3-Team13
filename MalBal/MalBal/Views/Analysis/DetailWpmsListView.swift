//
//  DetailWpmsListView.swift
//  MalBal
//
//  Created by Eric Lee on 2023/07/31.
//

import SwiftUI

struct DetailWpmsListView: View {
    @EnvironmentObject var vm: AnalysisViewModel
    
    var body: some View {
        List(0..<(Int(vm.totalTime) / 60 + 1), id: \.self) { minute in
            Button(action: {
                vm.seekToMinute(minute)
            }) {
                HStack{
                    Text("\(minute)-\(minute + 1)분")
                    Spacer()
                    Text("\(vm.record.detailWpms.indices.contains(minute) ? vm.record.detailWpms[minute] : -1)")
                }
            }
        }
        .listStyle(.plain)
    }
    
    private struct DetailWpmsListCellView: View {
        @EnvironmentObject var vm: AnalysisViewModel
        var index: Int
        
        var body: some View {
            HStack(spacing: 12) {
                Image("\(vm.detailWpmImageName(index: index))")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 48, height: 48)
                
                VStack(alignment: .center, spacing: 4) {
                    Text("\(vm.cellTimeText(index: index))")
                        .font(FontManager.shared.appleSDGothicNeo(.medium, 12))
                        .foregroundColor(Color(hex: "FFFFFF").opacity(0.4))
                    
                    HStack(spacing: 6) {
                        Text("아주 좋아요")
                            .font(FontManager.shared.appleSDGothicNeo(.semibold, 16))
                            .foregroundColor(Color(hex: "FFFFFF"))
                        Text("・")
                            .font(FontManager.shared.appleSDGothicNeo(.semibold, 16))
                            .foregroundColor(Color(hex: "FFFFFF"))
                        Text("420 w/min")
                            .font(FontManager.shared.appleSDGothicNeo(.semibold, 16))
                            .foregroundColor(Color(hex: "FFFFFF"))
                    }
                    
                }
            }
        }
    }
}

struct DetailWpmsListView_Previews: PreviewProvider {
    static let testRecord = Record(createdAt: Date(),
                                   wpm: 100,
                                   detailWpms: [100, 200, 300, 400, 500])
    static let testEnvObject = AnalysisViewModel(record: testRecord)
    
    static var previews: some View {
        DetailWpmsListView()
            .environmentObject(testEnvObject)
    }
}
