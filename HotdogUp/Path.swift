//
//  Path.swift
//  HotdogUp
//
//  Created by Cathy Oun on 8/2/17.
//  Copyright © 2017 Cathy Oun. All rights reserved.
//

import UIKit
import SpriteKit
enum PathType: Int {
    case pickle = 0
    case onion = 1
    case tomato = 2
    case mustard = 3
    case fire = 4
    
    
    var name : String {
        switch self {
        case .pickle: return "pickle"
        case .onion: return "onion"
        case .tomato: return "tomato"
        case .mustard: return "mustard"
        case .fire: return "fire"
        }
    }
}
class Path: SKSpriteNode {
    var isVisited: Bool
    var tag = 0
    var type: PathType = PathType.pickle {
        didSet {
            self.texture = SKTexture(imageNamed: "\(type.name)")
        }
    }
    
    init(position: CGPoint) {
        let texture = SKTexture(imageNamed: "pickle")
        self.isVisited = false
        super.init(texture: texture, color: UIColor.clear, size: texture.size())
        self.position = position
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
