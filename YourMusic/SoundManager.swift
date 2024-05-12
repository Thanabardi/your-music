//
//  SoundManager.swift
//  YourMusic
//
//  Created by Thanabardi on 5/5/2567 BE.
//

import Foundation
import AVFoundation

class SoundManager : ObservableObject {
    var audioPlayer: AVPlayer?
    var isSetupState: Bool = false
    
    func setupSession(_ isSetup: Bool) {
        if isSetup != isSetupState {
            do {
                try AVAudioSession.sharedInstance().setCategory(.playback)
                print("AVAudioSession Category Playback OK")
                do {
                    try AVAudioSession.sharedInstance().setActive(true)
                    print("AVAudioSession is Active")
                } catch let error as NSError {
                    print(error.localizedDescription)
                }
            } catch let error as NSError {
                print(error.localizedDescription)
            }
            do {
                isSetupState = isSetup
            }
        }
    }

    func setupPlayer(sound: String) {
        if let url = URL(string: sound) {
            setupSession(true)
            audioPlayer = AVPlayer(url: url)
        }
    }
    
    func deletePlayer() {
//        setupSession(false)
        audioPlayer = nil
    }
}
