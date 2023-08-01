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
    
    init(record: Record) {
        _vm = StateObject(wrappedValue: AnalysisViewModel(record: record))
    }
    
    var body: some View {
        ZStack{
            Color.main2.edgesIgnoringSafeArea(.all)
            
            ScrollView {
                VStack(spacing: 8) {
                    AnalysisCardView()
                    AnalysisAudioView()
                    DetailWpmsListView()
                }
            }
            .scrollIndicators(.hidden)
        }
        .environmentObject(self.vm)
        .onAppear{
            recordingVM.stopRecord()
            vm.clearSplitFiles()
            vm.setupAudioPlayer()
            vm.setDetailWPMs()
        }
        .onDisappear(perform: vm.stopAudioPlayer)
        .onReceive(Timer.publish(every: 0.1, on: .main, in: .common).autoconnect(), perform: { _ in
            vm.updatePlaybackTime()
        })
        .onChange(of: vm.isAnalysisComplete) { newValue in
            if newValue {
                vm.setRecordWPM()
                print(vm.transcripts)
            }
        }
    }
}

struct AnalysisView_Previews: PreviewProvider {
    static var previews: some View {
        AnalysisView(record: Record(createdAt: Date()))
            .environmentObject(RecordingViewModel())
    }
}


