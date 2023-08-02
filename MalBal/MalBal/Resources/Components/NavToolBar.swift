//
//  NavToolBar.swift
//  MalBal
//
//  Created by Eric Lee on 2023/08/02.
//

import SwiftUI

struct NavToolBar: View {
    @Environment(\.presentationMode) var presentationMode
    var navBarTitle: String
    var backButtonActive: Bool
    
    init(navBarTitle: String, backButtonActive: Bool = true) {
        self.navBarTitle = navBarTitle
        self.backButtonActive = backButtonActive
    }
    
    var body: some View {
        HStack{
            
            backButton
                .opacity(backButtonActive ? 1 : 0)
            
            Spacer()
            
            Text(navBarTitle)
                .foregroundColor(Color.white)
                .font(FontManager.shared.appleSDGothicNeo(.semibold, 20))
            
            Spacer()
            
            backButton
                .opacity(0)
        }
        .frame(height: 44)
        .padding(.bottom, 10)
    }
    
    private var backButton: some View{
        Button {
            presentationMode.wrappedValue.dismiss()
            print("뒤로가기")
        } label: {
            Image(systemName: "chevron.backward")
                .font(FontManager.shared.appleSDGothicNeo(.semibold, 20))
                .foregroundColor(Color.white)
                .frame(width: 44, height: 44)
        }
        .padding()
    }
}

