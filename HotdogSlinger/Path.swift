//
//  Path.swift
//  HotdogSlinger
//
//  Created by Cathy Oun on 8/2/17.
//  Copyright © 2017 Cathy Oun. All rights reserved.
//

import UIKit
import SpriteKit
class Path: SKSpriteNode {
    
    init(position: CGPoint) {
        let texture = SKTexture(imageNamed: "pickle")
        super.init(texture: texture, color: UIColor.clear, size: texture.size())
        self.position = position
        self.physicsBody = SKPhysicsBody(texture: texture, size: self.size)
        self.physicsBody?.allowsRotation = false
        self.physicsBody?.affectedByGravity = false
        self.physicsBody?.isDynamic = false
        self.physicsBody?.restitution = 0.0
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
