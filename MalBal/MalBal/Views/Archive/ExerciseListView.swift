//
//  ExerciseListView.swift
//  MalBal
//
//  Created by Joy on 2023/07/30.
//

import SwiftUI

struct ExerciseListView: View {
    var body: some View {
        ZStack{
            VStack(spacing: 24) {
                HStack{
                    Spacer().frame(width: 24)
                    Text("연습 리스트")
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .foregroundColor(.white)
                        .font(FontManager.shared.appleSDGothicNeo(.semibold, 20))
                }
                
                ScrollView{
                    Text("아직 발표연습 리스트가 없어요")
                        .foregroundColor(.white.opacity(0.4))
                        .font(FontManager.shared.appleSDGothicNeo(.semibold, 16))
                }
                
                Spacer()
            }
        }
    }
}

struct ExerciseListView_Previews: PreviewProvider {
    static var previews: some View {
        ExerciseListView()
    }
}
