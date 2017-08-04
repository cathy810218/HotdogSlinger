//
//  SettingsViewController.swift
//  HotdogUp
//
//  Created by Cathy Oun on 5/21/17.
//  Copyright © 2017 Cathy Oun. All rights reserved.
//

import UIKit
import GoogleMobileAds

class SettingsViewController: UIViewController, GADInterstitialDelegate {
    var interstitial: GADInterstitial?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        interstitial = createInterstitial()
        // Do any additional setup after loading the view.
    }
    
    func createInterstitial() -> GADInterstitial? {
        interstitial = GADInterstitial(adUnitID: kAdMobUnitID)
        guard let interstitial = interstitial else {
            return nil
        }
        
        let request = GADRequest()
        //TODO: Remove this before shipping
        request.testDevices = [kGADSimulatorID, kCathyDeviceID]
        interstitial.load(request)
        interstitial.delegate = self
        
        return interstitial
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func backgroundMusicSlider(_ sender: Any) {
        
    }
    
    @IBAction func soundEffectSlider(_ sender: Any) {
        
    }
    
    
    @IBAction func settingsButtonPressed(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    func interstitialDidReceiveAd(_ ad: GADInterstitial) {
        print("Interstitial loaded successfully")
        ad.present(fromRootViewController: self)
    }
    
    func interstitialDidFail(toPresentScreen ad: GADInterstitial) {
        print("Fail to receive interstitial")
    }
}
