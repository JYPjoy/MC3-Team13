//
//  AnalysisPopupView.swift
//  MalBal
//
//  Created by Joy on 2023/08/03.
//

import SwiftUI

struct AnalysisPopupView: View {
    var body: some View {
        ZStack {
            PopupView(iconName: "warningMark", popupTitle: "분석을 중단할까요?", contentsText: "분석을 중단하면\n지금까지 진행한 내용은 사라져요", confirmText: "계속 분석하기") {
                print("중단하기") //TODO: 중단하기 관련 함수 위치
            } didTapConfirm: {
                print("계속 분석하기") // TODO: 계속 분석하기 로직 추가
            }
        }
    }
}

struct AnalysisPopupView_Previews: PreviewProvider {
    static var previews: some View {
        AnalysisPopupView()
    }
}
