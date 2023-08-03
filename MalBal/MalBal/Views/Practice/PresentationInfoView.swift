//
//  PresentationInfoView.swift
//  MalBal
//
//  Created by Joy on 2023/07/30.
//

import SwiftUI

struct PresentationInfoView: View {
    @State var originDate: Date = Date()
    @Binding var practiceTopic: String
    @Binding var selectedDate: String
    
//    var currentDate: String {
//        let current = Date()
//        let formatter = DateFormatter()
//        formatter.dateFormat = "yyyy.MM.dd."
//        return formatter.string(from: current)
//    }
//
    var body: some View {
        ZStack{
            VStack(spacing: 16) {
                RoundedRectangle(cornerRadius: 16)
                    .stroke(Color.white, lineWidth: 0.5)
                    .frame(width: GLConstants.glScreenWidth - 48, height: 72)
                    .overlay (
                        VStack(spacing:0){
                            Spacer().frame(height:11)
                            HStack{
                                Spacer().frame(width: 16)
                                Text("발표 주제를 적어보아요")
                                    .foregroundColor(.white)
                                    .font(FontManager.shared.appleSDGothicNeo(.medium, 12))
                                    .frame(maxWidth: .infinity, alignment: .leading)
                            }
                            TextField("", text: $practiceTopic).padding()
                                .foregroundColor(.white)
                                .font(FontManager.shared.appleSDGothicNeo(.semibold, 16))
                        }
                    )
                
                RoundedRectangle(cornerRadius: 16)
                    .stroke(Color.white, lineWidth: 0.5)
                    .frame(width: GLConstants.glScreenWidth - 48, height: 72)
                    .overlay (
                        VStack {
                            Spacer().frame(height:11)
                            HStack{
                                Spacer().frame(width: 16)
                                Text("발표는 언제하나요?")
                                    .foregroundColor(.white)
                                    .font(FontManager.shared.appleSDGothicNeo(.medium, 12))
                                    .frame(maxWidth: .infinity, alignment: .leading)
                            }
                            
                            Spacer().frame(height: 5)
                            
                            HStack{
                                Spacer().frame(width: 16)
                                DatePicker("", selection: $originDate, displayedComponents: .date)
                                    .labelsHidden()
                                    .colorMultiply(Color.white)
                                    .colorInvert()
                                    .accentColor(.white)
                                    .datePickerStyle(.compact)
                                    .environment(\.locale, Locale.init(identifier: "ko_KR"))
                                    .frame(width: 120, alignment: .leading)
                                Spacer()
                            }
                        }
                    )
            }
        }
    }
}
