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
                
                ZStack {
                    RoundedRectangle(cornerRadius: 35)
                        .fill(Color.main2)
                        .frame(width: 371, height: 322)
                    VStack {
                        Image(iconName)
                            .frame(width: 50, height: 50)
                            .padding()
                        Text(popupTitle)
                            .font(FontManager.shared.appleSDGothicNeo(.extrabold, 20))
                            .multilineTextAlignment(.center)
                            .foregroundColor(.white)
                        Spacer()
                            .frame(height:15)
                        Text(contentsText)
                            .font(FontManager.shared.appleSDGothicNeo(.semibold, 14))
                            .multilineTextAlignment(.center)
                            .foregroundColor(.main4)
                        Spacer()
                            .frame(height:28)
                        
                        HStack {
                            Button{
                                didTapCancel?()
                            }label: {
                                Text("취소")
                                    .font(FontManager.shared.appleSDGothicNeo(.semibold, 16))
                                    .foregroundColor(.white)
                                    .padding()
                                    .padding(.horizontal, 40)
                                    .background(
                                        Color(hex:"B5B5B5").cornerRadius(10)
                                            .shadow(radius: 10)
                                    )
                            }
                            Spacer()
                                .frame(width: 15)
                            
                            Button{
                                didTapConfirm?()
                            }label: {
                                Text(confirmText)
                                    .font(FontManager.shared.appleSDGothicNeo(.semibold, 16))
                                    .foregroundColor(.white)
                                    .padding()
                                    .padding(.horizontal, 35)
                                    .background(
                                        Color(UIColor(Color.main5)).cornerRadius(10)
                                            .shadow(radius: 10)
                                    )
                            }
                        }
                    }
                }
            }
        }
    }
}
