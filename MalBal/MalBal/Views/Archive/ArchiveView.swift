//
//  ArchiveView.swift
//  MalBal
//
//  Created by Joy on 2023/07/27.
//

import SwiftUI

struct ArchiveView: View {
    
    // MARK: body
    @StateObject var archiveData = ArchiveViewModel()

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
                            ForEach(archiveData.items) { item in
                                ContainerView(item: $archiveData.items[getIndex(item: item)], items: $archiveData.items)
                            }
                        }
                    
                        Spacer().frame(height: 16)
                        
                        Button {
                            // TODO: Grid 요소 추가 필요
                        } label: {
                            Rectangle()
                                .fill(Color(UIColor(Color.main4)))
                                .frame(width: GLConstants.glScreenWidth - 48, height:80)
                                .cornerRadius(16)
                                .overlay(Image(systemName: "plus").foregroundColor(Color.white.opacity(0.4)))
                        }
                    }
                }
                NavigationLink {
                
                } label: {

                }
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: {
                        
                    }, label: { Image(systemName: "chevron.down").foregroundColor(.white)})
                }
            }
        }
    }
                                              
      func getIndex(item: ArchiveModel)->Int{
          
          return archiveData.items.firstIndex { (item1) -> Bool in
              return item.id == item1.id
          } ?? 0
      }
}

struct ArchiveView_Previews: PreviewProvider {
    static var previews: some View {
        ArchiveView()
    }
}

