//
//  TestPopupView.swift
//  MalBal
//
//  Created by Joy on 2023/08/03.
//

import SwiftUI

struct TestPopupView: View {
    var body: some View {
        ZStack {
            PopupView(iconName: String, popupTitle: String, contentsText: String, confirmText: String, didTapCancel: ( () -> Void)?, didTapConfirm: (() -> Void)?)
        }
    }
}

struct TestPopupView_Previews: PreviewProvider {
    static var previews: some View {
        TestPopupView()
    }
}
