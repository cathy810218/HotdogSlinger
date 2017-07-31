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
    let leftBoundCatrgory: UInt32 = 0x1 << 3;
    let rightBoundCategory: UInt32 = 0x1 << 4;
    let pathCategory: UInt32 = 0x1 << 5;
    
    var scoreLabelNode = SKLabelNode(text: "0")
    var timer = Timer()
    var timeCounter = 120
    var isLanded = true
    
    override func didMove(to view: SKView) {
        super.didMove(to: view)
        self.physicsWorld.contactDelegate = self
        self.physicsWorld.gravity = CGVector(dx: 0.0, dy: -8.5)
        createHotdog()
        createBackground()
//        createCactus()
        setupPaths()
        setupCounterLabel()
        
        let longPress = UILongPressGestureRecognizer(target: self, action: #selector(springJump(longPress:)))
        let tap = UITapGestureRecognizer(target: self, action: #selector(tapJump))
        self.view?.addGestureRecognizer(tap)
        self.view?.addGestureRecognizer(longPress)
        
    }
    
    @objc func springJump(longPress: UILongPressGestureRecognizer) {
        switch longPress.state {
        case .began:
            timer = Timer.scheduledTimer(timeInterval: 0.2, target: self, selector: #selector(incrementTimer), userInfo: nil, repeats: true)
            print("begin")
            break
        case .ended:
            print("end")
            timer.invalidate()
            let diff = CGVector(dx: 0, dy: timeCounter > 220 ? 220 : timeCounter)
            if isLanded {
                hotdog.physicsBody?.applyImpulse(diff)
            }
            isLanded = false
            timeCounter = 120
            break
        default:
            break
        }
    }
    
    @objc func incrementTimer() {
        timeCounter += 30
        print(timeCounter)
    }
    
    @objc func tapJump() {
        let diff = CGVector(dx: 0, dy: 120)
        if isLanded {
            hotdog.physicsBody?.applyImpulse(diff)
        }
        isLanded = false
    }
    
    func createBackground() {
        let backgroundTexture = SKTexture(imageNamed: "game_scene_background")
        for i in 0 ... 1 {
            let background = SKSpriteNode(texture: backgroundTexture)
//            let backgroundRatio = backgroundTexture.size().height / backgroundTexture.size().width
//            let normalizedHeight = self.frame.size.width * backgroundRatio
            
            background.zPosition = -30
            background.anchorPoint = CGPoint.zero
            background.size = CGSize(width: self.frame.size.width,
                                     height: self.frame.size.height)
            background.position = CGPoint(x: 0, y: background.size.height * CGFloat(i))
            addChild(background)
            let moveDown = SKAction.moveBy(x: 0, y: -background.size.height, duration: 12)
            let moveReset = SKAction.moveBy(x: 0, y: background.size.height, duration: 0)
            let moveLoop = SKAction.sequence([moveDown, moveReset])
            let moveForever = SKAction.repeatForever(moveLoop)
            background.run(moveForever)
        }
        
        // Add boundries physics body
        self.physicsBody = SKPhysicsBody(edgeLoopFrom: self.frame)
        self.physicsBody?.categoryBitMask = sideboundsCategory
        self.physicsBody?.contactTestBitMask = hotdogCategory
        
        let leftNode = SKSpriteNode()
        addChild(leftNode)
        leftNode.physicsBody = SKPhysicsBody(edgeFrom: CGPoint(x: 0, y: self.frame.size.height), to: CGPoint(x: 0, y: 0))
        leftNode.physicsBody?.categoryBitMask = leftBoundCatrgory
        leftNode.physicsBody?.contactTestBitMask = hotdogCategory
        
        let rightNode = SKSpriteNode()
        addChild(rightNode)
        rightNode.physicsBody = SKPhysicsBody(edgeFrom: CGPoint(x: self.frame.size.width, y: self.frame.size.height), to: CGPoint(x: self.frame.size.width, y: 0))
        rightNode.physicsBody?.categoryBitMask = rightBoundCategory
        rightNode.physicsBody?.contactTestBitMask = hotdogCategory
    }
    
//    func createCactus() {
//        let cactusTexture = SKTexture(imageNamed: "cactus")
//
//        for i in 0 ... 1 {
//            let cactus = SKSpriteNode(texture: cactusTexture)
//            cactus.anchorPoint = CGPoint.zero
//            cactus.zPosition = -10 // so it won't block hotdog
//            cactus.position = CGPoint(x: (cactusTexture.size().width * CGFloat(i)) - CGFloat(1 * i),
//                                      y: -20)
//
//            let moveLeft = SKAction.moveBy(x: -cactusTexture.size().width, y: 0, duration: 15)
//            let moveReset = SKAction.moveBy(x: cactusTexture.size().width, y: 0, duration: 0)
//            let moveLoop = SKAction.sequence([moveLeft, moveReset])
//            let moveForever = SKAction.repeatForever(moveLoop)
//            cactus.run(moveForever)
//            cactus.physicsBody = SKPhysicsBody(rectangleOf: cactus.size, center: CGPoint(x: size.width / 2.0,y: cactus.size.height / 2.0 - 30.0))
//            cactus.physicsBody?.categoryBitMask = cactusCategory
//            cactus.physicsBody?.contactTestBitMask = hotdogCategory
//            cactus.physicsBody?.isDynamic = false
//            cactus.physicsBody?.affectedByGravity = false
//            addChild(cactus)
//        }
//    }
    
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
        hotdog.physicsBody?.affectedByGravity = true
        hotdog.physicsBody?.categoryBitMask = hotdogCategory
        let run = SKAction.animate(with: [hotdogTexture1, hotdogTexture2, hotdogTexture3, hotdogTexture4, hotdogTexture5, hotdogTexture6], timePerFrame: 0.12)
        let runForever = SKAction.repeatForever(run)
        let moveRight = SKAction.moveBy(x: 60, y: 0, duration: 1)
        let moveForever = SKAction.repeatForever(moveRight)
        hotdog.physicsBody?.allowsRotation = false
        hotdog.physicsBody?.restitution = 0.0
        hotdog.run(moveForever, withKey: "moveRight")
        hotdog.run(runForever)
        self.addChild(hotdog)
    }
    
    func setupCounterLabel() {
        scoreLabelNode.position = CGPoint(x: self.frame.size.width/2, y: self.frame.size.height - 80)
        scoreLabelNode.zPosition = 100
        scoreLabelNode.fontSize = 50
        scoreLabelNode.fontName = "MarkerFelt-Wide"
        addChild(scoreLabelNode)
    }
    
    func setupPaths() {
        let path = generatePath()
        addChild(path)
    }
    
    func generatePath() -> SKSpriteNode {
        let path = SKSpriteNode(imageNamed: "pickle")
        path.zPosition = -20
        path.position = CGPoint(x: 100, y: 150) // random num
        path.physicsBody = SKPhysicsBody(rectangleOf: path.size)
        path.physicsBody?.allowsRotation = false
        path.physicsBody?.affectedByGravity = false
        path.physicsBody?.isDynamic = false
        path.physicsBody?.categoryBitMask = pathCategory
        path.physicsBody?.contactTestBitMask = hotdogCategory
        path.physicsBody?.collisionBitMask = hotdogCategory
        return path
    }
    
    //MARK: Collision Detection
    func didBegin(_ contact: SKPhysicsContact) {
        let bodyA = contact.bodyA
        let bodyB = contact.bodyB
        
//        if bodyA.categoryBitMask == cactusCategory || bodyB.categoryBitMask == cactusCategory {
//            // show dead hotdog
//            let deadHotdogTexture = SKTexture(imageNamed: "deadHotdog")
//            let deadAction = SKAction.animate(with: [deadHotdogTexture], timePerFrame: 1, resize: true, restore: true)
//            hotdog.size = CGSize(width: 100, height: 85)
//            hotdog.run(SKAction.repeat(deadAction, count: 1))
//            gameover()
//        }
        
        if bodyA.categoryBitMask == leftBoundCatrgory || bodyB.categoryBitMask == leftBoundCatrgory {
            print("turn back")
            hotdog.xScale = 1
            hotdog.removeAction(forKey: "moveLeft")
            let moveRight = SKAction.moveBy(x: 50, y: 0, duration: 1)
            let moveForever = SKAction.repeatForever(moveRight)
            hotdog.run(moveForever, withKey: "moveRight")
        } else if bodyA.categoryBitMask == rightBoundCategory || bodyB.categoryBitMask == rightBoundCategory {
            hotdog.xScale = -1
            hotdog.removeAction(forKey: "moveRight")
            let moveLeft = SKAction.moveBy(x: -50, y: 0, duration: 1)
            let moveForever = SKAction.repeatForever(moveLeft)
            hotdog.run(moveForever, withKey: "moveLeft")
        } else if bodyA.categoryBitMask == pathCategory || bodyB.categoryBitMask == pathCategory {
            print("hit it!")
        }
        isLanded = true
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
