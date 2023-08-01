//
//  DetailWpmsListView.swift
//  MalBal
//
//  Created by Eric Lee on 2023/07/31.
//

import SwiftUI

struct DetailWpmsListView: View {
    @EnvironmentObject var vm: AnalysisViewModel
    
    //Array(vm.record.detailWpms.enumerated())
    let testArray = [70, 80, 90, 100, 110, 120]
    
    var body: some View {
        ZStack{
            
            Rectangle()
                .foregroundColor(.main4)
                .frame(width: 347, height: 191)
            
            ScrollView {
                VStack(alignment: .center, spacing: 0) {
                    ForEach(Array(testArray.enumerated()), id: \.element) { index, wpms in
                        DetailWpmsListCellView(index: index)
                        if index < testArray.count - 1 {
                            scrollDevider
                        }
                    }
                }
                .frame(width: 337)
            }
        }
        .frame(width: 347, height: 191)
        .clipShape(RoundedRectangle(cornerRadius: 16))
    }
    
    private struct DetailWpmsListCellView: View {
        @EnvironmentObject var vm: AnalysisViewModel
        var index: Int
        
        var body: some View {
            HStack(alignment: .top, spacing: 12) {
                Image("\(vm.detailWpmImageName(index: index))")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 48, height: 48)
                    .padding(.leading, 29.5)
                    .padding(.top, 7)
                
                VStack(spacing: 4) {
                    HStack {
                        Text("\(vm.cellTimeText(index: index))")
                            .font(FontManager.shared.appleSDGothicNeo(.medium, 12))
                            .foregroundColor(Color(hex: "FFFFFF").opacity(0.4))
                        Spacer()
                    }
                    
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
                        Spacer()
                    }
                }
                .frame(height: 32)
                .padding(.top, 15)
            }
            .frame(width: 347, height: 64)
        }
        
    }
    
    private var scrollDevider: some View {
        Rectangle()
            .frame(width: 319, height: 0.5)
            .foregroundColor(Color(hex: "FFFFFF").opacity(0.3))
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
//        HomeView()
    }
}
