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
    var transcripts: [String] = []
    private var splitURLs: [URL] = []
    
    init(record: Record) {
        self.record = record
    }
    
    //MARK: - 음원 재생
    
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
        } else {
            audioPlayer?.currentTime = currentTime
        }
    }
    
    // 음원 재생기 정리 함수
    func stopAudioPlayer() {
        audioPlayer?.stop()
        audioPlayer = nil
    }
    
    /// 10초  goBackward
    func goBackward() {
        guard let player = audioPlayer else { return }
        currentTime = player.currentTime - 10.0
        if currentTime < 0 {
            player.currentTime = 0
        } else {
            player.currentTime = currentTime
        }
        
        if isPlaying {
            player.play()
        }
    }
    
    /// 10초 Forward
    func goForward() {
        guard let player = audioPlayer else { return }
        currentTime = player.currentTime + 10.0
        if currentTime > totalTime {
            player.currentTime = totalTime
        } else {
            player.currentTime = currentTime
        }
        
        if isPlaying {
            player.play()
        }
    }
    
    
    //MARK: - Wpm 연산
    /// 전체 WPM 계산 함수
    func setRecordWPM() {
        var words: Int = 0
        
        for detailWpm in record.detailWpms {
            words += detailWpm
        }
        
        let wps = Double(words)/self.totalTime
        self.record.wpm = Int(wps * 60)
    }
    
    //MARK: - detailWpms 연산
    
    /// 음성파일을 1분단위로 나누어서 transcripts, detailWpms 초기화 함수
    func setDetailWPMs() {
        
        var idx = 0
        splitURLs = splitAudioFileIntoOneMinuteSegments(audioFileURL: record.fileURL)
        let numberOfURLs = splitURLs.count
        
        loopTransURL(urls: splitURLs, idx: idx, numbersOfURLs: numberOfURLs)
    }
    
    /// 음성파일배열 순회transcribe 
    private func loopTransURL(urls: [URL], idx: Int, numbersOfURLs: Int) {
        self.transcribe(url: urls[idx]) { success in
            if success,
               idx < numbersOfURLs - 1 {
                self.loopTransURL(urls: urls, idx: idx+1, numbersOfURLs: numbersOfURLs)
            } else {
                print("Transcribing failed for \(urls[idx])")
                self.isAnalysisComplete = true
            }
        }
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
//                            self.transcripts.append("(대화 없음)")
                            completion(true)
                            print("@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@")
                            print("대화없음")
                            self.addDetailWpms(textPerMinute: " ")
                            print("@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@")
                            print(self.record.detailWpms)
                            print("@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@")
                            
                        } else if (result?.isFinal)! {
                            if let res = result?.bestTranscription.formattedString {
                                // detail Wpms 추가
                                print(">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>")
                                print("\(res)")
                                self.addDetailWpms(textPerMinute: res)
                                print(">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>")
                                print(self.record.detailWpms)
                                print(">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>")
//                              결과 Transcripts 추가 -- 아니 이거 진짜 왜 값이 이상해지는 건지 도당체 모르겠음
//                                self.transcripts.append(res)
//                                print(">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>")
//                                print(self.transcripts)
//                                print(">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>")
                                completion(true)
                            }
                        }
                    })
            } else {
                print("Error: Speech-API not authorized!");
            }
        }
    }
    
    ///  음성 파일 자르기
    func splitAudioFileIntoOneMinuteSegments(audioFileURL: URL) -> [URL] {
        var splitURLs: [URL] = []
        
        // 오디오 파일 로드
        let asset = AVURLAsset(url: audioFileURL)
        
        // 오디오 파일의 총 재생 시간을 초 단위로 가져오기
        let totalDuration = CMTimeGetSeconds(asset.duration)
        
        // 파일을 저장할 디렉토리를 가져오기
        let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        
        // 원본 파일 이름을 기반으로 세그먼트용 파일 이름을 만들기
        let originalFileName = audioFileURL.lastPathComponent
        let fileNamePrefix = originalFileName.prefix(upTo: originalFileName.index(originalFileName.endIndex, offsetBy: -4))
        
        // 각 세그먼트의 길이를 초 단위로 정의 (1분)
        let segmentDuration: Double = 60.0
        
        // 필요한 세그먼트의 개수를 계산
        let numberOfSegments = Int(ceil(totalDuration / segmentDuration))
        
        // 세그먼트 생성 및 내보내기
        for segmentIndex in 0..<numberOfSegments {
            // 현재 세그먼트의 시간 범위를 계산
            let startTime = CMTime(seconds: Double(segmentIndex) * segmentDuration, preferredTimescale: 1)
            var endTime = CMTime(seconds: Double(segmentIndex + 1) * segmentDuration, preferredTimescale: 1)
            
            // 계산된 종료 시간이 총 재생 시간을 초과하는지 확인
            if CMTimeCompare(endTime, asset.duration) == 1 {
                endTime = asset.duration
            }
            
            // 현재 세그먼트에 대한 내보내기 세션을 생성합니다
            let exportSession = AVAssetExportSession(asset: asset, presetName: AVAssetExportPresetAppleM4A)
            let outputURL = documentsDirectory.appendingPathComponent("\(fileNamePrefix)_\(segmentIndex).m4a")
            exportSession?.outputURL = outputURL
            exportSession?.outputFileType = .m4a
            exportSession?.timeRange = CMTimeRangeFromTimeToTime(start: startTime, end: endTime)
            
            // 내보내기 수행
            let exportSemaphore = DispatchSemaphore(value: 0)
            exportSession?.exportAsynchronously(completionHandler: {
                exportSemaphore.signal()
            })
            exportSemaphore.wait()
            
            // 내보낸 세그먼트의 URL을 배열에 추가합니다
            splitURLs.append(outputURL)
        }
        
        return splitURLs
    }
    
    private func addDetailWpms(textPerMinute: String) {
        self.record.detailWpms.append(calculateWPM(textPerMinute: textPerMinute))
    }
    
    private func calculateWPM(textPerMinute: String) -> Int {
        let wordCount = textPerMinute.split(separator: " ").count
        return wordCount
    }
    
    private func combineTranscripts(_ strings: [String], separator: String = "") -> String {
        return strings.joined(separator: separator)
    }
    
    func clearSplitFiles() {
        let fileManager = FileManager.default

        guard let documentsDirectoryURL = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first else {
            print("Error: Unable to access Document Directory.")
            return
        }

        // Document Directory에 있는 모든 파일 목록 가져오기
        do {
            let directoryContents = try fileManager.contentsOfDirectory(at: documentsDirectoryURL, includingPropertiesForKeys: nil, options: [])

            //MalBal.m4a 제외 하고는 모두 삭제
            let malBalFileName = "MalBal.m4a"
            for fileURL in directoryContents {
                if fileURL.lastPathComponent != malBalFileName {
                    do {
                        try fileManager.removeItem(at: fileURL)
                        print("Deleted file at: \(fileURL)")
                    } catch {
                        print("Error: Deleting file at - \(fileURL), \(error.localizedDescription)")
                    }
                }
            }

            print("Completed: Delete All Files Except MalBal.m4a")
        } catch {
            print("Error: Unable to access contents of Document Directory - \(error.localizedDescription)")
        }
    }
    
    //MARK: - AnalysisView UI 관련 메소드
    
    func wpmText() -> String {
        switch record.wpm {
        case ..<80:
            return "너무 느려요"
        case 80..<90:
            return "조금 느려요"
        case 90..<110:
            return "아주 좋아요!"
        case 110..<130:
            return "조금 빨라요"
        case 130...:
            return "너무 빨라요"
        default:
            return "오류"
        }
    }
    
    func wpmImageName() -> String {
        switch record.wpm {
        case ..<80:
            return "ic_speed_1"
        case 80..<90:
            return "ic_speed_2"
        case 90..<110:
            return "ic_speed_3"
        case 110..<130:
            return "ic_speed_4"
        case 130...:
            return "ic_speed_5"
        default:
            return "오류"
        }
    }
    
    func formatTimeLong () -> String {
        let minutes = Int(self.totalTime) / 60
        let seconds = Int(self.totalTime) % 60
        let milliseconds = Int((self.totalTime.truncatingRemainder(dividingBy: 1)) * 100)
        return String(format: "%02d:%02d.%02d", minutes, seconds, milliseconds)
    }
    
    func formatTimeShort () -> String {
        let minutes = Int(self.totalTime) / 60
        let seconds = Int(self.totalTime) % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }
    
    func formatCurrentTime() -> String {
        let minutes = Int(self.currentTime) / 60
        let seconds = Int(self.currentTime) % 60
        let milliseconds = Int((self.currentTime.truncatingRemainder(dividingBy: 1)) * 100)
        return String(format: "%02d:%02d.%02d", minutes, seconds, milliseconds)
    }
    
    func detailWpmImageName(wpm: Int) -> String {
        switch wpm {
        case ..<80:
            return "ic_speed_1"
        case 80..<90:
            return "ic_speed_2"
        case 90..<110:
            return "ic_speed_3"
        case 110..<130:
            return "ic_speed_4"
        case 130...:
            return "ic_speed_5"
        default:
            return "오류"
        }
    }
    
    func cellTimeText(index: Int) -> String {
        let startTime = index * 1
        let endTime = (index + 1) * 1
        return "\(String(format: "%02d", startTime)):00~\(String(format: "%02d", endTime)):00"
    }
    
    func cellSpeedText(wpm: Int) -> String {
        switch wpm {
        case ..<80:
            return "너무 느려요"
        case 80..<90:
            return "조금 느려요"
        case 90..<110:
            return "아주 좋아요!"
        case 110..<130:
            return "조금 빨라요"
        case 130...:
            return "너무 빨라요"
        default:
            return "오류"
        }
    }
    
    func testSTTScript() {
//        self.transcribe(url: record.fileURL) { success in
//            <#code#>
//        }
        guard let speechRecognizer = SFSpeechRecognizer(locale: Locale(identifier: "ko_KR")) else {
            print("Speech recognizer is not available for this locale!")
            return
        }

        if !speechRecognizer.isAvailable {
            print("Speech recognizer is not available for this device!")
            return
        }

        SFSpeechRecognizer.requestAuthorization { authStatus in
            print(">> transcripts Waits")
            if (authStatus == .authorized) {
                let fileURL = self.record.fileURL
                let request = SFSpeechURLRecognitionRequest(url: fileURL)
                print(">>>### URL: \(fileURL)")
                
                let task = speechRecognizer.recognitionTask(
                    with: request,
                    resultHandler: { (result, error) in
                        if result == nil {
                            print("대화없음")
                        } else if (result?.isFinal)! {
                            if let res = result?.bestTranscription.formattedString {
                                print(">>>###***>>>>>>###***>>>>>>###***>>>FULL SCRIPT")
                                print(">>>###***>>>\(res)")
                                print(">>>###***>>>>>>###***>>>>>>###***>>>FULL SCRIPT")
                                print(self.transcripts)
                            }
                        }
                    })
            } else {
                print("Error: Speech-API not authorized!");
            }
        }
        
    }
    
}
