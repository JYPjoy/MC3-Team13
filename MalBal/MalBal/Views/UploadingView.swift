import SwiftUI
import AVKit
import AVFoundation
import MobileCoreServices
import Speech

struct UploadingView: View {
    //파일 업로드에 필요한 ViewModel 인스턴스 생성
    @StateObject var UploadingViewModel = UplodaingViewModel()
    @StateObject var transcribingViewModel = TranscribingViewModel()
    
    @State private var isPresentingPicker = false
    @State private var videoURL: URL?
    @State private var audioURL: URL?
    private let player = AVPlayer()
    
    var body: some View {
        //임시로 NavigationView로 설정 -> 무시해도 됨
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
                
                //제대로 Video 압축이 완료되어 파일 경로를 받아올 수 있을 때
                if let videoURL = videoURL {
//                    VideoPlayer(player: AVPlayer(url: videoURL))
//                        .frame(height: 300)
                    
                    Button("Extract Audio") {
                        try! AVAudioSession.sharedInstance().setCategory(.playback, options: [])
                    audioURL = UploadingViewModel.extractAudio(from: videoURL)
                        print(audioURL!)
                    }
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
                }
                
                Button("Split") {
                    transcribingViewModel.splitM4AFileIntoOneMinuteSegments(inputFileURL: audioURL!)
                }
                .padding()
                .background(Color.blue)
                .foregroundColor(.white)
                .cornerRadius(10)
                
                Button("Transcribe") {
//                    transcribingViewModel.performKoreanSpeechToText(url: audioURL!) {_ in
//                        print(transcribingViewModel.recognizedText)
//                    }
                    transcribingViewModel.performSTTM4AFiles()
                }
                .padding()
                .background(Color.blue)
                .foregroundColor(.white)
                .cornerRadius(10)
                
                //Transcribe된 문장이 써져 있는 EmptyView로 이동
                NavigationLink(destination: Text(transcribingViewModel.divisionedText)) {
                    Text("wow")
                }
                
//                Text("Recognized Text:")
//                Text(UploadingViewModel.recognizedText)
                
                //앱 내 Documents 폴더 안에 추출된 오디오, 영상 파일 삭제 버튼
                Button("delete the all the m4a file") {
                    UploadingViewModel.deleteM4AFilesInDocumentsDirectory()
                }
                .padding()
                .background(Color.blue)
                .foregroundColor(.white)
                .cornerRadius(10)
                
                Button("delete all temporary M4A Files") {
                    transcribingViewModel.removeAllTempM4AFiles()
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


