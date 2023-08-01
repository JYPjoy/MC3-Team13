//
//  HomeView.swift
//  MalBal
//
//  Created by Eric Lee on 2023/07/31.
//

import SwiftUI

struct HomeView: View {
    @StateObject var recordingVM = RecordingViewModel()
    
    var formattedTime: String {
        let minutes = Int(recordingVM.timeElapsed / 60)
        let seconds = Int(recordingVM.timeElapsed) % 60
        let milliseconds = Int((recordingVM.timeElapsed * 100).truncatingRemainder(dividingBy: 100))
        
        return String(format: "%02d:%02d.%02d", minutes, seconds, milliseconds)
    }

    
    var body: some View {
        NavigationView {
            
            ZStack {
                
                Color.main2.edgesIgnoringSafeArea(.all)
                
                VStack(spacing: 0) {
                    
                    //Navigation Title
                    homeHeaderView
                    .frame(width: .infinity, height: 68)
                    .padding(.bottom, 10)
                    
                    //녹음 버튼
                    recordButtonView
                    .padding(.bottom, 27)
                    
                    //control button
                    if recordingVM.isRecordingStage {
                        recordingControllerButtonView
                    } else {
                        importButtonView
                    }
                    Spacer()
                }
                
                if recordingVM.isRecordingStage {
                    recordCompleteButtonView
                } else {
                    goArchiveViewButtonView
                }
                
            }
            
        }
        .onAppear{
            recordingVM.prepareRecording { status in
                if !status {
                    // 권한 없는 경우 처리
                }
            }
        }
    }
    
    private var homeHeaderView: some View {
        HStack(alignment: .center) {
            Text("MalBal")
                .font(FontManager.shared.appleSDGothicNeo(.semibold, 36))
                .foregroundColor(Color(hex: "FFFFFF"))
                .padding(.leading, 24)
            Spacer()
        }
    }
    
    private var recordButtonView: some View {
        Button {
            if recordingVM.isRecording {
                recordingVM.pauseRecord()
            } else {
                recordingVM.startRecord()
            }
        } label: {
            if recordingVM.isRecording {
                recordingPauseView
            } else {
                recordingStartView
            }
        }
    }
    
    private var recordingStartView: some View {
        ZStack {
            Rectangle()
                .foregroundColor(.main4)
            
            ZStack {
                Circle()
                    .fill(
                        LinearGradient(
                            gradient: Gradient(colors: [Color(hex: "EEB560"), Color(hex: "EEB560").opacity(0.0)]),
                            startPoint: UnitPoint(x: 0.5, y: 0),
                            endPoint: UnitPoint(x: 0.5, y: 1)
                        )
                    )
                    .frame(width: 520, height: 520)
                
                Circle()
                    .fill(
                        LinearGradient(
                            gradient: Gradient(colors: [Color(hex: "EEB560"), Color(hex: "EEB560").opacity(0.0)]),
                            startPoint: UnitPoint(x: 0.5, y: 0),
                            endPoint: UnitPoint(x: 0.5, y: 1)
                        )
                    )
                    .frame(width: 416.63, height: 416.63)
                
                Circle()
                    .fill(
                        LinearGradient(
                            gradient: Gradient(colors: [Color(hex: "EEB560"), Color(hex: "EEB560").opacity(0.0)]),
                            startPoint: UnitPoint(x: 0.5, y: 0),
                            endPoint: UnitPoint(x: 0.5, y: 1)
                        )
                    )
                    .frame(width: 297.59, height: 297.59)
                
                Circle()
                    .fill(
                        LinearGradient(
                            gradient: Gradient(colors: [Color(hex: "EEB560"), Color(hex: "EEB560").opacity(0.0)]),
                            startPoint: UnitPoint(x: 0.5, y: 0),
                            endPoint: UnitPoint(x: 0.5, y: 1)
                        )
                    )
                    .frame(width: 213.01, height: 213.01)
                
            }
            .opacity(0.1)
            
            Circle()
                .foregroundColor(Color(hex: "E3E3E3"))
                .frame(width: 72, height: 72)
            Circle()
                .foregroundColor(.main5)
                .frame(width: 28, height: 28)
            
            if !recordingVM.isRecordingStage {
                Text("녹음하기")
                    .font(FontManager.shared.appleSDGothicNeo(.semibold, 20))
                    .foregroundColor(Color(hex: "FFFFFF"))
                    .offset(y: 59)
            }
            
        }
        .frame(width: 346, height: 256)
        .clipShape(RoundedRectangle(cornerRadius: 30))
    }
    
