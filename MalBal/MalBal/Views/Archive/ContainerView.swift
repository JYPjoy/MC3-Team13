//
//  ContainerView.swift
//  MalBal
//
//  Created by Joy on 2023/07/28.
//

import SwiftUI
import RealmSwift

struct ContainerView: View {
    
    @Environment(\.realm) var realm
    @State var showActionSheet: Bool = false
    let item: ArchiveRealmModel
    
    var body: some View {
        Button{
            // TODO: 화면 전환 이벤트 필요
        } label: {
            RoundedRectangle(cornerRadius: 16)
                .fill(Color(UIColor(Color.main4)))
                .frame(width: GLConstants.glScreenWidth - 48, height:80)
                .overlay(buttonContainerView)
        }
    }
    
    var buttonContainerView: some View {
        ZStack{
            // 맨 뒤에 색깔 배경
            RoundedRectangle(cornerRadius: 16).fill(Color(UIColor(Color.main2)))
            
            HStack(spacing: 8) {
                RoundedRectangle(cornerRadius: 17)
                    .fill(Color(UIColor(Color.main5)))
                    .frame(width: 64, height: 80)
                    .opacity(item.offset > 0 ? 1 : 0)
                
                RoundedRectangle(cornerRadius: 17)
                    .fill(Color(UIColor(Color.main4)))
                    .opacity(item.offset > 0 ? 1 : 0)
            }
            
            // 쓰레기통 아이콘
            HStack() {
                Spacer().frame(width: 20)
                Button(action: {
                    withAnimation(.easeIn){ showActionSheet.toggle() } 
                }) {
                    Image(systemName: "trash")
                        .font(.title2)
                        .foregroundColor(.white)
                }
                .frame(width: 22, height: 22)
                Spacer()
            }
        
            // 맨 위의 item 컴포넌트
            HStack {
                RoundedRectangle(cornerRadius: 16)
                    .fill(Color(UIColor(Color.main4)))
                    .overlay(
                        HStack(spacing: 16){
                            VStack(spacing: 6){
                                Text(item.title)
                                    .font(FontManager.shared.appleSDGothicNeo(.semibold, 20))
                                    .foregroundColor(.white)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                Text(item.date)
                                    .foregroundColor(.white.opacity(0.4))
                                    .frame(maxWidth: .infinity, alignment: .leading)
                            }
                            .frame(width: GLConstants.glScreenWidth * 0.7)
                 
                            Image(systemName: "chevron.right")
                                .frame(width: 16, height: 22)
                                .foregroundColor(Color(hex: "FFFFFF").opacity(0.3))
                                .font(.system(size: 24, weight: .semibold))
                        }
                    )
            }
            .offset(x: item.offset)
            .gesture(DragGesture().onChanged(onChanged(value:)).onEnded(onEnd(value:)))
            .actionSheet(isPresented: $showActionSheet) {
                getActionSheet()
            }
        }
    }
    
    func getActionSheet() -> ActionSheet {
        let deleteButton: ActionSheet.Button = .destructive(Text("삭제하기")) {
            deleteItem()
        }
        let cancelButton: ActionSheet.Button = .cancel()
        
        return ActionSheet(
        title: Text("보관함 삭제"),
        message: Text("보관함 안에 있는 모든 연습리스트가 삭제돼버려요."),
        buttons: [ deleteButton, cancelButton ]
        )
    }

    func onChanged(value: DragGesture.Value){
        try? realm.write {
            item.thaw()?.setValue(value.translation.width, forKey: "offset")
        }
    }

    func onEnd(value: DragGesture.Value){
        withAnimation(.easeOut) {
            let offset = value.translation.width > 80 ? 88 : 0
            try? realm.write { item.thaw()?.setValue(offset, forKey: "offset") }
        }
    }

    func deleteItem() {
        let thawedItem = item.thaw()
        if thawedItem?.isInvalidated == false { //☑️ Validation 체크
            let thawedRealm = thawedItem!.realm! // realm 불러오기
            try? thawedRealm.write { thawedRealm.delete(thawedItem ?? ArchiveRealmModel()) }
        }
    }
}

