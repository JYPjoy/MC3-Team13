//
//  NewPracticeListView.swift
//  MalBal
//
//  Created by Joy on 2023/07/29.
//

import SwiftUI
import RealmSwift

enum PracticeState {
    case new
    case none
    case list
}

struct PracticeListView: View {
    @Environment(\.dismiss) var dismiss
    @State var navBarTitle: String = "보관함 만들기"
    @State var practiceTopic: String = ""
    @State var selectedDate: Date = Date() //TODO: Date ➡️ String
    @ObservedRealmObject var archive: ArchiveRealmModel
    var presentationInfoView: PresentationInfoView?
    
    // MARK: body
    var body: some View {
        NavigationView {
            ZStack(alignment:.bottom){
                Color.main2.ignoresSafeArea()
                VStack(spacing:0) {
                    NavigationBar(dismiss: _dismiss, navBarTitle: $navBarTitle).frame(height:44)
                    PresentationInfoView.init(practiceTopic: $practiceTopic).frame(height:216)
                    ExerciseListView().frame(maxHeight: .infinity)
                    Spacer()
                }
                buttonView
            }
        }
        .navigationBarBackButtonHidden(true)
    }
    
    // 하단의 버튼
    var buttonView: some View {
        ZStack {
            Button {
                //TODO: ArchiveRealmModel 모델 만들기
                dismiss()
            } label: {
                RoundedRectangle(cornerRadius: 16)
                    .frame(width: GLConstants.glScreenWidth - 48, height:64)
                    .foregroundColor(Color(UIColor(.main3)))
                    .overlay(
                        Text("새 보관함 만들기")
                            .font(FontManager.shared.appleSDGothicNeo(.semibold, 20))
                            .foregroundColor(.white)
                            .padding()
                            .padding(.horizontal, 16)
                    )
            }
        }
    }
}
