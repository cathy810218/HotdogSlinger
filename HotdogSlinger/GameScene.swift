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
    
    var hotdog = SKSpriteNode()
    var hotdogRunForever = SKAction()
    
    let hotdogCategory: UInt32 = 0x1 << 0;
    let cactusCategory: UInt32 = 0x1 << 1;
    let sideboundsCategory: UInt32 = 0x1 << 2;
    let leftBoundCatrgory: UInt32 = 0x1 << 3;
    let rightBoundCategory: UInt32 = 0x1 << 4;
    let pathCategory: UInt32 = 0x1 << 5;
    
    var background = SKSpriteNode()
    var score = 0
    var scoreLabelNode = SKLabelNode(text: "0")
    var timer = Timer()
    var timeCounter = kMinJumpHeight
    var isLanded = true
    
    var paths = [SKSpriteNode]()
    var moveDown = SKAction()
    
    override func didMove(to view: SKView) {
        super.didMove(to: view)
        self.physicsWorld.contactDelegate = self
        self.physicsWorld.gravity = CGVector(dx: 0.0, dy: -8.5)
        moveDown = SKAction.moveBy(x: 0, y: -background.size.height/3.0, duration: 12)
        
        createHotdog()
        createBackground()
        setupPaths()
        setupCounterLabel()
        
//        let longPress = UILongPressGestureRecognizer(target: self,
//                                                     action: #selector(moveDirection(longPress:)))
//        let tap = UITapGestureRecognizer(target: self,
//                                         action: #selector(tapJump))
//        self.view?.addGestureRecognizer(tap)
//        self.view?.addGestureRecognizer(longPress)
    }
//    @objc func springJump(longPress: UILongPressGestureRecognizer) {
//        switch longPress.state {
//        case .began:
//            timer = Timer.scheduledTimer(timeInterval: 0.2,
//                                         target: self,
//                                         selector: #selector(incrementTimer),
//                                         userInfo: nil,
//                                         repeats: true)
//            print("begin")
//            break
//        case .ended:
//            print("end")
//            timer.invalidate()
//            let diff = CGVector(dx: hotdog.xScale > 0.0 ? 20 : -20,
//                                dy: timeCounter > kMaxJumpHeight ? kMaxJumpHeight : timeCounter)
//            if isLanded {
//                hotdog.physicsBody?.applyImpulse(diff)
//            }
//            isLanded = false
//            timeCounter = kMinJumpHeight
//            break
//        default:
//            break
//        }
//    }
        
