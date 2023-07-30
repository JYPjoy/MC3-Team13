//
//  NewPracticeListView.swift
//  MalBal
//
//  Created by Joy on 2023/07/29.
//

import SwiftUI
import RealmSwift

struct PracticeListView: View {
    @Environment(\.dismiss) var dismiss
    @State var practiceTopic: String = ""
    @State var selectedDate: Date = Date() //TODO: Date ➡️ String
    @ObservedRealmObject var archive: ArchiveRealmModel
    
    // MARK: body
    var body: some View {
        NavigationView {
            ZStack{
                Color.main2.ignoresSafeArea()
                VStack {
                    headerView.frame(height: 44)
                    infoView.frame(height:216)
                    excerciseListView.frame(maxHeight: .infinity) //464
                }
            }
        }
        .navigationBarBackButtonHidden(true)
    }
    
    // 상단 네비게이션 바
    var headerView: some View {
        HStack {
            Button(action: {
                dismiss()
            }) {
                Image(systemName: "chevron.left") // image name
                    .resizable()
                    .scaledToFit()
                    .frame(width: 16, height: 22)
                    .foregroundColor(Color.white)
            }
            Spacer()
            Text("보관함 만들기").foregroundColor(Color.white)
                .font(FontManager.shared.appleSDGothicNeo(.semibold, 20))
            Spacer()
        }.padding()
    }
    
    
    //infoView(발표 주제, 발표 날짜 관련)
    var infoView: some View {
        VStack(spacing: 16) {
            RoundedRectangle(cornerRadius: 16)
                .stroke(Color.white, lineWidth: 0.5)
                .frame(width: GLConstants.glScreenWidth - 48, height: 72)
                .overlay (
                    VStack(spacing:0){
                        Spacer().frame(height:11)
                        HStack{
                            Spacer().frame(width: 16)
                            Text("발표 주제를 써 주세요")
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
                        DatePicker("", selection: $selectedDate)
                            .datePickerStyle(.compact)
                            .padding()
                    }
                )
        }
    }
    
    //exerciseListView(연습 리스트)
    var excerciseListView: some View {
        VStack(spacing: 24) {
            HStack{
                Spacer().frame(width: 24)
                Text("연습 리스트")
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .foregroundColor(.white)
                    .font(FontManager.shared.appleSDGothicNeo(.semibold, 20))
            }

            Text("아직 발표연습 리스트가 없어요")
                .foregroundColor(.white.opacity(0.4))
                .font(FontManager.shared.appleSDGothicNeo(.semibold, 16))
            
        }
    }    
}
