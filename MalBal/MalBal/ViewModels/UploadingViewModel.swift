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
    @Published var outputURL: URL?
    
    //앱 내 임시디렉토리 안에 Segment된 파일들을 다 지워줌
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
    func extractAudio(from videoURL: URL) -> URL {
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
        return outputURL
    }
    
}
