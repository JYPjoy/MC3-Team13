import SwiftUI
import RealmSwift

struct ContentView: View {
    var body: some View {
        //mainView()
        ArchiveView(archive: ArchiveRealmModel())
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

