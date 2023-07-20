//
//  RecordingViewModel.swift
//  MalBal
//
//  Created by kibum on 2023/07/20.
//

import Foundation
import AVFoundation

class RecordingViewModel: ObservableObject {
    @Published var audioRecorder: AVAudioRecorder!
    @Published var audioPlayer: AVAudioPlayer!
    @Published var isRecording: Bool = false
    @Published var audioURL: URL?
    
    func startRecording() {
        let audioSession = AVAudioSession.sharedInstance()
        do {
            try audioSession.setCategory(.record, mode: .default)
            try audioSession.setActive(true)

            let documentsPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
            let audioFilename = documentsPath.appendingPathComponent("recording.m4a")

            let settings = [
                AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
                AVSampleRateKey: 44100.0,
                AVNumberOfChannelsKey: 2,
                AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue
            ] as [String : Any]

            audioRecorder = try AVAudioRecorder(url: audioFilename, settings: settings)
            audioRecorder.record()
            isRecording = true
            audioURL = nil
        } catch {
            print("Error starting recording: \(error.localizedDescription)")
        }
    }

    func stopRecording() {
        audioRecorder.stop()
        let audioSession = AVAudioSession.sharedInstance()
        do {
            try audioSession.setActive(false)
            isRecording = false
            audioURL = audioRecorder.url
            audioRecorder = nil
        } catch {
            print("Error stopping recording: \(error.localizedDescription)")
        }
    }

    func prepareAudioPlayer(url: URL) {
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: url)
        } catch {
            print("Error preparing audio player: \(error.localizedDescription)")
        }
    }

    func isPlaying() -> Bool {
        return audioPlayer?.isPlaying ?? false
    }
}
