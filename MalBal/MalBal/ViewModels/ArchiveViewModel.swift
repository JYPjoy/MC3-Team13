//
//  ArchiveViewModel.swift
//  MalBal
//
//  Created by Joy on 2023/07/28.
//

import SwiftUI

class ArchiveViewModel: ObservableObject {
    @Published var item: ArchiveRealmModel
    
    init(item: ArchiveRealmModel) {
        self.item = item
    }
    
    func getActionSheet() -> ActionSheet {
        let deleteButton: ActionSheet.Button = .destructive(Text("삭제하기")) {
            self.deleteItem()
        }
        let cancelButton: ActionSheet.Button = .cancel()
        
        return ActionSheet(
        title: Text("보관함 삭제"),
        message: Text("보관함 안에 있는 모든 연습이 함께 삭제돼요."),
        buttons: [ deleteButton, cancelButton ]
        )
    }
    
    func onChanged(value: DragGesture.Value){
        let thawedItem = item.thaw()
        if thawedItem?.isInvalidated == false { //☑️ Validation 체크
            let thawedRealm = thawedItem!.realm! // realm 불러오기
            try? thawedRealm.write { item.thaw()?.setValue(value.translation.width, forKey: "offset") }
        }
    }
    
    func onEnd(value: DragGesture.Value){
        withAnimation(.easeOut) {
            let offset = value.translation.width > 80 ? 88 : 0
            let thawedItem = item.thaw()
            if thawedItem?.isInvalidated == false {
                let thawedRealm = thawedItem!.realm!
                try? thawedRealm.write { item.thaw()?.setValue(offset, forKey: "offset") }
            }
        }
    }
    
    func deleteItem() {
        let thawedItem = item.thaw()
        if thawedItem?.isInvalidated == false {
            let thawedRealm = thawedItem!.realm!
            try? thawedRealm.write { thawedRealm.delete(thawedItem ?? ArchiveRealmModel()) }
        }
    }
}
