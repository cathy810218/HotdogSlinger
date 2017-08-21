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
        case han = 2
        
        var name : String {
            switch self {
            case .mrjj: return "mrjj";
            case .jane: return "jane";
            case .han: return "han";
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
        self.physicsBody = SKPhysicsBody(rectangleOf: self.size)
        self.physicsBody?.mass = 0.2
        
        if UIDevice.current.userInterfaceIdiom == .pad {
            self.physicsBody?.mass = 0.24
        }
        self.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        self.physicsBody?.affectedByGravity = true
        self.physicsBody?.allowsRotation = false
        self.physicsBody?.restitution = 0.0
        createMovement()
    }
    private func createMovement() {
        for i in 1...10 {
            actions.append(SKTexture(imageNamed: "\(hotdogType.name)_\(i)"))
        }
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
