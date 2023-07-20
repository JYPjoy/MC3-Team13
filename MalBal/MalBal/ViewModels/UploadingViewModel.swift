//
//  SpeechToText.swift
//  MalBal
//
//  Created by kibum on 2023/07/19.
//

import SwiftUI
import AVFoundation
import AVKit
import Speech
import MobileCoreServices


class UplodaingViewModel: ObservableObject {
    @Published var recognizedText : String = ""
    
    func performKoreanSpeechToText(url: URL, completion: @escaping (Bool) -> Void) {
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
                            self.recognizedText = "대화없음"
                            completion(true)
                        } else if (result?.isFinal)! {
                            if let res = result?.bestTranscription.formattedString {
                                self.recognizedText = res
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
    
    func deleteM4AFilesInDocumentsDirectory() {
        let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first
        if let documentsURL = documentsDirectory {
            do {
                let fileURLs = try FileManager.default.contentsOfDirectory(at: documentsURL, includingPropertiesForKeys: nil)
                let m4aFiles = fileURLs.filter { $0.pathExtension == "m4a" }
                
                for fileURL in m4aFiles {
                    try FileManager.default.removeItem(at: fileURL)
                    print("Deleted file: \(fileURL.lastPathComponent)")
                }
            } catch {
                print("Error deleting files in Documents Directory: \(error.localizedDescription)")
            }
        }
    }
    
    func playAudio() {
        let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first
        if let documentsURL = documentsDirectory {
            do {
                let fileURLs = try FileManager.default.contentsOfDirectory(at: documentsURL, includingPropertiesForKeys: nil)
                if let firstFileURL = fileURLs.first {
                    // 첫 번째 파일 URL에 접근 가능
                    // 이곳에서 오디오를 재생할 수 있습니다.
                    let player = AVPlayer(url: firstFileURL)
                    let playerViewController = AVPlayerViewController()
                    playerViewController.player = player
                    
                    // AVPlayerViewController를 사용하여 오디오 재생 화면을 표시합니다.
                    UIApplication.shared.windows.first?.rootViewController?.present(playerViewController, animated: true) {
                        player.isMuted = false
                        player.play()
                    }
                } else {
                    print("Documents Directory is empty.")
                }
            } catch {
                print("Error reading contents of Documents Directory: \(error.localizedDescription)")
            }
        }
    }
    
    func extractAudio(from videoURL: URL) {
        let asset = AVAsset(url: videoURL)
        
        let exportSession = AVAssetExportSession(asset: asset, presetName: AVAssetExportPresetAppleM4A)
        exportSession?.outputFileType = .m4a
        
        let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let outputURL = documentsDirectory.appendingPathComponent("e1.m4a")
        
        exportSession?.outputURL = outputURL
        
        exportSession?.exportAsynchronously(completionHandler: {
            switch exportSession?.status {
            case .completed:
                print("Audio extraction completed.")
                print(outputURL)
                // You can use the extracted audio file here.
                
            case .failed:
                if let error = exportSession?.error {
                    print("Audio extraction failed with error: \(error.localizedDescription)")
                } else {
                    print("Audio extraction failed.")
                }
                
            default:
                break
            }
        })
    }
}
