import SwiftUI

struct ModalView: View {

    var body: some View {
        ZStack {
            Text("ji")
        }
        .animation(.easeIn)
        .transition(.move(edge: .bottom))
    }
        
}
