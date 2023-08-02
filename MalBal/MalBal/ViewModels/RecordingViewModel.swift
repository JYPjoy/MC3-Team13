//
//  RecordingViewModel.swift
//  MalBal
//
//  Created by kibum on 2023/07/20.
//

import Foundation
import SwiftUI
import AVKit

class RecordingViewModel: ObservableObject {
    
    @Published var record: Record?
    @Published var isRecording: Bool = false
    @Published var isRecordingStage: Bool = false
    
    private var session: AVAudioSession?
    private var audioRecorder: AVAudioRecorder?
    
    @Published var timeElapsed: TimeInterval = 0
    private var timer: Timer?
    
    let recordedFileURL: URL = {
        let url = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        return url.appendingPathComponent("MalBal.m4a")
    }()
    
    /// 권한 요청 함수 : 권한 여부 반환
    func prepareRecording(completion: @escaping (Bool) -> Void) {
        
        do{
            self.session = AVAudioSession.sharedInstance()
            try self.session?.setCategory(.playAndRecord)
            
            // 녹음 권한 요청
            self.session?.requestRecordPermission { (status) in
                completion(status)
            }
        }
        catch{
            print("Error: Preparing Recording- \(error.localizedDescription)")
        }
    }
    
    /// 녹음 시작
    func startRecord() {
        
        if record == nil {
            
            record = Record(createdAt: Date())
            isRecordingStage = true
            
            let settings: [String : Any] = [
                
                AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
                AVSampleRateKey: 44100.0,
                AVNumberOfChannelsKey: 2,
                AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue
                
            ]
            
            do{
                self.audioRecorder = try AVAudioRecorder(url: recordedFileURL, settings: settings)
                self.audioRecorder?.record()
                isRecording = true
                
            }catch {
                print(error.localizedDescription)
            }
            
        } else {
            resumeRecord()
        }
        
        self.timerStart()
        
    }
    
    /// 녹음 일시정지
    func pauseRecord() {
        self.audioRecorder?.pause()
        isRecording = false
        self.timerPause()
    }
    
    /// 녹음 끝마치기
    func stopRecord() {
        self.audioRecorder?.stop()
        isRecording = false
        saveRecord()
        self.timerReset()
    }
    
    /// 녹음 삭제
    func deleteRecord() {
        
        do {
            if FileManager.default.fileExists(atPath: recordedFileURL.path) {
                try FileManager.default.removeItem(at: recordedFileURL)
                self.audioRecorder = nil
                self.isRecording = false
                isRecordingStage = false
                self.record = nil
            }
        } catch {
            print("Error: Deleting file - \(error.localizedDescription)")
        }
        
    }
    
    func saveRecord() {
        self.record = Record(createdAt: Date())
    }
    
    private func timerStart() {
        timer = Timer.scheduledTimer(withTimeInterval: 0.01, repeats: true) { _ in
            self.timeElapsed += 0.01
        }
    }
    
    private func timerPause() {
        timer?.invalidate()
        timer = nil
    }
    
    private func timerReset() {
        timer?.invalidate()
        timer = nil
        timeElapsed = 0
    }
    
    /// 녹음 재개 (pause 후에 녹음하는 경우)
    private func resumeRecord() {
        self.audioRecorder?.record()
        isRecording = true
    }
    
    /// 번들에 있는 m4a파일을 recordedFileURL에 저장하는 함수
    /// for testing
    func setTestAudioFileFromBundle() {
        self.stopRecord()
        self.deleteRecord()
        self.record = Record(fileURL: recordedFileURL, createdAt: Date())
        let bundle = Bundle.main
        //Test m4a파일 변경하는 부분입니다 M4A_SampleFile
        guard let bundleAudioURL = bundle.url(forResource: "M4A_SampleFile", withExtension: "m4a") else {
            print("Error: Bundle audio file not found.")
            return
        }
        
        do {
            if FileManager.default.fileExists(atPath: recordedFileURL.path) {
                try FileManager.default.removeItem(at: recordedFileURL)
            }
            try FileManager.default.copyItem(at: bundleAudioURL, to: recordedFileURL)
            saveRecord()
        } catch {
            print("Error: Copying test audio file - \(error.localizedDescription)")
        }
        
        self.isRecordingStage = true
    }
    
}

