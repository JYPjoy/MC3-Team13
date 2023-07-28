//
//  AnalysisCardView.swift
//  MalBal
//
//  Created by Eric Lee on 2023/07/28.
//

import SwiftUI

struct AnalysisCardView: View {
    private var record: Record
    
    @State private var frontDegree: Double = 0.0
    @State private var backDegree: Double = 90.0
    @State private var isFlipped: Bool = false
    
    private let size: CGSize
    private let durationAndDelay : CGFloat
    private let cornerRadius: CGFloat
    
    init(record: Record = Record(createdAt: Date(),
                                 wpm: 100,
                                 detailWpms: [100, 200, 300, 400, 500]),
         size: CGSize = CGSize(width: 345, height: 200),
         durationAndDelay: CGFloat = 0.3,
         cornerRadius: CGFloat = 16) {
        self.record = record
        self.size = size
        self.durationAndDelay = durationAndDelay
        self.cornerRadius = cornerRadius
    }
    
    var body: some View {
        ZStack{
            AnalysisCardFrontView(record: record, degree: $frontDegree, cornerRadius: self.cornerRadius)
            AnalysisCardBackView(record: record, degree: $backDegree, cornerRadius: self.cornerRadius)
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
        let record: Record
        
        let size: CGSize
        let cornerRadius: CGFloat
        @Binding var degree : Double
        
        init(record: Record,
             degree: Binding<Double>,
             size: CGSize = CGSize(width: 345, height: 200),
             cornerRadius: CGFloat = 16) {
            self.record = record
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
                Text("Front")
            }
            .rotation3DEffect(Angle(degrees: degree), axis: (x: 0, y: 1, z: 0))
        }
    }
}

//MARK: - AnalysisCardBackView
extension AnalysisCardView {
    private struct AnalysisCardBackView: View {
        let record: Record
        
        let size: CGSize
        let cornerRadius: CGFloat
        @Binding var degree : Double
        
        init(record: Record,
             degree: Binding<Double>,
             size: CGSize = CGSize(width: 345, height: 200),
             cornerRadius: CGFloat = 16) {
            self.record = record
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
                Text("Back")
            }
            .rotation3DEffect(Angle(degrees: degree), axis: (x: 0, y: 1, z: 0))
        }
    }
}

struct AnalysisCardView_Previews: PreviewProvider {
    static var previews: some View {
        AnalysisCardView()
    }
}