    private var recordingPauseView: some View {
        ZStack {
            
            ZStack {
                Rectangle()
                    .foregroundColor(.main1)
                
                RoundedRectangle(cornerRadius: 50)
                    .foregroundColor(.main1)
                    .frame(width: 298, height: 222)
                
                RoundedRectangle(cornerRadius: 50)
                    .foregroundColor(.main1)
                    .frame(width: 210, height: 156)
                
                RoundedRectangle(cornerRadius: 50)
                    .foregroundColor(.main1)
                    .frame(width: 140, height: 104)
            }
            .opacity(0.1)
            
            Circle()
                .foregroundColor(.main1)
                .frame(width: 72, height: 72)
            
            Image(systemName: "pause.fill")
                .font(FontManager.shared.appleSDGothicNeo(.semibold, 26))
                .frame(width: 24, height: 38)
                .foregroundColor(Color(hex: "FFFFFF"))
            
        }
        .frame(width: 346, height: 256)
        .clipShape(RoundedRectangle(cornerRadius: 30))
    }
    
    private var importButtonView: some View {
        
        Button {
            recordingVM.setTestAudioFileFromBundle()
        } label: {
            ZStack {
                RoundedRectangle(cornerRadius: 30)
                    .foregroundColor(.main4)
                    .frame(width: 346, height: 72)
                HStack(spacing: 5) {
                    Image(systemName: "tray.full.fill")
                        .font(FontManager.shared.appleSDGothicNeo(.semibold, 20))
                        .frame(width: 29, height: 22)
                        .foregroundColor(Color(hex: "FFFFFF"))
                    
                    Text("외부 파일 가져오기")
                        .foregroundColor(Color(hex: "FFFFFF"))
                        .font(FontManager.shared.appleSDGothicNeo(.semibold, 20))
                }
            }
        }

    }
    
    private var recordingControllerButtonView: some View {
        
        HStack(spacing: 10) {
            
            Button {
                recordingVM.deleteRecord()
            } label: {
                
                ZStack {
                    RoundedRectangle(cornerRadius: 30)
                        .foregroundColor(.main4)
                        .frame(width: 81, height: 72)
                    Image(systemName: "trash.fill")
                        .foregroundColor(Color(hex: "FFFFFF"))
                        .font(FontManager.shared.appleSDGothicNeo(.semibold, 20))
                }
                
            }
            
            ZStack {
                RoundedRectangle(cornerRadius: 30)
                    .foregroundColor(.main4)
                    .frame(width: 255, height: 72)
                Text(formattedTime)
                    .fontDesign(.monospaced)
                    .fontWeight(.semibold)
                    .foregroundColor(Color(hex: "FFFFFF"))

            }
            
        }
        
    }
    
    private var recordCompleteButtonView: some View {
        VStack(spacing: 0) {
            Spacer()
            NavigationLink {
                AnalysisView(record: recordingVM.record ?? Record(createdAt: Date()))
                    .environmentObject(self.recordingVM)
            } label: {
                ZStack {
                    RoundedRectangle(cornerRadius: 16)
                        .foregroundColor(.main5)
                        .frame(width: 345, height: 64)
                    Text("녹음 마치고 분석하기")
                        .font(FontManager.shared.appleSDGothicNeo(.semibold, 20))
                        .foregroundColor(Color(hex: "FFFFFF"))
                }
                .padding(.bottom, 55)
            }
        }
        .edgesIgnoringSafeArea(.bottom)
    }
    
    private var goArchiveViewButtonView: some View {
        VStack(spacing: 0) {
            Spacer()
            ZStack {
                RoundedRectangle(cornerRadius: 20)
                    .foregroundColor(.main3)
                    .frame(width: .infinity, height: 145)
                    .offset(y: 26)
                
                Text("연습 보관함")
                    .font(FontManager.shared.appleSDGothicNeo(.semibold, 20))
                    .foregroundColor(Color(hex: "FFFFFF"))
                    .offset(y: -5)
                
            }
            .clipShape(Rectangle())
        }
        .edgesIgnoringSafeArea(.bottom)
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
