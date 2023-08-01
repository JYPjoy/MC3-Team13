//
//  NavigationBar.swift
//  MalBal
//
//  Created by Joy on 2023/07/30.
//

import SwiftUI

struct NavigationBar: View {
    @Environment(\.dismiss) var dismiss
    @Binding var navBarTitle: String
    
    var body: some View {
        HStack {
            Button(action: {
                dismiss()
            }) {
                Image(systemName: "chevron.left")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 16, height: 22)
                    .foregroundColor(Color.white)
            }
            Spacer()
            Text(navBarTitle).foregroundColor(Color.white)
                .font(FontManager.shared.appleSDGothicNeo(.semibold, 20))
            Spacer()
        }.padding()
    }
}
