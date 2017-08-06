//
//  GameViewController.swift
//  HotdogUp
//
//  Created by Cathy Oun on 5/21/17.
//  Copyright © 2017 Cathy Oun. All rights reserved.
//

import UIKit
import SpriteKit
import GameplayKit
import SnapKit

class GameViewController: UIViewController {
    var pauseView = UIView()
    var pauseBtn = UIButton()
    var gameScene : GameScene!
    var skView = SKView()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        presentGameScene()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        gameScene = GameScene(size: view.bounds.size)
        gameScene.scaleMode = .resizeFill
        
//        gameScene.gameVC = self
        
        setupPauseView()
        setupGameOverView()
    }
    
    func presentGameScene() {
        skView = view as! SKView
        skView.showsFPS = true
        skView.showsNodeCount = true
        skView.ignoresSiblingOrder = true
        skView.presentScene(gameScene)
    }
    
    
    func setupPauseView() {
        pauseBtn = UIButton(type: .custom)
        pauseBtn.setBackgroundImage(UIImage(named: "button_pause"), for: .normal)
        self.view?.addSubview(pauseBtn)
        pauseBtn.addTarget(self, action: #selector(pauseButtonDidPressed), for: .touchUpInside)
        pauseBtn.snp.makeConstraints { (make) in
            make.top.left.equalTo(30)
            make.width.height.equalTo(25)
        }
        
        let img = UIImage(named: "button_resume")
        pauseView = UIView()
        self.view?.addSubview(pauseView)
        pauseView.isHidden = true
        pauseView.snp.makeConstraints { (make) in
            make.edges.equalTo(self.view!)
        }
        pauseView.backgroundColor = UIColor(hex: "#000000", alpha: 0.5)
        
        let buttonsView = UIView()
        pauseView.addSubview(buttonsView)
        buttonsView.snp.makeConstraints { (make) in
            make.centerY.centerX.equalTo(pauseView)
            make.width.equalTo(3 * (img?.size.height)! + 16)
            make.height.equalTo(2 * (img?.size.height)! + 8)
        }
        
        // home button
        let homeBtn = UIButton(type: .custom)
        homeBtn.setBackgroundImage(UIImage(named: "button_home"), for: .normal)
        homeBtn.layer.cornerRadius = 5.0
        homeBtn.layer.masksToBounds = true
        buttonsView.addSubview(homeBtn)
        homeBtn.snp.makeConstraints { (make) in
            make.top.left.equalTo(buttonsView)
        }
        homeBtn.addTarget(self, action: #selector(returnToMenu), for: .touchUpInside)
        
        
        // resume button
        let resumeBtn = UIButton(type: .custom)
        resumeBtn.setBackgroundImage(UIImage(named: "button_resume"), for: .normal)
        resumeBtn.layer.cornerRadius = 5.0
        resumeBtn.layer.masksToBounds = true
        buttonsView.addSubview(resumeBtn)
        resumeBtn.snp.makeConstraints { (make) in
            make.top.right.equalTo(buttonsView)
        }
        resumeBtn.addTarget(self, action: #selector(resume), for: .touchUpInside)
        
        
        // replay button
        let replayBtn = UIButton(type: .custom)
        replayBtn.setBackgroundImage(UIImage(named: "button_replay"), for: .normal)
        replayBtn.layer.cornerRadius = 5.0
        replayBtn.layer.masksToBounds = true
        buttonsView.addSubview(replayBtn)
        replayBtn.snp.makeConstraints { (make) in
            make.top.centerX.equalTo(buttonsView)
        }
        replayBtn.addTarget(self, action: #selector(resetGame), for: .touchUpInside)
        
        // sound button
        let soundBtn = UIButton(type: .custom)
        soundBtn.setBackgroundImage(UIImage(named: "button_sound"), for: .normal)
        soundBtn.layer.cornerRadius = 5.0
        soundBtn.layer.masksToBounds = true
        buttonsView.addSubview(soundBtn)
        soundBtn.snp.makeConstraints { (make) in
            make.left.bottom.equalTo(buttonsView)
        }
        soundBtn.addTarget(self, action: #selector(soundSwitch), for: .touchUpInside)
        
        // music button
        let musicBtn = UIButton(type: .custom)
        musicBtn.setBackgroundImage(UIImage(named: "button_music"), for: .normal)
        musicBtn.layer.cornerRadius = 5.0
        musicBtn.layer.masksToBounds = true
        buttonsView.addSubview(musicBtn)
        musicBtn.snp.makeConstraints { (make) in
            make.bottom.centerX.equalTo(buttonsView)
        }
        musicBtn.addTarget(self, action: #selector(musicSwitch), for: .touchUpInside)
        
        // share button
        let shareBtn = UIButton(type: .custom)
        shareBtn.setBackgroundImage(UIImage(named: "button_share"), for: .normal)
        shareBtn.layer.cornerRadius = 5.0
        shareBtn.layer.masksToBounds = true
        buttonsView.addSubview(shareBtn)
        shareBtn.snp.makeConstraints { (make) in
            make.right.bottom.equalTo(buttonsView)
        }
        shareBtn.addTarget(self, action: #selector(share), for: .touchUpInside)
    }
    
    @objc func returnToMenu() {
        gameScene.removeAllChildren()
        gameScene.removeFromParent()
        skView.presentScene(nil)
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func pauseButtonDidPressed() {
        UserDefaults.standard.set(gameScene.speed, forKey: "UserDefaultResumeSpeedKey")
        gameScene.isPaused = true
        gameScene.hotdog.isPaused = true
        pauseView.isHidden = false
        pauseBtn.isEnabled = false // disable it
    }
    
    @objc func soundSwitch() {
        
    }
    
    @objc func musicSwitch() {
        
    }
    
    @objc func share() {
        
    }
    
    
    @objc func resume() {
        gameScene.speed = CGFloat(UserDefaults.standard.float(forKey: "UserDefaultResumeSpeedKey"))
        gameScene.isPaused = false
        gameScene.hotdog.isPaused = false
        pauseView.isHidden = true
        pauseBtn.isEnabled = true
    }
    
    @objc func resetGame() {
        gameScene.score = 0
        gameScene.scoreLabel.text = "0"
        
        gameScene.removeAllChildren()
        gameScene.paths.removeAll()
        gameScene.createHotdog()
        gameScene.createBackground()
        gameScene.setupPaths()
        
        gameScene.speed = 1
        gameScene.physicsBody?.categoryBitMask = gameScene.sideboundsCategory
        gameScene.isPaused = false
        gameScene.hotdog.isPaused = false
        gameScene.isGameOver = false
        pauseView.isHidden = true
        pauseBtn.isEnabled = true
        gameScene.isLanded = true
        gameScene.sideboundsCategory = 0x1 << 2 // reset sidebounds
    }
    
    
    func setupGameOverView() {
        let gameOverView = UIView()
        self.view.addSubview(gameOverView)
        gameOverView.backgroundColor = UIColor(hex: "#85C5B5")
        gameOverView.snp.makeConstraints { (make) in
            make.center.equalTo(self.view)
            
        }
        
    }
    
    // ============================
    
    override var shouldAutorotate: Bool {
        return true
    }

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return .allButUpsideDown
        } else {
            return .all
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }
}
