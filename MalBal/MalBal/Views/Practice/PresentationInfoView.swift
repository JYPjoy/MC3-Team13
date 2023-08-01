//
//  PresentationInfoView.swift
//  MalBal
//
//  Created by Joy on 2023/07/30.
//

import SwiftUI

struct PresentationInfoView: View {
    @Binding var practiceTopic: String
   // @Binding var selectedDate: String
    
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
                        VStack(spacing:0){
                            Spacer().frame(height:11)
                            HStack{
                                Spacer().frame(width: 16)
                                Text("발표는 언제하나요?")
                                    .foregroundColor(.white)
                                    .font(FontManager.shared.appleSDGothicNeo(.medium, 12))
                                    .frame(maxWidth: .infinity, alignment: .leading)
                            }
                            Spacer() // TODO: 데이트피커
                            //                        DatePicker("", selection: $selectedDate)
                            //                            .datePickerStyle(.compact)
                            //                            .padding()
                        }
                    )
            }
        }
    }
}
