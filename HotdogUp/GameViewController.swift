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
import Crashlytics

class GameViewController: UIViewController, GameSceneDelegate, PauseViewDelegate, GameoverViewDelegate, GADInterstitialDelegate, SKPaymentTransactionObserver, SKProductsRequestDelegate {
    
    var pauseView = PauseView()
    var pauseBtn = UIButton()
    var tutorialView = TutorialView()

    var gameScene : GameScene!
    var skView = SKView()
    var gameoverView = GameoverView()
    
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
        if UserDefaults.standard.object(forKey: "UserDefaultsIsMusicOnKey") == nil {
            UserDefaults.standard.set(true, forKey: "UserDefaultsIsMusicOnKey")
        }
        
        if UserDefaults.standard.object(forKey: "UserDefaultsIsSoundEffectOnKey") == nil {
            UserDefaults.standard.set(true, forKey: "UserDefaultsIsSoundEffectOnKey")
        }
        
        gameScene = GameScene(size: view.bounds.size)
        gameScene.scaleMode = .resizeFill
        gameScene.gameSceneDelegate = self
        setupPauseView()
        setupGameOverView()
        
        pauseBtn = UIButton(type: .custom)
        let pauseImg = UIImage(named: "button_pause")
        pauseBtn.setBackgroundImage(pauseImg, for: .normal)
        self.view?.addSubview(pauseBtn)
        pauseBtn.addTarget(self, action: #selector(pauseButtonDidPressed), for: .touchUpInside)
        pauseBtn.snp.makeConstraints { (make) in
            make.top.left.equalTo(30)
            make.width.height.equalTo((pauseImg?.size.width)!)
        }
        setupTutorialView()
        SKPaymentQueue.default().add(self)
        getPurchaseInfo()
        
        if !UserDefaults.standard.bool(forKey: "UserDefaultsDoNotShowTutorialKey") {
            tutorialView.isHidden = false
            
            gameScene.isUserInteractionEnabled = false
            tutorialView.showCheckbox = true
        }
        
        NotificationCenter.default.addObserver(self, selector: #selector(pauseButtonDidPressed), name: Notification.Name.UIApplicationDidEnterBackground, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(pauseButtonDidPressed), name: Notification.Name.UIApplicationWillResignActive, object: nil)
    }
    
    func presentGameScene() {
        skView = view as! SKView
//        skView.showsFPS = true
//        skView.showsPhysics = true
//        skView.showsNodeCount = true
        skView.ignoresSiblingOrder = true
        skView.presentScene(gameScene)
    }
    
    func setupPauseView() {
        pauseView = PauseView(frame: self.view.frame)
        self.view.addSubview(pauseView)
        pauseView.isHidden = true
        pauseView.delegate = self
    }
    
    @objc func pauseButtonDidPressed() {
        print("pause view shown")
        UserDefaults.standard.set(gameScene.speed, forKey: "UserDefaultsResumeSpeedKey")
        gameScene.gamePaused = true
        MusicPlayer.player.pause()
        pauseView.isHidden = false
        gameScene.isUserInteractionEnabled = false
        pauseBtn.isEnabled = false // disable it
    }
    
    func setupTutorialView() {
        tutorialView = TutorialView(frame: self.view.frame)
        self.view.addSubview(tutorialView)
        tutorialView.isHidden = true
        let tap = UITapGestureRecognizer(target: self, action: #selector(tapToDismissTutorialView))
        tutorialView.addGestureRecognizer(tap)
    }
    
    @objc func tapToDismissTutorialView() {
        tutorialView.isHidden = true
        gameScene.isUserInteractionEnabled = true
    }

    //MARK: PauseViewDelegate
    func pauseViewDidPressHomeButton() {
        returnToMenu()
    }
    
    func pauseViewDidPressResumeButton() {
        gameScene.speed = CGFloat(UserDefaults.standard.float(forKey: "UserDefaultsResumeSpeedKey"))
        gameScene.gamePaused = false
        gameScene.isReset = false
        gameScene.isMusicOn = UserDefaults.standard.bool(forKey: "UserDefaultsIsMusicOnKey")
        pauseView.isHidden = true
        pauseBtn.isEnabled = true
        gameScene.isUserInteractionEnabled = true
    }
    
    func pauseViewDidPressReplayButton() {
        resetGame()
    }
    
    func pauseViewDidPressSoundButton() {
        // check if sound is on or off
        gameScene.isSoundEffectOn = !gameScene.isSoundEffectOn
        UserDefaults.standard.set(gameScene.isSoundEffectOn, forKey: "UserDefaultsIsSoundEffectOnKey")
        pauseView.isSoundOn = gameScene.isSoundEffectOn
    }
    
    func pauseViewDidPressMusicButton() {
        gameScene.isMusicOn = !gameScene.isMusicOn
        UserDefaults.standard.set(gameScene.isMusicOn, forKey: "UserDefaultsIsMusicOnKey")
        pauseView.isBackgroundMusicOn = gameScene.isMusicOn
    }
    
    func pauseViewDidPressTutorialButton() {
        tutorialView.isHidden = false
        tutorialView.showCheckbox = false
        gameScene.isUserInteractionEnabled = false
    }
    
    // ============================
    
    //Mark: GameoverViewDelegate
    func gameoverViewDidPressShareButton() {
        let score : String = gameScene.scoreLabel.text ?? "0"
        
        //Generate the screenshot
        UIGraphicsBeginImageContext(view.frame.size)
        let context: CGContext = UIGraphicsGetCurrentContext()!
        view.layer.render(in: context)
        let screenshot = view.takeSnapshot()
        socialShare(sharingText: "🌭 I just hit \(score) on HotdogUp! Beat it! 🌭\n\n\n\(shareToAppStoreURL)",
            sharingImage: screenshot)
        CLSLogv("User pressed share", getVaList([]))
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
        activityVC.excludedActivityTypes = [.addToReadingList,
                                            .airDrop,
                                            .assignToContact,
                                            .copyToPasteboard,
                                            .openInIBooks,
                                            .postToVimeo,
                                            .saveToCameraRoll,
                                            .print]
        if UIDevice.current.userInterfaceIdiom == .phone {
            self.present(activityVC, animated: true, completion: nil)
        } else {
            activityVC.popoverPresentationController?.sourceView = gameoverView.shareBtn
            activityVC.popoverPresentationController?.sourceRect = CGRect(x: gameoverView.shareBtn.bounds.width / 2,
                                                                          y: gameoverView.shareBtn.bounds.height,
                                                                          width: 0,
                                                                          height: 0)
            activityVC.popoverPresentationController?.permittedArrowDirections = .up
            self.present(activityVC, animated: true, completion: nil)
        }
        
    }
    
    func gameoverViewDidPressReplayButton() {
        gameoverView.isHidden = true
        if !UserDefaults.standard.bool(forKey: "UserDefaultsPurchaseKey") && hasInternet {
            interstitial = createInterstitial()
        } else {
            resetGame()
        }
    }
    
    func gameoverViewDidPressHomeButton() {
        returnToMenu()
    }
    
    func gameoverViewDidPressRemoveAds() {
        if let product = product {
            let payment = SKPayment(product: product)
            SKPaymentQueue.default().add(payment)
        } else {
            let alert = UIAlertController(title: "Error", message: "Something is wrong! Please try again.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    func gameoverViewDidPressRestore() {
        SKPaymentQueue.default().restoreCompletedTransactions()
    }
    
    // ===================================
    
    func returnToMenu() {
        gameScene.removeAllChildren()
        gameScene.removeFromParent()
        skView.presentScene(nil)
        MusicPlayer.player.stop()
        self.dismiss(animated: true, completion: nil)
    }
    
    func resetGame() {
        gameScene.resetGameScene()
        pauseView.isHidden = true
        pauseBtn.isEnabled = true
    }
    
    func setupGameOverView() {
        gameoverView = GameoverView(frame: self.view.frame)
        self.view.addSubview(gameoverView)
        gameoverView.isHidden = true
        gameoverView.delegate = self
    }
    
    //MARK: GameSceneDelegate
    // this delegate method trigger when game is over
    func gameSceneGameEnded() {
        gameoverView.isHidden = false
        pauseBtn.isEnabled = false
    }
    
    // ============================
    //MARK: Admob
    func createInterstitial() -> GADInterstitial? {
        interstitial = GADInterstitial(adUnitID: kAdMobUnitID)
        guard let interstitial = interstitial else {
            return nil
        }
        
        let request = GADRequest()
//        //TODO: Remove this before shipping
//        request.testDevices = [kGADSimulatorID, kCathyDeviceID, kShellyDeviceID, "ad8874fc8d181c031955fe3c07e5c7e7"]
        interstitial.load(request)
        
        interstitial.delegate = self
        
        return interstitial
    }
    
    func interstitialDidReceiveAd(_ ad: GADInterstitial) {
        print("Interstitial loaded successfully")
        ad.present(fromRootViewController: self)
    }
    
    func interstitialDidFail(toPresentScreen ad: GADInterstitial) {
        print("Fail to receive interstitial")
        resetGame()
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
            let alert = UIAlertController(title: "Error", message: "Can't make payment. Please check Settings.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
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
            gameoverView.removeAdsBtn.isEnabled = !UserDefaults.standard.bool(forKey: "UserDefaultsPurchaseKey")
            gameoverView.restoreIAPBtn.isEnabled = gameoverView.removeAdsBtn.isEnabled
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
                gameoverView.removeAdsBtn.isEnabled = false
                gameoverView.restoreIAPBtn.isEnabled = false
                Answers.logPurchase(withPrice: 0.99,
                                    currency: "USD",
                                    success: true,
                                    itemName: "RemoveAds",
                                    itemType: "Ads",
                                    itemId: "com.hotdogup.removeads",
                                    customAttributes: nil)
                UserDefaults.standard.set(true, forKey: "UserDefaultsPurchaseKey")
                UserDefaults.standard.synchronize()
                break
            case .failed:
                queue.finishTransaction(transaction)
                gameoverView.removeAdsBtn.isEnabled = true
                CLSLogv("User failed to purchase removeAds", getVaList([]))
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
                                      message: "We are unable to restore your purchase.",
                                      preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    func paymentQueueRestoreCompletedTransactionsFinished(_ queue: SKPaymentQueue) {
        for transaction in queue.transactions {
            if transaction.transactionState == .restored {
                queue.finishTransaction(transaction)
                print("Restore")
                gameoverView.removeAdsBtn.isEnabled = false
                gameoverView.restoreIAPBtn.isEnabled = false
                
                UserDefaults.standard.set(true, forKey: "UserDefaultsPurchaseKey")
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
    
    deinit {
        SKPaymentQueue.default().remove(self)
        NotificationCenter.default.removeObserver(self, name: Notification.Name.UIApplicationWillResignActive, object: nil)
        NotificationCenter.default.removeObserver(self, name: Notification.Name.UIApplicationDidEnterBackground, object: nil)
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