//    @objc func incrementTimer() {
//        timeCounter += kJumpIntensity
//        print(timeCounter)
//    }
    
    @objc func tapJump() {
//        let diff = CGVector(dx: hotdog.xScale > 0.0 ? 20 : -20, dy: kMinJumpHeight)
        let diff = CGVector(dx: 0, dy: kMinJumpHeight)
        if isLanded {
            hotdog.physicsBody?.applyImpulse(diff)
        }
        isLanded = false
    }
    
    func createBackground() {
        for i in 0 ... 1 {
            background = SKSpriteNode(texture: SKTexture(imageNamed: "background"))
            background.zPosition = -30
            background.anchorPoint = CGPoint.zero
            background.size = CGSize(width: self.frame.size.width,
                                     height: self.frame.size.height)
            background.position = CGPoint(x: 0, y: background.size.height * CGFloat(i))
            addChild(background)
//            let moveDown = SKAction.moveBy(x: 0, y: -background.size.height, duration: 12)
//            let moveReset = SKAction.moveBy(x: 0, y: background.size.height, duration: 0)
//            let moveLoop = SKAction.sequence([moveDown, moveReset])
//            let moveForever = SKAction.repeatForever(moveLoop)
//            background.run(moveForever)
        }
        
        // Add boundries physics body
        self.physicsBody = SKPhysicsBody(edgeLoopFrom: self.frame)
        self.physicsBody?.categoryBitMask = sideboundsCategory
        self.physicsBody?.contactTestBitMask = hotdogCategory
        self.physicsBody?.restitution = 0.0
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
        
//        let bottomNode = SKSpriteNode()
//        addChild(bottomNode)
//        bottomNode.physicsBody = SKPhysicsBody(edgeFrom: CGPoint(x: 0, y: 0), to: CGPoint(x: self.frame.size.width, y: self.frame.size.height))
//        bottomNode.physicsBody?.categoryBitMask = bottomCategory
//        bottomNode.physicsBody?.contactTestBitMask = hotdogCategory
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
        let hotdogTexture7 = SKTexture(imageNamed: "7")
        let hotdogTexture8 = SKTexture(imageNamed: "8")
        
        hotdog = SKSpriteNode(texture: hotdogTexture8)
        hotdog.zPosition = 30
        hotdog.position = CGPoint(x: self.frame.size.width/2.0, y: hotdog.size.height/2.0)
        hotdog.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        hotdog.physicsBody = SKPhysicsBody(rectangleOf: hotdog.size)
        hotdog.physicsBody?.affectedByGravity = true
        hotdog.physicsBody?.collisionBitMask = 0
        hotdog.physicsBody?.categoryBitMask = hotdogCategory
        hotdog.physicsBody?.collisionBitMask = sideboundsCategory
        
        let run = SKAction.animate(with: [hotdogTexture1, hotdogTexture2, hotdogTexture3, hotdogTexture4, hotdogTexture5, hotdogTexture6, hotdogTexture7], timePerFrame: 0.2)
        hotdogRunForever = SKAction.repeatForever(run)
        hotdog.physicsBody?.allowsRotation = false
        hotdog.physicsBody?.restitution = 0.0
        self.addChild(hotdog)
    }
    
    func setupCounterLabel() {
        scoreLabelNode.position = CGPoint(x: self.frame.size.width/2, y: self.frame.size.height - 80)
        scoreLabelNode.zPosition = 100
        scoreLabelNode.fontSize = 50
        scoreLabelNode.fontName = "MarkerFelt-Wide"
        addChild(scoreLabelNode)
    }
    
    override func update(_ currentTime: TimeInterval) {
        scoreLabelNode.text = String(score)
        if let body = hotdog.physicsBody {
            let dy = body.velocity.dy
            if dy > 0 {
                // Prevent collisions if the hero is jumping
                body.collisionBitMask = sideboundsCategory
            }
            
            if hotdog.position.y > 2 * self.frame.size.height / 3.0 {
                // move the background up
                print("move the background")
                
                
//                for i in 0 ... 1 {
//                    background = SKSpriteNode(texture: SKTexture(imageNamed: "background"))
//                    background.zPosition = -30
//                    background.anchorPoint = CGPoint.zero
//                    background.size = CGSize(width: self.frame.size.width,
//                                             height: self.frame.size.height)
//                    background.position = CGPoint(x: 0, y: background.size.height * CGFloat(i))
//                    addChild(background)
//                    let moveDown = SKAction.moveBy(x: 0, y: -background.size.height, duration: 12)
//                    //            let moveReset = SKAction.moveBy(x: 0, y: background.size.height, duration: 0)
//                    //            let moveLoop = SKAction.sequence([moveDown, moveReset])
//                    let moveForever = SKAction.repeatForever(moveDown)
//                    background.run(moveForever)
//                }
            }
//            } else if dy < 0 {
//                // Allow collisions if the hero is falling
//                body.collisionBitMask = sideboundsCategory | pathCategory
//                body.contactTestBitMask = pathCategory
//            }
        }
    }
    func setupPaths() {
        generatePaths()
        for path in paths {
            path.physicsBody?.categoryBitMask = pathCategory
            path.physicsBody?.contactTestBitMask = hotdogCategory
            path.physicsBody?.collisionBitMask = hotdogCategory
            addChild(path)
//            let moveReset = SKAction.moveBy(x: 0, y: background.size.height, duration: 0)
//            let moveLoop = SKAction.sequence([moveDown, moveReset])
//            let moveForever = SKAction.repeatForever(moveLoop)
//            path.run(moveForever)
        }
//            self.addChild(path)
//            let moveReset = SKAction.moveBy(x: 0, y: background.size.height, duration: 0)
//            let moveLoop = SKAction.sequence([moveDown, moveReset])
//            let moveForever = SKAction.repeatForever(moveLoop)
//            path.run(moveForever)
//        }
//        let delay = SKAction.wait(forDuration: 2)
//        let generate = SKAction.run {
//            
//        }
//        let initial = SKAction.sequence([generate, delay])
//        let regenerate = SKAction.repeatForever(initial)
//        run(regenerate)
    }
    
    func generatePaths() {
        var firstPath = Path(position: CGPoint(x: 80, y: 130))
        paths.append(firstPath)
        for _ in 0 ... 5 {
            firstPath = paths.last as! Path
            let x = p_randomPoint(min: Int(firstPath.size.width / 2.0),
                                  max: Int(self.frame.size.width - (firstPath.size.width / 2.0) - 100))
            let y = Int(firstPath.frame.origin.y) + kMinJumpHeight + 30
            let path = Path(position: CGPoint(x: x, y: y))
            print("view width \(self.frame.size.width)")
            print("x: \(x) y: \(y)")
            print("hotdog size: \(hotdog.size)")
            paths.append(path)
        }
    }
    
    private func p_randomPoint(min: Int, max: Int) -> Int {
        let rand = Int(arc4random_uniform(UInt32(max))) + min
        return rand
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
//            hotdog.removeAllActions()
//            hotdog.texture = SKTexture(imageNamed: "8")
            
            hotdog.xScale *= -1
            hotdog.removeAction(forKey: "moveLeft")
            let moveRight = SKAction.moveBy(x: kHotdogMoveVelocity, y: 0, duration: 1)
            let moveForever = SKAction.repeatForever(moveRight)
            hotdog.run(moveForever, withKey: "moveRight")
        } else if bodyA.categoryBitMask == rightBoundCategory || bodyB.categoryBitMask == rightBoundCategory {
//            hotdog.removeAllActions()
//            hotdog.texture = SKTexture(imageNamed: "8")
            hotdog.xScale *= -1
            hotdog.removeAction(forKey: "moveRight")
            let moveLeft = SKAction.moveBy(x: -kHotdogMoveVelocity, y: 0, duration: 1)
            let moveForever = SKAction.repeatForever(moveLeft)
            hotdog.run(moveForever, withKey: "moveLeft")
        }
