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
import StoreKit
import GoogleMobileAds

class GameViewController: UIViewController, GameSceneDelegate, GADInterstitialDelegate, SKPaymentTransactionObserver, SKProductsRequestDelegate {
    var pauseView = UIView()
    var pauseBtn = UIButton()
    var removeAdsBtn = UIButton()
    var restoreIAPBtn = UIButton()
    var gameScene : GameScene!
    var skView = SKView()
    var gameoverView = UIView()
    var soundBtn = UIButton()
    var musicBtn = UIButton()
    var tutorialView = TutorialView()
    var interstitial: GADInterstitial?
    var hasInternet = true {
        didSet {
            if !hasInternet {
                let alert = UIAlertController(title: "No Internet Warnings!",
                                              message: "Please make sure you have internet connection for storing your highest score",
                                              preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
        }
    }
    var product: SKProduct?
    var productID = "com.hotdogup.removeads"
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        presentGameScene()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // need to set the key value before init the GameScene
        if UserDefaults.standard.object(forKey: "UserDefaultIsMusicOnKey") == nil {
            UserDefaults.standard.set(true, forKey: "UserDefaultIsMusicOnKey")
        }
        
        if UserDefaults.standard.object(forKey: "UserDefaultIsSoundEffectOnKey") == nil {
            UserDefaults.standard.set(true, forKey: "UserDefaultIsSoundEffectOnKey")
        }
        
        gameScene = GameScene(size: view.bounds.size)
        gameScene.scaleMode = .resizeFill
        gameScene.gameSceneDelegate = self
        setupPauseView()
        setupGameOverView()
        
        tutorialView = TutorialView(frame: self.view.frame)
        self.view.addSubview(tutorialView)
        tutorialView.isHidden = true
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
        let pauseImg = UIImage(named: "button_pause")
        pauseBtn.setBackgroundImage(pauseImg, for: .normal)
        self.view?.addSubview(pauseBtn)
        pauseBtn.addTarget(self, action: #selector(pauseButtonDidPressed), for: .touchUpInside)
        pauseBtn.snp.makeConstraints { (make) in
            make.top.left.equalTo(30)
            make.width.height.equalTo((pauseImg?.size.width)!)
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
        soundBtn = UIButton(type: .custom)
        soundBtn.setBackgroundImage(UIImage(named: gameScene.isSoundEffectOn ? "button_sound" : "button_soundoff"), for: .normal)
        soundBtn.layer.cornerRadius = 5.0
        soundBtn.layer.masksToBounds = true
        buttonsView.addSubview(soundBtn)
        soundBtn.snp.makeConstraints { (make) in
            make.left.bottom.equalTo(buttonsView)
        }
        soundBtn.addTarget(self, action: #selector(soundSwitch), for: .touchUpInside)
        
        // music button
        musicBtn = UIButton(type: .custom)
        musicBtn.setBackgroundImage(UIImage(named: gameScene.isMusicOn ? "button_music" : "button_musicoff"), for: .normal)
        musicBtn.layer.cornerRadius = 5.0
        musicBtn.layer.masksToBounds = true
        buttonsView.addSubview(musicBtn)
        musicBtn.snp.makeConstraints { (make) in
            make.bottom.centerX.equalTo(buttonsView)
        }
        musicBtn.addTarget(self, action: #selector(musicSwitch), for: .touchUpInside)
        
        // share button
        let shareBtn = UIButton(type: .custom)
        shareBtn.setBackgroundImage(UIImage(named: "button_info"), for: .normal)
        shareBtn.layer.cornerRadius = 5.0
        shareBtn.layer.masksToBounds = true
        buttonsView.addSubview(shareBtn)
        shareBtn.snp.makeConstraints { (make) in
            make.right.bottom.equalTo(buttonsView)
        }
        shareBtn.addTarget(self, action: #selector(showTutorialView), for: .touchUpInside)
    }
    
    @objc func returnToMenu() {
        gameScene.removeAllChildren()
        gameScene.removeFromParent()
        skView.presentScene(nil)
        MusicPlayer.player.stop()
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func pauseButtonDidPressed() {
        UserDefaults.standard.set(gameScene.speed, forKey: "UserDefaultResumeSpeedKey")
        gameScene.gamePaused = true
        MusicPlayer.player.pause()
        pauseView.isHidden = false
        gameScene.isUserInteractionEnabled = false
        pauseBtn.isEnabled = false // disable it
    }
    
    @objc func soundSwitch() {
        // check if sound is on or off
        gameScene.isSoundEffectOn = !gameScene.isSoundEffectOn
        UserDefaults.standard.set(gameScene.isSoundEffectOn, forKey: "UserDefaultIsSoundEffectOnKey")
        soundBtn.setBackgroundImage(UIImage(named: gameScene.isSoundEffectOn ? "button_sound" : "button_soundoff"), for: .normal)
    }
    
    @objc func musicSwitch() {
        gameScene.isMusicOn = !gameScene.isMusicOn
        UserDefaults.standard.set(gameScene.isMusicOn, forKey: "UserDefaultIsMusicOnKey")
        musicBtn.setBackgroundImage(UIImage(named: gameScene.isMusicOn ? "button_music" : "button_musicoff"), for: .normal)
    }
    
    @objc func showTutorialView() {
        tutorialView.isHidden = false
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(tapToDismiss))
        tutorialView.addGestureRecognizer(tap)
        
    }
    
    @objc func tapToDismiss() {
        tutorialView.isHidden = true
    }
    
    @objc func share() {
        let score : String = gameScene.scoreLabel.text ?? "0"
        
        //Generate the screenshot
        UIGraphicsBeginImageContext(view.frame.size)
        let context: CGContext = UIGraphicsGetCurrentContext()!
        view.layer.render(in: context)
        let screenshot = view.takeSnapshot()
        socialShare(sharingText: "🌭 I just hit \(score) on HotdogUp! Beat it! 🌭\n\n\n\(shareToAppStoreURL)",
                    sharingImage: screenshot)
    }
    
    private func socialShare(sharingText: String?, sharingImage: UIImage?) {
        var sharingItems = [Any]()
        
        if let text = sharingText {
            sharingItems.append(text)
        }
        if let image = sharingImage {
            sharingItems.append(image)
        }
        
        let activityVC = UIActivityViewController(activityItems: sharingItems, applicationActivities: nil)
        if #available(iOS 11.0, *) {
            activityVC.excludedActivityTypes = [.addToReadingList,
                                                .airDrop,
                                                .assignToContact,
                                                .copyToPasteboard,
                                                .markupAsPDF,
                                                .openInIBooks,
                                                .postToVimeo,
                                                .saveToCameraRoll,
                                                .print]
        } else {
            // Fallback on earlier versions
        }
        self.present(activityVC, animated: true, completion: nil)
    }
    
    @objc func resume() {
        gameScene.speed = CGFloat(UserDefaults.standard.float(forKey: "UserDefaultResumeSpeedKey"))
        gameScene.gamePaused = false
        gameScene.isReset = false
        gameScene.isMusicOn = UserDefaults.standard.bool(forKey: "UserDefaultIsMusicOnKey")
        pauseView.isHidden = true
        pauseBtn.isEnabled = true
        gameScene.isUserInteractionEnabled = true
    }
    
    @objc func resetGameToShowAds() {
        gameoverView.isHidden = true
        if !UserDefaults.standard.bool(forKey: "UserDefaultPurchaseKey") && hasInternet {
            interstitial = createInterstitial()
        } else {
            resetGame()
        }
    }
    
    @objc func resetGame() {
        gameScene.score = 0
        gameScene.scoreLabel.text = "0"
        gameScene.removeAllChildren()
        gameScene.paths.removeAll()
        gameScene.createHotdog()
        gameScene.createBackground()
        gameScene.setupPaths()
        gameScene.setupHighestScoreLabel()
        gameScene.isReset = true
        gameScene.speed = 1
        gameScene.physicsBody?.categoryBitMask = gameScene.sideboundsCategory
        gameScene.gamePaused = false
        gameScene.isGameOver = false
        pauseView.isHidden = true
        pauseBtn.isEnabled = true
        gameScene.isLanded = true
        gameScene.isUserInteractionEnabled = true
        gameScene.sideboundsCategory = 0x1 << 2 // reset sidebounds
    }
    
    func setupGameOverView() {
        gameoverView = UIView()
        self.view.addSubview(gameoverView)
        gameoverView.isHidden = true
        gameoverView.snp.makeConstraints { (make) in
            make.edges.equalTo(self.view!)
        }
        gameoverView.backgroundColor = UIColor(hex: "#000000", alpha: 0.5)
        
        let gameoverHotdogView = UIImageView(image: UIImage(named: "gameover_hotdog"))
            
        let gameoverBackgroundView = UIImageView(image: UIImage(named: "gameover_background"))
        gameoverView.addSubview(gameoverBackgroundView)
        gameoverBackgroundView.snp.makeConstraints { (make) in
            make.center.equalTo(gameoverView)
            make.width.equalTo(self.view.frame.size.width)
            make.height.equalTo(gameoverHotdogView.frame.size.height * 2)
        }
        gameoverBackgroundView.layer.cornerRadius = 10.0
        gameoverBackgroundView.layer.masksToBounds = true
        
        
        let gameoverTitleView = UIImageView(image: UIImage(named: "gameover"))
        gameoverView.addSubview(gameoverTitleView)
        gameoverTitleView.snp.makeConstraints { (make) in
            make.top.left.equalTo(gameoverBackgroundView).offset(10)
            make.right.equalTo(gameoverBackgroundView).offset(-10)
        }
        
        gameoverView.addSubview(gameoverHotdogView)
        gameoverHotdogView.snp.makeConstraints { (make) in
            make.center.equalTo(gameoverBackgroundView)
        }
        
        let homeBtn = UIButton(type: .custom)
        homeBtn.setBackgroundImage(UIImage(named: "gameover_home"), for: .normal)
        gameoverView.addSubview(homeBtn)
        homeBtn.snp.makeConstraints { (make) in
            make.left.equalTo(gameoverBackgroundView)
            make.bottom.equalTo(gameoverBackgroundView).offset(-12)
        }
        homeBtn.addTarget(self, action: #selector(returnToMenu), for: .touchUpInside)
        
        let replayBtn = UIButton(type: .custom)
        replayBtn.setBackgroundImage(UIImage(named: "gameover_replay"), for: .normal)
        gameoverView.addSubview(replayBtn)
        replayBtn.snp.makeConstraints { (make) in
            make.centerX.equalTo(gameoverBackgroundView)
            make.bottom.equalTo(homeBtn)
        }
        replayBtn.addTarget(self, action: #selector(resetGameToShowAds), for: .touchUpInside)
        replayBtn.tag = 0 // dead
        
        let shareBtn = UIButton(type: .custom)
        shareBtn.setBackgroundImage(UIImage(named: "gameover_share"), for: .normal)
        gameoverView.addSubview(shareBtn)
        shareBtn.snp.makeConstraints { (make) in
            make.right.equalTo(gameoverBackgroundView)
            make.bottom.equalTo(homeBtn)
        }
        shareBtn.addTarget(self, action: #selector(share), for: .touchUpInside)
        
        removeAdsBtn = UIButton(type: .custom)
        gameoverView.addSubview(removeAdsBtn)
        removeAdsBtn.setBackgroundImage(UIImage(named: "remove_ads"), for: .normal)
        removeAdsBtn.snp.makeConstraints({ (make) in
            make.right.bottom.equalTo(-12)
            make.width.height.equalTo(50)
        })
        removeAdsBtn.addTarget(self, action: #selector(removeAdsPressed), for: .touchUpInside)
        removeAdsBtn.isEnabled = false
        
        restoreIAPBtn = UIButton(type: .custom)
        gameoverView.addSubview(restoreIAPBtn)
        restoreIAPBtn.setBackgroundImage(UIImage(named: "restore"), for: .normal)
        restoreIAPBtn.snp.makeConstraints { (make) in
            make.right.equalTo(removeAdsBtn.snp.left).offset(-12)
            make.bottom.equalTo(-12)
            make.width.height.equalTo(50)
        }
        restoreIAPBtn.addTarget(self, action: #selector(restoreIAPPressed), for: .touchUpInside)
        restoreIAPBtn.isEnabled = false
        
        SKPaymentQueue.default().add(self)
        getPurchaseInfo()
    }
    
    @objc func removeAdsPressed() {
        let payment = SKPayment(product: product!)
        SKPaymentQueue.default().add(payment)
    }
    
    @objc func restoreIAPPressed() {
        SKPaymentQueue.default().restoreCompletedTransactions()
        
    }
    
    // delegation
    func gameSceneGameEnded() {
        gameoverView.isHidden = false
    }
    
    // ============================
    //MARK: Admob
    func createInterstitial() -> GADInterstitial? {
        interstitial = GADInterstitial(adUnitID: kAdMobUnitID)
        guard let interstitial = interstitial else {
            return nil
        }
        
        let request = GADRequest()
        //TODO: Remove this before shipping
        request.testDevices = [kGADSimulatorID, kCathyDeviceID, kShellyDeviceID]
        interstitial.load(request)
        
        interstitial.delegate = self
        
        return interstitial
    }
    func interstitialWillPresentScreen(_ ad: GADInterstitial) {
        print("will present ads")
    }
    
    func interstitialDidReceiveAd(_ ad: GADInterstitial) {
        print("Interstitial loaded successfully")
        ad.present(fromRootViewController: self)
    }
    
    func interstitialDidFail(toPresentScreen ad: GADInterstitial) {
        print("Fail to receive interstitial")
    }
    
    func interstitialDidDismissScreen(_ ad: GADInterstitial) {
        resetGame()
    }
    
    // ============================
    
    // IAP
    func getPurchaseInfo() {
        if SKPaymentQueue.canMakePayments() {
            let request = SKProductsRequest(productIdentifiers: NSSet(object: self.productID) as! Set<String>)
            request.delegate = self
            request.start()
        } else {
            print("Can't make payments check settings")
            //TODO: Show alert
        }
    }
    func request(_ request: SKRequest, didFailWithError error: Error) {
        hasInternet = false
        gameScene.hasInternet = false
    }
    
    func productsRequest(_ request: SKProductsRequest, didReceive response: SKProductsResponse) {
        hasInternet = true
        gameScene.hasInternet = true
        let products = response.products
        if products.count == 0 {
            print("No product found")
        } else {
            product = products[0]
            print("title: \(product?.localizedTitle ?? "no title")")
            removeAdsBtn.isEnabled = !UserDefaults.standard.bool(forKey: "UserDefaultPurchaseKey")
            restoreIAPBtn.isEnabled = removeAdsBtn.isEnabled
        }
        
        let invalids = response.invalidProductIdentifiers
        for product in invalids {
            print("product not found: \(product)")
        }
    }
    
    func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        for transaction in transactions {
            switch transaction.transactionState {
            case .purchased:
                queue.finishTransaction(transaction)
                print("Succeed")
                removeAdsBtn.isEnabled = false
                restoreIAPBtn.isEnabled = false
                
                UserDefaults.standard.set(true, forKey: "UserDefaultPurchaseKey")
                UserDefaults.standard.synchronize()
                
                break
            case .failed:
                queue.finishTransaction(transaction)
                removeAdsBtn.isEnabled = true
                print("Failed")
                break
            default:
                print(transaction.transactionState)
                break
            }
        }
    }
    
    func paymentQueue(_ queue: SKPaymentQueue, restoreCompletedTransactionsFailedWithError error: Error) {
        let alert = UIAlertController(title: "Restore Failed",
                                      message: "You have not purchased RemoveAds feature or please check the internet connections",
                                      preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    func paymentQueueRestoreCompletedTransactionsFinished(_ queue: SKPaymentQueue) {
        for transaction in queue.transactions {
            if transaction.transactionState == .restored {
                queue.finishTransaction(transaction)
                print("Restore")
                removeAdsBtn.isEnabled = false
                restoreIAPBtn.isEnabled = false
                
                UserDefaults.standard.set(true, forKey: "UserDefaultPurchaseKey")
                UserDefaults.standard.synchronize()
                let alert = UIAlertController(title: "Restore Succeed",
                                              message: "Ads is now removed",
                                              preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                self.present(alert, animated: true, completion: nil)
                break
            }
        }
    }
    
    // ===============================
    
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

extension UIView {
    
    func takeSnapshot() -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(bounds.size, false, UIScreen.main.scale)
        drawHierarchy(in: self.bounds, afterScreenUpdates: true)
        
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }
}
