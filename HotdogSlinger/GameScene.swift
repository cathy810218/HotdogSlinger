//
//  GameScene.swift
//  HotdogSlinger
//
//  Created by Cathy Oun on 5/21/17.
//  Copyright © 2017 Cathy Oun. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    var entities = [GKEntity]()
    var graphs = [String : GKGraph]()
    var hotdog = SKSpriteNode()

    let hotdogCategory: UInt32 = 0x1 << 0;
    let cactusCategory: UInt32 = 0x1 << 1;
    let sideboundsCategory: UInt32 = 0x1 << 2;
    
    var counterLabelNode = SKLabelNode(text: "0")
    
    
    override func didMove(to view: SKView) {
        super.didMove(to: view)
        self.physicsWorld.contactDelegate = self
        self.physicsWorld.gravity = CGVector(dx: 0.0, dy: -5.0)
        createHotdog()
        createBackground()
//        createCactus()
        setupCounterLabel()
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(fall))
        let longPress = UILongPressGestureRecognizer(target: self, action: #selector(springJump(longPress:)))
        self.view?.addGestureRecognizer(longPress)
//        self.view?.addGestureRecognizer(tap)
    }
    
    @objc func springJump(longPress: UILongPressGestureRecognizer) {
        switch longPress.state {
        case .began:
            print("begin")
            break
        case .ended:
            print("end")
            break
        default:
            break
        }
    }
    
    @objc func fall() {
        self.hotdog.physicsBody?.affectedByGravity = true
        let diff = CGVector(dx: 0, dy: 100)
        hotdog.physicsBody?.applyImpulse(diff)
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
        
        // Add boundries physics body
        self.physicsBody = SKPhysicsBody(edgeLoopFrom: self.frame)
        self.physicsBody?.categoryBitMask = sideboundsCategory
        self.physicsBody?.contactTestBitMask = hotdogCategory
    }
    
    func createCactus() {
        let cactusTexture = SKTexture(imageNamed: "cactus")
        
        for i in 0 ... 1 {
            let cactus = SKSpriteNode(texture: cactusTexture)
            cactus.anchorPoint = CGPoint.zero
            cactus.zPosition = -10 // so it won't block hotdog
            cactus.position = CGPoint(x: (cactusTexture.size().width * CGFloat(i)) - CGFloat(1 * i),
                                      y: -20)
            
            let moveLeft = SKAction.moveBy(x: -cactusTexture.size().width, y: 0, duration: 15)
            let moveReset = SKAction.moveBy(x: cactusTexture.size().width, y: 0, duration: 0)
            let moveLoop = SKAction.sequence([moveLeft, moveReset])
            let moveForever = SKAction.repeatForever(moveLoop)
            cactus.run(moveForever)
            cactus.physicsBody = SKPhysicsBody(rectangleOf: cactus.size, center: CGPoint(x: size.width / 2.0,y: cactus.size.height / 2.0 - 30.0))
            cactus.physicsBody?.categoryBitMask = cactusCategory
            cactus.physicsBody?.contactTestBitMask = hotdogCategory
            cactus.physicsBody?.isDynamic = false
            cactus.physicsBody?.affectedByGravity = false
            addChild(cactus)
        }
    }
    
    func createHotdog() {
        let hotdogTexture1 = SKTexture(imageNamed: "1")
        let hotdogTexture2 = SKTexture(imageNamed: "2")
        let hotdogTexture3 = SKTexture(imageNamed: "3")
        let hotdogTexture4 = SKTexture(imageNamed: "4")
        let hotdogTexture5 = SKTexture(imageNamed: "5")
        let hotdogTexture6 = SKTexture(imageNamed: "6")
        
        hotdog = SKSpriteNode(texture: hotdogTexture1)
        let hotdogRatio = hotdogTexture1.size().height / hotdogTexture1.size().width
        hotdog.size = CGSize(width: self.frame.size.height / 7 / hotdogRatio, height: self.frame.size.height / 7)
        hotdog.position = CGPoint(x: 25, y: 50)
        hotdog.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        hotdog.physicsBody = SKPhysicsBody(rectangleOf: hotdog.size)
        hotdog.physicsBody?.affectedByGravity = false
        hotdog.physicsBody?.categoryBitMask = hotdogCategory
//        hotdog.physicsBody?.contactTestBitMask = cactusCategory
        
//        hotdog.physicsBody?.collisionBitMask = sideboundsCategory
        let run = SKAction.animate(with: [hotdogTexture1, hotdogTexture2, hotdogTexture3, hotdogTexture4, hotdogTexture5, hotdogTexture6], timePerFrame: 0.12)
        let runForever = SKAction.repeatForever(run)
        let moveRight = SKAction.moveBy(x: 50, y: 0, duration: 1)
        let moveForever = SKAction.repeatForever(moveRight)
        hotdog.run(moveForever, withKey: "moveRight")
        hotdog.run(runForever)
        self.addChild(hotdog)
    }
    
    func setupCounterLabel() {
        counterLabelNode.position = CGPoint(x: self.frame.size.width/2, y: self.frame.size.height - 80)
        counterLabelNode.zPosition = 100
        counterLabelNode.fontSize = 50
        counterLabelNode.fontName = "MarkerFelt-Wide"
        addChild(counterLabelNode)
    }
    
    //MARK: Collision Detection
    func didBegin(_ contact: SKPhysicsContact) {
        let bodyA = contact.bodyA
        let bodyB = contact.bodyB
        
        if bodyA.categoryBitMask == cactusCategory || bodyB.categoryBitMask == cactusCategory {
            // show dead hotdog
            let deadHotdogTexture = SKTexture(imageNamed: "deadHotdog")
            let deadAction = SKAction.animate(with: [deadHotdogTexture], timePerFrame: 1, resize: true, restore: true)
            hotdog.size = CGSize(width: 100, height: 85)
            hotdog.run(SKAction.repeat(deadAction, count: 1))
            gameover()
        }
        if bodyA.categoryBitMask == sideboundsCategory || bodyB.categoryBitMask == sideboundsCategory {
            print("turn back")
            hotdog.xScale *= -1
            if hotdog.xScale == 1 {
                hotdog.removeAction(forKey: "moveLeft")
                let moveRight = SKAction.moveBy(x: 50, y: 0, duration: 1)
                let moveForever = SKAction.repeatForever(moveRight)
                hotdog.run(moveForever, withKey: "moveRight")
            } else {
                hotdog.removeAction(forKey: "moveRight")
                let moveLeft = SKAction.moveBy(x: -50, y: 0, duration: 1)
                let moveForever = SKAction.repeatForever(moveLeft)
                hotdog.run(moveForever, withKey: "moveLeft")
            }
        }
    }
    
    func gameover() {
        self.speed = 0
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
