//
//  SoundPlayer.swift
//  HotdogUp
//
//  Created by Cathy Oun on 8/5/17.
//  Copyright © 2017 Cathy Oun. All rights reserved.
//

import AVFoundation

class SoundPlayer {
    static var players = [AVAudioPlayer]()
    static var backgroundPlayer = AVAudioPlayer()
    
    class func playBackgroundSound() {
        if !AVAudioSession.sharedInstance().isOtherAudioPlaying {
            let soundFileUrl = Bundle.main.url(forResource: "backgroundSound", withExtension: "mp3")
            let availablePlayers = players.filter({ (player) -> Bool in
                return player.isPlaying == false && player.url == soundFileUrl
            })
        }
    }
}
