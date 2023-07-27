//
//  TestAudioRecordingView.swift
//  MalBal
//
//  Created by Eric Lee on 2023/07/20.
//
import SwiftUI

// Test View For
struct TestRecordingView: View{
    
    @State var alert = false
    @StateObject var vm = RecordingViewModel()
    
    var body: some View{
        NavigationView{
            VStack {
                
                Text(vm.record != nil ? "파일 있음" : "파일 없음")
                    .padding()
                
                HStack{
                    
                    Spacer()
                    
                    Button {
                        vm.deleteRecord()
                    } label: {
                        Image(systemName: "trash.circle.fill")
                            .resizable()
                            .frame(width: 70, height: 70)
                    }
                    
                    Spacer()
                    
                    Button {
                        if vm.isRecording {
                            vm.pauseRecord()
                            return
                        }else {
                            vm.startRecord()
                        }
                        
                    } label: {
                        ZStack{
                            if vm.isRecording{
                                Image(systemName: "pause.circle.fill")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 70, height: 70)
                            } else {
                                Image(systemName: "record.circle.fill")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 70, height: 70)
                            }
                            
                        }
                    }
                    
                    Spacer()
                    
                    Button {
                        vm.setTestAudioFileFromBundle()
                    } label: {
                        Image(systemName: "square.and.arrow.down.fill")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 70, height: 70)
                    }

                    Spacer()

                }
                
                Button {
                    vm.stopRecord()
                } label: {
                    Text("녹음 저장 / StopAudioPlayer")
                        .foregroundColor(.white)
                        .font(.headline)
                        .padding()
                        .padding(.horizontal)
                        .background(Color.blue)
                        .cornerRadius(10)
                }
                .padding(.vertical)
                
                if let record = vm.record{
                    NavigationLink {
                        TestRecordAnalysisView(record: record)
                    } label: {
                        Text("분석하기")
                            .foregroundColor(.white)
                            .font(.headline)
                            .padding()
                            .padding(.horizontal)
                            .background(Color.green)
                            .cornerRadius(10)
                            .padding(.vertical)
                    }
                }else {
                    Text("분석 불가")
                        .padding()
                        .foregroundColor(.white)
                        .font(.headline)
                        .padding()
                        .padding(.horizontal)
                        .background(Color.red)
                        .cornerRadius(10)
                        .padding(.vertical)
                }

            }
            .navigationTitle("말발")
        }
        .alert("Error", isPresented: self.$alert){
            Button("Enable Access", role: .cancel){}
        }
        .onAppear{
            vm.prepareRecording { status in
                if !status{
                    self.alert.toggle()
                }
            }
        }
        .onDisappear{
            vm.stopRecord()
        }
    }
    
}


struct TestRecordAnalysisView: View {
    
    @StateObject var vm: AnalysisViewModel
    
    init(record: Record) {
        _vm = StateObject(wrappedValue: AnalysisViewModel(record: record))
    }
    
    var body: some View {
        VStack {
            
            
            Rectangle()
                .frame(height: 200)
                .foregroundColor(.blue)
                .padding()
            
            Slider(value: $vm.currentTime, in: 0...(vm.record.duration ?? 0), onEditingChanged: { editing in
                if !editing {
                    vm.seekAudio()
                }
            })
            
            HStack{
                Text("\(formatTime(vm.currentTime))")
                Spacer()
                Text("\(formatTime(vm.record.duration ?? 0))")
            }
            .padding(.horizontal)
            
            Text(String(vm.record.cpm ?? 0))
            
            Button(action: {
                vm.togglePlayer()
            }) {
                Image(systemName: vm.isPlaying ? "pause.circle.fill" : "play.circle.fill")
                    .resizable()
                    .frame(width: 75, height: 75)
            }
            
            HStack{
                Text("구간")
                Spacer()
                Text("속도")
            }
            
            .padding(.horizontal)
            List(0..<Int(vm.record.duration ?? 0) / 60, id: \.self) { minute in
                Button(action: {
                    vm.seekToMinute(minute)
                }) {
                    HStack{
                        Text("\(minute)-\(minute + 1)분")
                        Spacer()
                        Text("빠름")
                    }
                }
            }
            .listStyle(.plain)
            
            
        }
        .padding()
        .onAppear{
            vm.setupAudioPlayer()
            vm.analyzeRecord()
        }
        .onDisappear(perform: vm.stopAudioPlayer)
        .onReceive(Timer.publish(every: 0.1, on: .main, in: .common).autoconnect(), perform: { _ in
            vm.updatePlaybackTime()
        })
    }
    
    // 음원 재생 시간을 포맷하는 함수
    private func formatTime(_ time: Double) -> String {
        let minutes = Int(time) / 60
        let seconds = Int(time) % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }
    
}


struct RecordingView_Previews: PreviewProvider {
    static var previews: some View {
        TestRecordingView()
    }
}

