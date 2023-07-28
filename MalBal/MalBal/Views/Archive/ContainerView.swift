//
//  ContainerView.swift
//  MalBal
//
//  Created by Joy on 2023/07/28.
//

import SwiftUI

struct ContainerView: View {
    var body: some View {
        Button{
            // TODO: 화면 전환 이벤트 필요
        }label: {
            Rectangle()
                .fill(Color(UIColor(Color.main4)))
                .frame(width: GLConstants.glScreenWidth - 48, height:80)
                .cornerRadius(16)
                .overlay(buttonContainerView)
        }
    }
    
    
    var buttonContainerView: some View {
        ZStack{
            //TODO: 슬라이드 삭제 버튼 위치
            
            HStack {
                HStack{
                    Spacer().frame(width:16)
                    VStack(spacing: 6){
                        Text("보관함1")
                            .font(FontManager.shared.appleSDGothicNeo(.semibold, 20))
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity, alignment: .leading)
                        Text("보관함2")
                            .foregroundColor(.white.opacity(0.4))
                            .frame(maxWidth: .infinity, alignment: .leading)
                    }
                    .frame(width: GLConstants.glScreenWidth*0.7)
                    Image(systemName: "chevron.right").foregroundColor(Color.white).opacity(0.3)
                }
                Spacer().frame(width:24)
            }
        }
    }
}

struct ContainerView_Previews: PreviewProvider {
    static var previews: some View {
        ContainerView()
    }
}
