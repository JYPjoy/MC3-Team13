//
//  TestAudioRecordingView.swift
//  MalBal
//
//  Created by Eric Lee on 2023/07/20.
//

import SwiftUI
import AVKit

struct TestAudioRecorderView: View{
    
    @StateObject var vm = TranscribingViewModel()
    
    @State var record = false
    // creating instance for recording
    
    //AVAudioSession : OS 단에서 관리하는 오디오 모듈과 통신할 수 있도록 돕는 객체
    @State var session: AVAudioSession!
    @State var recorder: AVAudioRecorder!
    @State var audioPlayer: AVAudioPlayer?
    @State var alert = false
    // Fetch Audios
    @State var audios: [URL] = []
    @State var time: TimeInterval = 100
    
    var body: some View{
        NavigationView{
            VStack {
                
                List(self.audios, id: \.self){i in
                    
                    Button(action: {
                        // Play the selected audio
                        self.playAudio(url: i)
                        vm.performKoreanSpeechToText(url: i) { _ in
                            print(vm.recognizedText)
                        }
                    }) {
                        Text(i.lastPathComponent)
                        Text(vm.recognizedText)
                        Text("\(calculateWPM(time:self.time))")
                    }
                }
                
                Button {
                    do{
                        if self.record{
                            // Already Started Recording means stopping and saving...
                            self.recorder.stop()
                            self.record.toggle()
                            // updating data for every rcd...
                            self.setAudios()
                            return
                        }
                        
                        let url = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
                        
                        // same file name...
                        // so were updating based on audio count
                        let fileName = url.appendingPathComponent("myRcd\(self.audios.count + 1).m4a")
                        
                        let settings = [
                            
                            AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
                            AVSampleRateKey: 12000,
                            AVNumberOfChannelsKey: 1,
                            AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue
                            
                        ]
                        self.recorder = try AVAudioRecorder(url: fileName, settings: settings)
                        self.recorder.record()
                        self.record.toggle()
                    }
                    catch{
                        print(error.localizedDescription)
                    }
                } label: {
                    ZStack{
                        Circle()
                            .fill(Color.red)
                            .frame(width: 70, height: 70)
                        
                        if self.record{
                            Circle()
                                .stroke(Color.white, lineWidth: 6)
                                .frame(width: 85, height: 85)
                        }
                        
                    }
                }
                .padding(.vertical, 25)
            }
            .navigationTitle("Record Audio")
        }
        .alert("Error", isPresented: self.$alert){
            Button("Enable Access", role: .cancel){}
        }
        .onAppear{
            do{
                self.session = AVAudioSession.sharedInstance()
                try self.session.setCategory(.playAndRecord)
                
                // 녹음 권한 요청
                self.session.requestRecordPermission { (status) in
                    if !status{
                        self.alert.toggle()
                    }else{
                        self.setAudios()
                    }
                }
            }
            catch{
                print(error.localizedDescription)
            }
        }
    }
    
    func setAudios(){
        do{
            let url = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
            
            //fetch all data
            let result = try FileManager.default.contentsOfDirectory(at: url, includingPropertiesForKeys: nil, options: .producesRelativePathURLs)
            
           
            //updated means remove all old data..
            self.audios.removeAll()
            
            for i in result{
                self.audios.append(i)
            }
            
        }catch{
            print(error.localizedDescription)
        }
    }
    
    // Play audio function
    func playAudio(url: URL) {
        do {
            self.audioPlayer = try AVAudioPlayer(contentsOf: url)
            self.audioPlayer?.play()
            self.time = self.audioPlayer?.duration ?? 1
        } catch {
            print("Error playing audio: \(error.localizedDescription)")
        }
    }
    
    func calculateWPM(time: TimeInterval) -> Double{
        let wordCount = Double(vm.recognizedText.split(separator: " ").count)
        let wps = wordCount/time
        return wps*60
    }
}

struct TestAudioRecorderView_Previews: PreviewProvider {
    static var previews: some View {
        TestAudioRecorderView()
    }
}
