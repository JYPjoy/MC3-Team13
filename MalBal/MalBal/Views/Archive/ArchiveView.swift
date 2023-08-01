//
//  ArchiveView.swift
//  MalBal
//
//  Created by Joy on 2023/07/27.
//

import SwiftUI
import RealmSwift

struct ArchiveView: View {
    
    @Environment(\.realm) var realm
    @Environment(\.dismiss) var dismiss
    @ObservedResults(ArchiveRealmModel.self) var archiveData

    var body: some View {
        NavigationView {
            ZStack{
                Color(UIColor(Color.main2)).ignoresSafeArea()
                VStack {
                    HStack{
                        Spacer().frame(width: 24)
                        Text("보관함")
                            .foregroundColor(.white)
                            .font(FontManager.shared.appleSDGothicNeo(.semibold, 40))
                            .fontWeight(.semibold)
                            .frame(maxWidth:.infinity, alignment: .leading)
                    }
                    
                    ScrollView {
                        LazyVStack(spacing: 16) {
                            ForEach(archiveData) { archive in
                                ContainerView(item: archive)
                            }
                        }
                    
                        Spacer().frame(height: 16)
                        
                        // 추가 버튼
                        NavigationLink {
                            PracticeListView(archive: ArchiveRealmModel())
                        } label: {
                            RoundedRectangle(cornerRadius: 16)
                                .fill(Color(UIColor(Color.main4)))
                                .frame(width: GLConstants.glScreenWidth - 48, height:80)
                                .cornerRadius(16)
                                .overlay(Image(systemName: "plus").foregroundColor(Color.white.opacity(0.4)))
                                .font(.system(size: 24, weight: .semibold))
                        }
                    }
                }
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: {
                        dismiss()
                    }, label: { Image(systemName: "chevron.down").foregroundColor(.white)})
                }
            }
        }
        .navigationBarBackButtonHidden(true)
    }
}


