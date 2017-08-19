//
//  Hotdog.swift
//  HotdogUp
//
//  Created by Cathy Oun on 8/19/17.
//  Copyright © 2017 Cathy Oun. All rights reserved.
//

import UIKit
import SpriteKit

class Hotdog: SKSpriteNode {
    
    enum HotdogType: Int {
        case mrjj = 0
        case jane = 1
        
        var name : String {
            switch self {
                case .mrjj: return "mrjj";
                case .jane: return "jane";
            }
        }
    }
    var actions: [SKTexture] = []
    private var hotdogType = HotdogType.mrjj
    var hotdogTexture: SKTexture?
    init(hotdogType: HotdogType) {
        
        hotdogTexture = SKTexture(imageNamed: "\(hotdogType.name)_11")
        super.init(texture: hotdogTexture, color: UIColor.clear, size: (hotdogTexture?.size())!)
        self.hotdogType = hotdogType
        createMovement()
    }
    private func createMovement() {
        for i in 1...10 {
            actions.append(SKTexture(imageNamed: "\(hotdogType.name)_\(i)"))
        }
//        SKAction.animate(with: [hotdogTexture1, hotdogTexture2, hotdogTexture3, hotdogTexture4, hotdogTexture5, hotdogTexture6, hotdogTexture7, hotdogTexture8, hotdogTexture9, hotdogTexture10], timePerFrame: 0.2)
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
