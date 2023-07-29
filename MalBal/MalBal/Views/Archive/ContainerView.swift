//
//  ContainerView.swift
//  MalBal
//
//  Created by Joy on 2023/07/28.
//

import SwiftUI

struct ContainerView: View {
    
    @Binding var item: ArchiveModel
    @Binding var items: [ArchiveModel]
    @State var showActionSheet: Bool = false
    
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
        item.offset = value.translation.width
    }

    func onEnd(value: DragGesture.Value){
        withAnimation(.easeOut) { item.offset = value.translation.width > 80 ? 88 : 0 }
    }

    func deleteItem(){
        items.removeAll { (item) -> Bool in
            return self.item.id == item.id
        }
    }
}

