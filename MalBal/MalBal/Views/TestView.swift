import SwiftUI
import UIKit

struct TestView: View {
    @State private var fileURL: URL?

    var body: some View {
        VStack {
            if let fileURL = fileURL {
                Text("File URL: \(fileURL.path)")
            } else {
                Text("No file selected")
            }

            Button("Select File") {
                showDocumentPicker()
            }
        }
    }

    func showDocumentPicker() {
        let documentPicker = UIDocumentPickerViewController(documentTypes: ["public.audio"], in: .import)
        documentPicker.allowsMultipleSelection = false
        documentPicker.delegate = Coordinator(self)
        UIApplication.shared.windows.first?.rootViewController?.present(documentPicker, animated: true, completion: nil)
    }

    // Coordinator to handle the delegate methods
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    class Coordinator: NSObject, UIDocumentPickerDelegate {
        var parent: TestView

        init(_ parent: TestView) {
            self.parent = parent
        }

        func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
            guard let fileURL = urls.first else {
                return
            }

            parent.fileURL = fileURL
        }

        func documentPickerWasCancelled(_ controller: UIDocumentPickerViewController) {
            parent.fileURL = nil
        }
    }
}

