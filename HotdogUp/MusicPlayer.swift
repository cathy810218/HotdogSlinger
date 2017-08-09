//
//  MusicPlayer.swift
//  HotdogUp
//
//  Created by Cathy Oun on 8/7/17.
//  Copyright © 2017 Cathy Oun. All rights reserved.
//

import AVFoundation

class MusicPlayer {
    static var player = AVAudioPlayer()
    
    class func playBackgroundMusic() {
        let filename = "Brother_Jack.mp3"
        if !AVAudioSession.sharedInstance().isOtherAudioPlaying {
            let url = Bundle.main.url(forResource: filename, withExtension: nil)
            if (url == nil) {
                print("Could not find file: \(filename)")
                return
            }
            do {
                player = try
                    AVAudioPlayer(contentsOf: url!)
                player.numberOfLoops = -1
                player.prepareToPlay()
//                player.volume = musicVolume
                player.play()
            } catch {
                
            }
        }
    }
}
