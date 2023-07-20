import SwiftUI
import AVKit
import AVFoundation
import MobileCoreServices
import Speech

struct UploadingView: View {
    @StateObject var UploadingViewModel = UplodaingViewModel()
    
    @State private var isPresentingPicker = false
    @State private var videoURL: URL?
    private let player = AVPlayer()
    
    var body: some View {
        NavigationView {
            VStack {
                Button("Choose Video") {
                    isPresentingPicker = true
                }
                .padding()
                .background(Color.blue)
                .foregroundColor(.white)
                .cornerRadius(10)
                .sheet(isPresented: $isPresentingPicker) {
                    VideoPickerView(videoURL: $videoURL)
                }
                
                if let videoURL = videoURL {
                    VideoPlayer(player: AVPlayer(url: videoURL))
                        .frame(height: 300)
                    
                    Button("Extract Audio") {
                        try! AVAudioSession.sharedInstance().setCategory(.playback, options: [])
                        UploadingViewModel.extractAudio(from: videoURL)
                        UploadingViewModel.performKoreanSpeechToText(url: videoURL) {_ in
                            print("해치웠나?")
                        }
                    }
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
                }
                
                //            Button("Play the m4a file") {
                //                playAudio()
                //            }
                //            .padding()
                //            .background(Color.blue)
                //            .foregroundColor(.white)
                //            .cornerRadius(10)
                
                NavigationLink(destination: Text(UploadingViewModel.recognizedText)) {
                    Text("wow")
                }
                
//                Text("Recognized Text:")
//                Text(UploadingViewModel.recognizedText)
                
                Button("delete the all the m4a file") {
                    UploadingViewModel.deleteM4AFilesInDocumentsDirectory()
                }
                .padding()
                .background(Color.blue)
                .foregroundColor(.white)
                .cornerRadius(10)
                
            }
        }
        .padding()
    }
    
    
}

struct UploadingView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}


