import SwiftUI
import RealmSwift

struct ContentView: View {
    var body: some View {
        //mainView()
        ArchiveView(archive: ArchiveRealmModel())
            .onAppear(perform: UIApplication.shared.addTapGestureRecognizer)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

