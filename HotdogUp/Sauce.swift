//
//  Sauce.swift
//  HotdogUp
//
//  Created by Cathy Oun on 8/23/17.
//  Copyright © 2017 Cathy Oun. All rights reserved.
//

import UIKit
import SpriteKit

class Sauce: SKSpriteNode {
    var tag = 0
    init(type: Station.StationType) {
        let sauceTexture = SKTexture(imageNamed: "\(type.name)_short")
        super.init(texture: sauceTexture, color: .clear, size: sauceTexture.size())

        self.physicsBody = SKPhysicsBody(texture: sauceTexture, size: self.size)
        self.physicsBody?.affectedByGravity = false
        self.physicsBody?.allowsRotation = false
        self.physicsBody?.isDynamic = false
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

