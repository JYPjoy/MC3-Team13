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
    
    var body: some View {
        Button{
            // TODO: 화면 전환 이벤트 필요
        }label: {
            RoundedRectangle(cornerRadius: 16)
                .frame(width: GLConstants.glScreenWidth - 48, height:80)
                .overlay(buttonContainerView)
        }
    }
    
    var buttonContainerView: some View {
        ZStack{
            //RoundedRectangle(cornerRadius: 16).fill(Color(UIColor(Color.main2)))

            HStack{
                Spacer()
                Button(action: {
                    withAnimation(.easeIn){ deleteItem() }
                }) {
                    Image(systemName: "trash")
                        .font(.title)
                        .foregroundColor(.white)
                        .frame(width: 20, height: 22)
                        .background(.yellow)
                    
                }
                .buttonStyle(.borderless)
                .tint(.pink)
                //.buttonStyle(.borderless)
                Spacer().frame(width: 25)
            }
        
            ZStack {
                RoundedRectangle(cornerRadius: 16)
                    .fill(Color(UIColor(Color.main4)))
                HStack{
                    Spacer().frame(width:16)
                    VStack(spacing: 6){
                        Text(item.title)
                            .font(FontManager.shared.appleSDGothicNeo(.semibold, 20))
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity, alignment: .leading)
                        Text(item.date)
                            .foregroundColor(.white.opacity(0.4))
                            .frame(maxWidth: .infinity, alignment: .leading)
                    }
                    .frame(width: GLConstants.glScreenWidth*0.7)
                    Image(systemName: "chevron.right").foregroundColor(Color.white).opacity(0.3)
                }
                Spacer().frame(width:24)
            }
            .offset(x: item.offset)
            .gesture(DragGesture().onChanged(onChanged(value:)).onEnded(onEnd(value:)))
        }
    }
    
    
    func onChanged(value: DragGesture.Value){
        if value.translation.width < 0{
            
            if item.isSwiped{
                item.offset = value.translation.width + 50
            }
            else{
                item.offset = value.translation.width
            }
        }
    }
    
    // TODO: 드래그 width 너비 제한해야 함
    func onEnd(value: DragGesture.Value){
        
        withAnimation(.easeOut){
            if value.translation.width < 0 {
                if -value.translation.width > GLConstants.glScreenWidth / 2{ //반 이상 넘어갔을 때 삭제
                    item.offset = -1000
                    deleteItem()
                }
                else if -item.offset > 50{
                    // updating is Swipng...
                    item.isSwiped = true
                    item.offset = -90
                }
                else{
                    item.isSwiped = false
                    item.offset = 0
                }
            }
            else{
                item.isSwiped = false
                item.offset = 0
            }
        }
    }
    
    // removing Item...
    
    func deleteItem(){
        
        items.removeAll { (item) -> Bool in
            return self.item.id == item.id
        }
    }
}

