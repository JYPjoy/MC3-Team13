//
//  TranscribingViewModel.swift
//  MalBal
//
//  Created by kibum on 2023/07/20.
//

import Foundation
import Speech

class TranscribingViewModel: ObservableObject {
    @Published var recognizedText = ""
    @Published var divisionedText = ""
    
    //한국어로 STT 구현한 Function (MC2 2중대6소대 Team STT 구현 함수 참고)
    func performKoreanSpeechToText(url: URL, completion: @escaping (Bool) -> Void) {
        guard let speechRecognizer = SFSpeechRecognizer(locale: Locale(identifier: "ko_KR")) else {
            print("Speech recognizer is not available for this locale!")
            completion(false)
            return
        }
        
        //SpeechRecognizer가 정상작동되지 않는다면?
        if !speechRecognizer.isAvailable {
            print("Speech recognizer is not available for this device!")
            completion(false)
            return
        }
        
        //SpeechRecognizer가 정상작동된다!
        SFSpeechRecognizer.requestAuthorization { authStatus in
            print(">> transcripts Waits")
            if (authStatus == .authorized) {
                let fileURL = url
                let request = SFSpeechURLRecognitionRequest(url: fileURL)
                print(">>>### URL: \(fileURL)")
                
                //Request에 맞게 Recognizer가 STT를 시작함.
                let task = speechRecognizer.recognitionTask(
                    with: request,
                    resultHandler: { (result, error) in
                        // MARK: 음성을 차례대로 정확하게 변환하기 위해
                        if result == nil {
                            self.recognizedText = "대화없음"
                            self.divisionedText += " 여긴 번역이 안됨 "
                            completion(true)
                        } else if (result?.isFinal)! {
                            //가장 bestTranscription을 뽑아서 설정한다.
                            if let res = result?.bestTranscription.formattedString {
                                self.recognizedText = res
                                self.divisionedText += res
                                //print(res)
                                completion(true)
                            }
                        }
                    })
            } else {
                print("Error: Speech-API not authorized!");
            }
        }
    }

    func splitM4AFileIntoOneMinuteSegments(inputFileURL: URL) {
        let asset = AVAsset(url: inputFileURL)
        let duration = CMTimeGetSeconds(asset.duration)
        let oneMinute = CMTime(seconds: 60, preferredTimescale: 1)
        var startTime = CMTime.zero

        for index in 0...Int(duration / 60) {
            let segmentTimeRange = CMTimeRange(start: startTime, duration: oneMinute)
            let exportSession = AVAssetExportSession(asset: asset, presetName: AVAssetExportPresetAppleM4A)

            let segmentOutputURL = URL(fileURLWithPath: NSTemporaryDirectory()).appendingPathComponent("segment_\(index).m4a")

            exportSession?.outputURL = segmentOutputURL
            exportSession?.outputFileType = .m4a
            exportSession?.timeRange = segmentTimeRange

            exportSession?.exportAsynchronously(completionHandler: {
                if let error = exportSession?.error {
                    print("Error exporting segment \(index): \(error.localizedDescription)")
                } else {
                    print("Segment \(index) exported successfully: \(segmentOutputURL)")
                }
            })

            startTime = CMTimeAdd(startTime, oneMinute)
        }
    }

    
    func removeFile(at url: URL) {
        do {
            try FileManager.default.removeItem(at: url)
            print("Temporary file removed: \(url.lastPathComponent)")
        } catch {
            print("Error removing temporary file: \(error.localizedDescription)")
        }
    }
    
    func performSTTM4AFiles() {
        do {
            let tempDirURL = URL(fileURLWithPath: NSTemporaryDirectory())
            let tempM4AFiles = try FileManager.default.contentsOfDirectory(at: tempDirURL, includingPropertiesForKeys: nil, options: .skipsHiddenFiles).filter { $0.pathExtension == "m4a" }

            for fileURL in tempM4AFiles {
                performKoreanSpeechToText(url: fileURL) {_ in
                    print("해치웠나?")
                }
            }
        } catch {
            print("Error some files: \(error.localizedDescription)")
        }
    }
    
    func removeAllTempM4AFiles() {
        do {
            let tempDirURL = URL(fileURLWithPath: NSTemporaryDirectory())
            let tempM4AFiles = try FileManager.default.contentsOfDirectory(at: tempDirURL, includingPropertiesForKeys: nil, options: .skipsHiddenFiles).filter { $0.pathExtension == "m4a" }

            for fileURL in tempM4AFiles {
                try FileManager.default.removeItem(at: fileURL)
                print("Removed temporary file: \(fileURL.lastPathComponent)")
            }
        } catch {
            print("Error removing temporary files: \(error.localizedDescription)")
        }
    }
}