//        } else
        if bodyA.categoryBitMask == pathCategory || bodyB.categoryBitMask == pathCategory {
            let currPath = bodyB.categoryBitMask == pathCategory ? bodyB.node as! Path : bodyA.node as! Path
            print("hit path")
            let dy = hotdog.physicsBody!.velocity.dy
            if dy > 0 {
                // go up
                hotdog.physicsBody?.collisionBitMask = sideboundsCategory
//                isLanded = false
            } else if dy < 0 {
                // if current hotdog position is greater than current path
                if (hotdog.position.y - hotdog.size.height / 2 >= currPath.position.y + currPath.size.height / 2 - 20) {
                    print("about to land!")
                    hotdog.physicsBody?.contactTestBitMask = pathCategory
                    hotdog.physicsBody?.collisionBitMask = sideboundsCategory | pathCategory
                    
                    if !currPath.isVisited {
//                        let jumpSound = SKAction.playSoundFileNamed("StarPing.wav", waitForCompletion: false)
//                        self.run(jumpSound)
                        score += 1
                        currPath.isVisited = true
                    }
                    isLanded = true
                }
            }
        }
        isLanded = hotdog.physicsBody?.velocity.dy == 0.0
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
    
    
    func touchDown(atPoint pos : CGPoint) {
//        if let n = self.spinnyNode?.copy() as! SKShapeNode? {
//            n.position = pos
//            n.strokeColor = SKColor.green
//            self.addChild(n)
//        }
        print(pos)
        if pos.x < self.frame.size.width / 5.0 {
            if !hotdog.hasActions() {
                hotdog.run(hotdogRunForever, withKey: "hotdogRunForever")
            }
            print("tap left")
            hotdog.xScale *= hotdog.xScale > 0 ? -1 : 1
            hotdog.removeAction(forKey: "moveRight")
            let moveLeft = SKAction.moveBy(x: -kHotdogMoveVelocity, y: 0, duration: 1)
            let moveForever = SKAction.repeatForever(moveLeft)
            hotdog.run(moveForever, withKey: "moveLeft")
        } else if pos.x > 4 * self.frame.size.width / 5.0 {
            if !hotdog.hasActions() {
                hotdog.run(hotdogRunForever, withKey: "hotdogRunForever")
            }
            print("tap right")
            hotdog.xScale *= hotdog.xScale > 0 ? 1 : -1
            hotdog.removeAction(forKey: "moveLeft")
            let moveRight = SKAction.moveBy(x: kHotdogMoveVelocity, y: 0, duration: 1)
            let moveForever = SKAction.repeatForever(moveRight)
            hotdog.run(moveForever, withKey: "moveRight")
        } else {
            // middle
//            hotdog.removeAction(forKey: "hotdogRunForever")
            if !hotdog.hasActions() {
                hotdog.texture = SKTexture(imageNamed: "8")
            }
            let diff = CGVector(dx: 0, dy: kMinJumpHeight)
            if isLanded {
                hotdog.physicsBody?.applyImpulse(diff)
            }
            isLanded = false
        }
        
        //        if bodyA.categoryBitMask == leftBoundCatrgory || bodyB.categoryBitMask == leftBoundCatrgory {
        //            print("turn back")
        //            hotdog.xScale *= -1
        //            hotdog.removeAction(forKey: "moveLeft")
        //            let moveRight = SKAction.moveBy(x: kHotdogMoveVelocity, y: 0, duration: 1)
        //            let moveForever = SKAction.repeatForever(moveRight)
        //            hotdog.run(moveForever, withKey: "moveRight")
        //        } else if bodyA.categoryBitMask == rightBoundCategory || bodyB.categoryBitMask == rightBoundCategory {
        //            hotdog.xScale *= -1
        //            hotdog.removeAction(forKey: "moveRight")
        //            let moveLeft = SKAction.moveBy(x: -kHotdogMoveVelocity, y: 0, duration: 1)
        //            let moveForever = SKAction.repeatForever(moveLeft)
        //            hotdog.run(moveForever, withKey: "moveLeft")
        //        }
//        print("touch down")
    }
    
    func touchMoved(toPoint pos : CGPoint) {
//        if let n = self.spinnyNode?.copy() as! SKShapeNode? {
//            n.position = pos
//            n.strokeColor = SKColor.blue
//            self.addChild(n)
//        }
    }
    
    func touchUp(atPoint pos : CGPoint) {
//        if let n = self.spinnyNode?.copy() as! SKShapeNode? {
//            n.position = pos
//            n.strokeColor = SKColor.red
//            self.addChild(n)
//        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        print("touch begin")
//        if let label = self.label {
//            label.run(SKAction.init(named: "Pulse")!, withKey: "fadeInOut")
//        }
//
        for t in touches {
            self.touchDown(atPoint: t.location(in: self))
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches {
            self.touchMoved(toPoint: t.location(in: self))
            print(t.location(in: self))
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchUp(atPoint: t.location(in: self)) }
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        hotdog.removeAllActions()
        hotdog.texture = SKTexture(imageNamed: "8")
        for t in touches { self.touchUp(atPoint: t.location(in: self)) }
    }
    
    
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
