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
}
