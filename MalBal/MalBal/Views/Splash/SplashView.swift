//
//  SplashView.swift
//  MalBal
//
//  Created by Joy on 2023/08/01.
//

import SwiftUI

struct SplashView: View {
    var body: some View {
        NavigationView{
            ZStack {
                Color.main2.ignoresSafeArea()
                LottieView(jsonName: "SplashLottieFiles", loopMode: .loop).ignoresSafeArea()
                
                ZStack{
                    VStack{
                        Spacer().frame(height: 101)
                        Text("발표에 적절한").foregroundColor(.white).font(FontManager.shared.appleSDGothicNeo(.extrabold, 24))
                        Text("스피치 속도 만들기").foregroundColor(.white).font(FontManager.shared.appleSDGothicNeo(.extrabold, 24))
                        Spacer().frame(height: 50)
                        Text("말발과 시작해요").foregroundColor(.white).font(FontManager.shared.appleSDGothicNeo(.extrabold, 24))
            
                        Spacer().frame(height: 520)
                        
                        NavigationLink {
                            HomeView()
                        } label: {
                            RoundedRectangle(cornerRadius: 16)
                                .frame(width: GLConstants.glScreenWidth - 48, height:64)
                                .foregroundColor(Color(UIColor(.main3)))
                                .overlay(
                                    Text("시작하기")
                                        .font(FontManager.shared.appleSDGothicNeo(.semibold, 20))
                                        .foregroundColor(.white)
                                        .padding()
                                        .padding(.horizontal, 16)
                                )
                        }
                    }
                }.ignoresSafeArea()
            }
        }
    }
}

struct SplashView_Previews: PreviewProvider {
    static var previews: some View {
        SplashView()
    }
}
