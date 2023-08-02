//
//  AnalysisView.swift
//  MalBal
//
//  Created by Eric Lee on 2023/07/28.
//

import SwiftUI

struct AnalysisView: View {
    @StateObject var vm: AnalysisViewModel
    @EnvironmentObject var recordingVM: RecordingViewModel
    @Environment(\.presentationMode) var presentationMode
    
    init(record: Record) {
        _vm = StateObject(wrappedValue: AnalysisViewModel(record: record))
    }
    
    var body: some View {
        ZStack{
            Color.main2.edgesIgnoringSafeArea(.all)
            
            VStack(spacing: 0) {
                NavToolBar(navBarTitle: "분석결과", backButtonActive: false)
                ScrollView {
                    VStack(spacing: 8) {
                        AnalysisCardView()
                        AnalysisAudioView()
                        DetailWpmsListView()
                        saveButton
                    }
                }
                .scrollIndicators(.hidden)
            }
        }
        .navigationBarHidden(true)
        .environmentObject(self.vm)
        .onAppear{
            recordingVM.stopRecord()
            vm.clearSplitFiles()
            vm.setupAudioPlayer()
            vm.setDetailWPMs()
//            vm.testSTTScript()
        }
        .onDisappear(perform: vm.stopAudioPlayer)
        .onReceive(Timer.publish(every: 0.1, on: .main, in: .common).autoconnect(), perform: { _ in
            vm.updatePlaybackTime()
        })
        .onChange(of: vm.isAnalysisComplete) { newValue in
            if newValue {
                vm.setRecordWPM()
                for transcript in vm.transcripts {
                    print(">>>>>>>>>>>>>>>>>>>>>>>>>>>")
                    print(transcript)
                }
                print(String(vm.transcripts.count))
            }
        }
    }
    
    private var saveButton: some View {
        Button {
            //TODO: 저장 로직 추가
            //self.vm.record 모델 접근 가능
            presentationMode.wrappedValue.dismiss()
        } label: {
            ZStack {
                RoundedRectangle(cornerRadius: 16)
                    .foregroundColor(.main3)
                Text("보관함에 저장")
                    .font(FontManager.shared.appleSDGothicNeo(.bold, 20))
                    .foregroundColor(Color.white)
            }
        }
        .frame(width: 345, height: 64)
    }
    
}

struct AnalysisView_Previews: PreviewProvider {
    static var previews: some View {
        AnalysisView(record: Record(createdAt: Date()))
            .environmentObject(RecordingViewModel())
    }
}


