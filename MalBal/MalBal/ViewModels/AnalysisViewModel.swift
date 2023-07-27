//
//  AnalysisViewModel.swift
//  MalBal
//
//  Created by Eric Lee on 2023/07/27.
//

import Foundation
import SwiftUI
import AVKit
import Speech

class AnalysisViewModel: ObservableObject {
    
    @Published var record: Record
    
    private var audioPlayer: AVAudioPlayer?
    @Published var isPlaying = false
    @Published var totalTime: Double = 0
    @Published var currentTime: Double = 0
    
    @Published var isAnalysisComplete: Bool = false
    private var transcripts: String = ""
    
    init(record: Record) {
        self.record = record
    }
    
    /// 녹음 파일 분석 : STT & set CPM
    func analyzeRecord() {
        self.transcribe(url: record.fileURL) { success in
            if success {
                self.isAnalysisComplete = true
                self.setRecordWPM()
                print(self.transcripts)
            }
        }
    }
    
    /// WPM 계산 함수
    private func setRecordWPM() {
        let wordCount = Double(transcripts.split(separator: " ").count)
        
        guard self.totalTime > 0 else {
            self.record.wpm = -1
            return
        }
        
        let wps = wordCount/self.totalTime
        self.record.wpm = Int(wps * 60)
    }
    
    
    /// CPM 계산
    private func setRecordCPM() {
        
        if totalTime != 0 {
            let length = Double(calculateLength(of: transcripts))
            record.wpm = Int(length / totalTime * 60)
        } else {
            print("Error : Record Duration 0")
        }
        
    }
    
    
    /// 글자수 계산 함수
    private func calculateLength(of text: String?) -> Int {
        guard let trimmedText = text?.trimmingCharacters(in: .whitespacesAndNewlines) else {
            return 0
        }
        
        // 온점, 느낌표, 쉼표 제거
        let excludedCharacters = CharacterSet(charactersIn: ".!,")
        let filteredText = trimmedText.components(separatedBy: excludedCharacters).joined(separator: "")
        
        return filteredText.count
    }
    
    /// STT 함수
    private func transcribe(url: URL, completion: @escaping (Bool) -> Void) {
        guard let speechRecognizer = SFSpeechRecognizer(locale: Locale(identifier: "ko_KR")) else {
            print("Speech recognizer is not available for this locale!")
            completion(false)
            return
        }

        if !speechRecognizer.isAvailable {
            print("Speech recognizer is not available for this device!")
            completion(false)
            return
        }

        SFSpeechRecognizer.requestAuthorization { authStatus in
            print(">> transcripts Waits")
            if (authStatus == .authorized) {
                let fileURL = url
                let request = SFSpeechURLRecognitionRequest(url: fileURL)
                print(">>>### URL: \(fileURL)")
                
                let task = speechRecognizer.recognitionTask(
                    with: request,
                    resultHandler: { (result, error) in
                        // MARK: 음성을 차례대로 정확하게 변환하기 위해
                        if result == nil {
                            self.transcripts.append("(대화 없음)")
                            completion(true)
                        } else if (result?.isFinal)! {
                            if let res = result?.bestTranscription.formattedString {
                                self.transcripts.append(res)
                                print(res)
                                completion(true)
                            }
                        }
                    })
            } else {
                print("Error: Speech-API not authorized!");
            }
        }
    }
    
    // 음원 재생을 토글하는 함수
    func togglePlayer() {
        if isPlaying {
            audioPlayer?.pause()
        } else {
            audioPlayer?.play()
        }
        isPlaying.toggle()
    }
    
    /// 음원 파일을 재생 준비하는 함수
    /// set audioPlayer & record.duration
    func setupAudioPlayer() {
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: record.fileURL)
            self.totalTime = audioPlayer?.duration ?? 0
        } catch {
            print("Error: Set up Audio Player")
        }
    }
    
    // 음원 재생 시간을 조절하는 함수
    func seekAudio() {
        audioPlayer?.currentTime = currentTime
        if isPlaying {
            audioPlayer?.play()
        }
    }
    
    // 해당 분으로 음원 재생 위치를 이동하는 함수
    func seekToMinute(_ minute: Int) {
        let targetTime = Double(minute * 60)
        currentTime = targetTime
        audioPlayer?.currentTime = targetTime
        if isPlaying {
            audioPlayer?.play()
        }
    }
    
    // 음원 재생 시간을 업데이트하는 함수
    func updatePlaybackTime() {
        if isPlaying {
            currentTime = audioPlayer?.currentTime ?? 0
            if currentTime >= totalTime {
                // 음원 재생이 끝났을 때, 정지하고 초기화합니다.
                audioPlayer?.stop()
                audioPlayer?.currentTime = 0
                isPlaying = false
            }
        }
    }
    
    // 음원 재생기 정리 함수
    func stopAudioPlayer() {
        audioPlayer?.stop()
        audioPlayer = nil
    }
    
}
