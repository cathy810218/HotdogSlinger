//
//  GameScene.swift
//  HotdogSlinger
//
//  Created by Cathy Oun on 5/21/17.
//  Copyright © 2017 Cathy Oun. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {
    
    var entities = [GKEntity]()
    var graphs = [String : GKGraph]()
    
//    private var lastUpdateTime : TimeInterval = 0
//    private var label : SKLabelNode?
//    private var spinnyNode : SKShapeNode?
    let hotdogCategory : UInt32 = 0x1 << 0;
    let cactusCategory : UInt32 = 0x1 << 1;

    
    override func didMove(to view: SKView) {
        createBackground()
        createCactus()
        createHotdog()
    }
    
    func createBackground() {
        let backgroundTexture = SKTexture(imageNamed: "game_scene_background")
        
        for i in 0 ... 1 {
            let background = SKSpriteNode(texture: backgroundTexture)
            let backgroundRatio = backgroundTexture.size().height / backgroundTexture.size().width
            background.zPosition = -30
            background.anchorPoint = CGPoint.zero
            background.size = CGSize(width: self.frame.size.height / backgroundRatio,
                                     height: self.frame.size.height)
            background.position = CGPoint(x: ((self.frame.size.height / backgroundRatio) * CGFloat(i)) - CGFloat(1 * i), y: 0)
            addChild(background)
            
            let moveLeft = SKAction.moveBy(x: -(self.frame.size.height / backgroundRatio), y: 0, duration: 15)
            let moveReset = SKAction.moveBy(x: (self.frame.size.height / backgroundRatio), y: 0, duration: 0)
            let moveLoop = SKAction.sequence([moveLeft, moveReset])
            let moveForever = SKAction.repeatForever(moveLoop)
            
            background.run(moveForever)
        }
    }
    
    func createCactus() {
        let cactusTexture = SKTexture(imageNamed: "cactus")
        var cactus: SKSpriteNode

        
        for i in 0 ... 1 {
            cactus = SKSpriteNode(texture: cactusTexture)
            cactus.anchorPoint = CGPoint.zero
            cactus.zPosition = -10
            cactus.position = CGPoint(x: (cactusTexture.size().width * CGFloat(i)) - CGFloat(1 * i),
                                      y: -20)
            addChild(cactus)
            let moveLeft = SKAction.moveBy(x: -cactusTexture.size().width, y: 0, duration: 15)
            let moveReset = SKAction.moveBy(x: cactusTexture.size().width, y: 0, duration: 0)
            let moveLoop = SKAction.sequence([moveLeft, moveReset])
            let moveForever = SKAction.repeatForever(moveLoop)
            cactus.run(moveForever)
            cactus.physicsBody?.categoryBitMask = cactusCategory
            cactus.physicsBody?.contactTestBitMask = hotdogCategory
            cactus.physicsBody?.isDynamic = false
            cactus.physicsBody?.affectedByGravity = false
        }
    }
    
    func createHotdog() {
        let hotdogTexture1 = SKTexture(imageNamed: "1")
        let hotdogTexture2 = SKTexture(imageNamed: "2")
        let hotdogTexture3 = SKTexture(imageNamed: "3")
        let hotdogTexture4 = SKTexture(imageNamed: "4")
        let hotdogTexture5 = SKTexture(imageNamed: "5")
        let hotdogTexture6 = SKTexture(imageNamed: "6")
        
        let hotdog = SKSpriteNode(texture: hotdogTexture1)
        let hotdogRatio = hotdogTexture1.size().height / hotdogTexture1.size().width
        hotdog.size = CGSize(width: self.frame.size.height / 5 / hotdogRatio, height: self.frame.size.height / 5)
        hotdog.position = CGPoint(x: self.frame.size.width / 2, y: self.frame.size.height / 2)
        hotdog.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        hotdog.physicsBody = SKPhysicsBody(circleOfRadius: hotdog.size.width / 2)
        hotdog.physicsBody?.affectedByGravity = false
        hotdog.physicsBody?.categoryBitMask = hotdogCategory
        hotdog.physicsBody?.contactTestBitMask = cactusCategory
        
        let run = SKAction.animate(with: [hotdogTexture1, hotdogTexture2, hotdogTexture3, hotdogTexture4, hotdogTexture5, hotdogTexture6], timePerFrame: 0.12)
        self.addChild(hotdog)
        let runForever = SKAction.repeatForever(run)
        hotdog.run(runForever)
    }
    
    override func sceneDidLoad() {
//        self.lastUpdateTime = 0
        
        // Get label node from scene and store it for use later
//        self.label = self.childNode(withName: "//helloLabel") as? SKLabelNode
//        if let label = self.label {
//            label.alpha = 0.0
//            label.run(SKAction.fadeIn(withDuration: 2.0))
//        }
//        
//        // Create shape node to use during mouse interaction
//        let w = (self.size.width + self.size.height) * 0.05
//        self.spinnyNode = SKShapeNode.init(rectOf: CGSize.init(width: w, height: w), cornerRadius: w * 0.3)
//        
//        if let spinnyNode = self.spinnyNode {
//            spinnyNode.lineWidth = 2.5
//            
//            spinnyNode.run(SKAction.repeatForever(SKAction.rotate(byAngle: CGFloat(Double.pi), duration: 1)))
//            spinnyNode.run(SKAction.sequence([SKAction.wait(forDuration: 0.5),
//                                              SKAction.fadeOut(withDuration: 0.5),
//                                              SKAction.removeFromParent()]))
//        }
    }
    
    
//    func touchDown(atPoint pos : CGPoint) {
//        if let n = self.spinnyNode?.copy() as! SKShapeNode? {
//            n.position = pos
//            n.strokeColor = SKColor.green
//            self.addChild(n)
//        }
//    }
//    
//    func touchMoved(toPoint pos : CGPoint) {
//        if let n = self.spinnyNode?.copy() as! SKShapeNode? {
//            n.position = pos
//            n.strokeColor = SKColor.blue
//            self.addChild(n)
//        }
//    }
//    
//    func touchUp(atPoint pos : CGPoint) {
//        if let n = self.spinnyNode?.copy() as! SKShapeNode? {
//            n.position = pos
//            n.strokeColor = SKColor.red
//            self.addChild(n)
//        }
//    }
    
//    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
//        if let label = self.label {
//            label.run(SKAction.init(named: "Pulse")!, withKey: "fadeInOut")
//        }
//        
//        for t in touches { self.touchDown(atPoint: t.location(in: self)) }
//    }
//    
//    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
//        for t in touches { self.touchMoved(toPoint: t.location(in: self)) }
//    }
//    
//    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
//        for t in touches { self.touchUp(atPoint: t.location(in: self)) }
//    }
//    
//    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
//        for t in touches { self.touchUp(atPoint: t.location(in: self)) }
//    }
    
//    
//    override func update(_ currentTime: TimeInterval) {
//        // Called before each frame is rendered
//        
//        // Initialize _lastUpdateTime if it has not already been
//        if (self.lastUpdateTime == 0) {
//            self.lastUpdateTime = currentTime
//        }
//        
//        // Calculate time since last update
//        let dt = currentTime - self.lastUpdateTime
//        
//        // Update entities
//        for entity in self.entities {
//            entity.update(deltaTime: dt)
//        }
//        
//        self.lastUpdateTime = currentTime
//    }
}
