//
//  AnalysisAudioView.swift
//  MalBal
//
//  Created by Eric Lee on 2023/07/29.
//

import SwiftUI

struct AnalysisAudioView: View {
    @EnvironmentObject var vm: AnalysisViewModel
    
    private let size: CGSize = CGSize(width: 345, height: 323)
    private let cornerRadius: CGFloat = 16
    
    var body: some View {
        ZStack {
            Rectangle()
                .foregroundColor(Color.main4)
            VStack {
                //Time Slider
                Slider(value: $vm.currentTime, in: 0...vm.totalTime) { editing in
                    if !editing {
                        vm.seekAudio()
                    }
                }
                .tint(Color(hex: "FFFFFF"))
                .frame(width: 297, height: 64)
                
                //Current Time Text
                Text("\(vm.formatCurrentTime())")
                    .font(FontManager.shared.appleSDGothicNeo(.bold, 28))
                    .foregroundColor(Color(hex: "FFFFFF"))
                
                //Control Buttons
                HStack(spacing: 63) {
                    
                    Button {
                        self.vm.goBackward()
                    } label: {
                        Image(systemName: "gobackward.10")
                            .font(FontManager.shared.appleSDGothicNeo(.bold, 24))
                            .frame(width: 29, height: 24)
                            .foregroundColor(Color(hex: "FFFFFF"))
                    }

                    Button {
                        vm.togglePlayer()
                    } label: {
                        ZStack {
                            Circle()
                                .foregroundColor(Color.main2)
                                .frame(width: 72, height: 72)
                            Image(systemName: vm.isPlaying ? "pause.fill" : "play.fill")
                                .font(FontManager.shared.appleSDGothicNeo(.bold, 24))
                                .frame(width: 29, height: 24)
                                .foregroundColor(Color(hex: "FFFFFF"))
                        }
                    }
                    
                    
                    Button {
                        self.vm.goForward()
                    } label: {
                        Image(systemName: "goforward.10")
                            .font(FontManager.shared.appleSDGothicNeo(.bold, 24))
                            .frame(width: 29, height: 24)
                            .foregroundColor(Color(hex: "FFFFFF"))
                    }

                }
                
            }
        }
        .frame(width: self.size.width, height: self.size.height)
        .clipShape(RoundedRectangle(cornerRadius: self.cornerRadius))
    }
}

struct AnalysisAudioView_Previews: PreviewProvider {
    static let testRecord = Record(createdAt: Date(),
                                   wpm: 100,
                                   detailWpms: [100, 200, 300, 400, 500])
    static let testEnvObject = AnalysisViewModel(record: testRecord)
    static var previews: some View {
        AnalysisAudioView()
            .environmentObject(testEnvObject)
    }
}
