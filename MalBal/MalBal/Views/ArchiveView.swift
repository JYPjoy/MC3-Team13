//
//  ArchiveView.swift
//  MalBal
//
//  Created by Joy on 2023/07/27.
//

import SwiftUI

struct ArchiveView: View {
    @State var archiveCount: Int = 0
    @State var title: String = ""
    @State var date: String = ""
    
    let columns: [GridItem] = [GridItem(.flexible(), spacing: 6, alignment: nil)]
    
    var body: some View {
        NavigationView {
            ZStack{
                Color(UIColor(Color.main2)).ignoresSafeArea()
                VStack {
                    ScrollView{
                        LazyVGrid(columns: columns,
                                  alignment: .center,
                                  spacing: 16,
                                  pinnedViews: [.sectionHeaders]) {
                            
                            Section(header: Text("보관함")
                                .foregroundColor(.white)
                                .font(FontManager.shared.appleSDGothicNeo(.semibold, 40))
                                .fontWeight(.semibold)
                                .frame(maxWidth:.infinity, alignment: .leading)
                                .padding()
                            ) {
                                ForEach(0..<5){ index in
                                    Rectangle()
                                        .fill(Color(UIColor(Color.main4)))
                                        .frame(width: Constants.glScreenWidth - 48, height:80)
                                        .cornerRadius(16)
                                        .overlay(
                                            contentView
                                        )
                                }
                            }
                        }
                        Spacer().frame(height: 16)
                        
                        Rectangle()
                            .fill(Color(UIColor(Color.main4)))
                            .frame(width: Constants.glScreenWidth - 48, height:80)
                            .cornerRadius(16)
                            .overlay(Image("plus"))
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
    
    var contentView: some View {
        HStack {
            HStack{
                Spacer().frame(width:16)
                VStack(spacing: 6){
                    Text("보관함1")
                        .font(FontManager.shared.appleSDGothicNeo(.semibold, 20))
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    Text("보관함2")
                        .foregroundColor(.white.opacity(0.4))
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
                .frame(width: Constants.glScreenWidth*0.7)
                Image(systemName: "chevron.right").foregroundColor(Color.white).opacity(0.3)
            }
            Spacer().frame(width:24)
        }
    }
}

struct ArchiveView_Previews: PreviewProvider {
    static var previews: some View {
        ArchiveView()
    }
}

