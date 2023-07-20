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
    //내부 변수로 번역된 문장 생성
    @Published var recognizedText : String = ""
    
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
                            completion(true)
                        } else if (result?.isFinal)! {
                            //가장 bestTranscription을 뽑아서 설정한다.
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
    
    //앱 내 Documents 폴더 안에 있는 M4A Files들을 지움
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
    
    //영상에서 추출한 오디오가 정상 작동되는지 테스트해보는 함수
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
    
    //영상에서 오디오를 추출하는 함수
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
