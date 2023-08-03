//
//  GLPopupView.swift
//  MalBal
//
//  Created by Joy on 2023/07/24.
//

import SwiftUI

struct PopupView: View {
    
    let iconName: String
    let popupTitle: String
    let contentsText: String
    let confirmText: String
    
    let didTapCancel: (() -> Void)?
    let didTapConfirm: (() -> Void)?
    
    public init(iconName: String, popupTitle: String, contentsText: String, confirmText: String, didTapCancel: ( () -> Void)?, didTapConfirm: (() -> Void)?) {
        self.iconName = iconName
        self.popupTitle = popupTitle
        self.contentsText = contentsText
        self.confirmText = confirmText
        self.didTapCancel = didTapCancel
        self.didTapConfirm = didTapConfirm
    }
    
    var body: some View {
        ZStack {
            Color(hex: "000000").opacity(0.5).ignoresSafeArea()
            VStack {
                Spacer()
                RoundedRectangle(cornerRadius: 32)
                    .fill(Color.main2)
                    .frame(width: GLConstants.glScreenWidth, height: 327)
                    .overlay {
                        VStack {
                            Image(iconName)
                                .frame(width: 43, height: 46)
                                .padding()
                            Text(popupTitle)
                                .font(FontManager.shared.appleSDGothicNeo(.extrabold, 20))
                                .multilineTextAlignment(.center)
                                .foregroundColor(.white)
                            Spacer().frame(height: 24)
                            Text(contentsText)
                                .font(FontManager.shared.appleSDGothicNeo(.semibold, 14))
                                .multilineTextAlignment(.center)
                                .foregroundColor(.main4)
                            Spacer().frame(height: 32)
                         
                            HStack {
                                Button{
                                    didTapCancel?()
                                }label: {
                                    Text("중단하기")
                                        .font(FontManager.shared.appleSDGothicNeo(.bold, 16))
                                        .foregroundColor(.white)
                                        .frame(width:158)
                                        .padding(.vertical, 14)
                                        .background(
                                            Color(UIColor(Color.main5)).cornerRadius(10)
                                                .shadow(radius: 10)
                                        )
                                }
                       
                                Spacer()
                                    .frame(width: 15)

                                Button{
                                    didTapConfirm?()
                                }label: {
                                    Text(confirmText)
                                        .font(FontManager.shared.appleSDGothicNeo(.bold, 16))
                                        .foregroundColor(.white)
                                        .frame(width:158)
                                        .padding(.vertical, 14)
                                        .background(
                                            Color(hex:"B5B5B5").cornerRadius(10)
                                      
                                                .shadow(radius: 10)
                                        )
                                }
                                .frame(width:158)
                            }
                            
                        }
                    }
            
            }.ignoresSafeArea()
        }
    }
}
