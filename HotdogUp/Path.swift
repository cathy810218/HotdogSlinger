//
//  Path.swift
//  HotdogUp
//
//  Created by Cathy Oun on 8/2/17.
//  Copyright © 2017 Cathy Oun. All rights reserved.
//

import UIKit
import SpriteKit
class Path: SKSpriteNode {
    var isVisited: Bool
    var tag = 0
    init(position: CGPoint) {
        let texture = SKTexture(imageNamed: "pickle")
        self.isVisited = false
        super.init(texture: texture, color: UIColor.clear, size: texture.size())
        self.position = position
//        self.physicsBody = SKPhysicsBody(texture: texture, alphaThreshold: 0, size: self.size)
        
//        self.physicsBody = SKPhysicsBody(circleOfRadius: max(self.size.width/2, self.size.height/2))
//        self.physicsBody = SKPhysicsBody(texture: texture, size: self.size)
        self.physicsBody = SKPhysicsBody(rectangleOf: self.size)
        self.physicsBody?.allowsRotation = false
        self.physicsBody?.affectedByGravity = false
        self.physicsBody?.isDynamic = false
        self.physicsBody?.friction = 1
        self.physicsBody?.restitution = 0.0
        self.anchorPoint = CGPoint(x: 0.5, y: 0.5)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func reset() {
        isVisited = false
    }
}
