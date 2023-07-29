//
//  AnalysisCardView.swift
//  MalBal
//
//  Created by Eric Lee on 2023/07/28.
//

import SwiftUI

struct AnalysisCardView: View {
    @EnvironmentObject var vm: AnalysisViewModel
    
    @State private var frontDegree: Double = 0.0
    @State private var backDegree: Double = 90.0
    @State private var isFlipped: Bool = false
    
    private let size: CGSize
    private let durationAndDelay : CGFloat
    private let cornerRadius: CGFloat
    
    init(size: CGSize = CGSize(width: 345, height: 200),
         durationAndDelay: CGFloat = 0.3,
         cornerRadius: CGFloat = 16) {
        self.size = size
        self.durationAndDelay = durationAndDelay
        self.cornerRadius = cornerRadius
    }
    
    var body: some View {
        ZStack{
            AnalysisCardFrontView(degree: $frontDegree, cornerRadius: self.cornerRadius)
            AnalysisCardBackView(degree: $backDegree, cornerRadius: self.cornerRadius)
        }.onTapGesture {
            flipCard ()
        }
    }
    
    //MARK: 카드 플립 기능
    private func flipCard () {
        isFlipped.toggle()
        if isFlipped {
            withAnimation(.linear(duration: durationAndDelay)) {
                backDegree = 90
            }
            withAnimation(.linear(duration: durationAndDelay).delay(durationAndDelay)){
                frontDegree = 0
            }
        } else {
            withAnimation(.linear(duration: durationAndDelay)) {
                frontDegree = -90
            }
            withAnimation(.linear(duration: durationAndDelay).delay(durationAndDelay)){
                backDegree = 0
            }
        }
    }
    
}

//MARK: - AnalysisCardFrontView
extension AnalysisCardView {
    private struct AnalysisCardFrontView: View {
        @EnvironmentObject var vm: AnalysisViewModel
        
        let size: CGSize
        let cornerRadius: CGFloat
        @Binding var degree : Double
        
        init(degree: Binding<Double>,
             size: CGSize = CGSize(width: 345, height: 200),
             cornerRadius: CGFloat = 16) {
            self._degree = degree
            self.size = size
            self.cornerRadius = cornerRadius
        }
        
        var body: some View {
            ZStack{
                
                FrontCardBgView()
                
                Image(self.speedImageName(record: vm.record))
                    .resizable()
                    .frame(width: 64, height: 64)
                    .offset(x: -66)
                
                VStack(alignment: .leading, spacing: 14) {
                    VStack(alignment: .leading, spacing: 6){
                        Text("평균 말하기 속도")
                            .foregroundColor(Color(hex: "FFFFFF").opacity(0.4))
                        Text("아주 좋아요")
                            .foregroundColor(Color(hex: "FFFFFF"))
                    }
                    VStack(alignment: .leading, spacing: 6){
                        Text("전체 분당 단어수")
                            .foregroundColor(Color(hex: "FFFFFF").opacity(0.4))
                        Text("\(vm.record.wpm)/min")
                            .foregroundColor(Color(hex: "FFFFFF"))
                    }
                    VStack(alignment: .leading, spacing: 6){
                        Text("발표시간")
                            .foregroundColor(Color(hex: "FFFFFF").opacity(0.4))
                        Text("10:05.26")
                            .foregroundColor(Color(hex: "FFFFFF"))
                    }
                }
                .offset(x: 88)
                
                Image(systemName: "info.circle.fill")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 19, height: 22)
                    .foregroundColor(Color(hex: "FFFFFF").opacity(0.3))
                    .offset(x: 153, y: 81)
                
            }
            .frame(width: size.width, height: size.height)
            .clipShape(RoundedRectangle(cornerRadius: self.cornerRadius))
            .rotation3DEffect(Angle(degrees: degree), axis: (x: 0, y: 1, z: 0))
        }
        
        private struct FrontCardBgView: View {
            var body: some View {
                ZStack{
                    Rectangle()
                        .foregroundColor(Color.main4)
                    Circle()
                        .foregroundColor(Color(hex: "052E37").opacity(0.3))
                        .frame(width: 306, height: 306)
                        .offset(x: -66, y: 4)
                    Circle()
                        .foregroundColor(Color(hex: "052E37").opacity(0.4))
                        .frame(width: 174, height: 174)
                        .offset(x: -66, y: 4)
                    Circle()
                        .foregroundColor(Color(hex: "052E37"))
                        .frame(width: 108, height: 108)
                        .offset(x: -66, y: 4)
                }
            }
        }
        
        private func speedImageName(record: Record) -> String {
            
            switch record.wpm {
            case ..<80:
                return "ic_speed_1"
            case 80..<90:
                return "ic_speed_2"
            case 90..<110:
                return "ic_speed_3"
            case 110..<130:
                return "ic_speed_4"
            case 130...:
                return "ic_speed_5"
            default:
                return "ic_speed_3"
            }
        }
        
    }
}

//MARK: - AnalysisCardBackView
extension AnalysisCardView {
    private struct AnalysisCardBackView: View {
        @EnvironmentObject var vm: AnalysisViewModel
        
        let size: CGSize
        let cornerRadius: CGFloat
        @Binding var degree : Double
        
        init(degree: Binding<Double>,
             size: CGSize = CGSize(width: 345, height: 200),
             cornerRadius: CGFloat = 16) {
            self._degree = degree
            self.size = size
            self.cornerRadius = cornerRadius
        }
        
        var body: some View {
            ZStack{
                Rectangle()
                    .foregroundColor(.blue)
                    .frame(width: 345, height: 200)
                    .cornerRadius(cornerRadius)
                Text("\(vm.record.fileURL.lastPathComponent)")
            }
            .rotation3DEffect(Angle(degrees: degree), axis: (x: 0, y: 1, z: 0))
        }
    }
}

struct AnalysisCardView_Previews: PreviewProvider {
    static let testRecord = Record(createdAt: Date(),
                                   wpm: 100,
                                   detailWpms: [100, 200, 300, 400, 500])
    static let testEnvObject = AnalysisViewModel(record: testRecord)

    static var previews: some View {
        AnalysisCardView()
            .environmentObject(testEnvObject)
    }
}
