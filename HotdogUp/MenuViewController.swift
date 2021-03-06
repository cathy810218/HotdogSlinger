//
//  MenuViewController.swift
//  HotdogUp
//
//  Created by Cathy Oun on 5/21/17.
//  Copyright © 2017 Cathy Oun. All rights reserved.
//

import UIKit
import Crashlytics

class MenuViewController: UIViewController {
    var gameVC: GameViewController?
    var characterVC: StoreViewController?    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func startButtonPressed(_ sender: Any) {
        CLSLogv("User hits start button", getVaList([]))
        gameVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "GameViewController") as? GameViewController
        self.present(gameVC!, animated: true, completion: nil)
    }
    @IBAction func helpButtonPressed(_ sender: UIButton) {
        CLSLogv("User hits store button", getVaList([]))
        characterVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "CharacterViewController") as? StoreViewController
        self.present(characterVC!, animated: true, completion: nil)
    }
    
    @IBAction func rateButtonPressed(_ sender: UIButton) {
        CLSLogv("User hits rate button", getVaList([]))
        if let checkURL = URL(string: reviewUrlString) {
            if #available(iOS 10.0, *) {
                UIApplication.shared.open(checkURL, options: [:], completionHandler: { (success) in
                    if !success {
                        print("Fail to go to the App Store")
                    }
                })
            } else {
                // Fallback on earlier versions
                UIApplication.shared.openURL(checkURL)
            }
        } else {
            print("invalid url")
        }
    }
}

extension UIColor {
    convenience init(hex: String, alpha: CGFloat = 1) {
        assert(hex[hex.startIndex] == "#", "Expected hex string of format #RRGGBB")
        
        let scanner = Scanner(string: hex)
        scanner.scanLocation = 1  // skip #
        
        var rgb: UInt32 = 0
        scanner.scanHexInt32(&rgb)
        
        self.init(
            red:   CGFloat((rgb & 0xFF0000) >> 16)/255.0,
            green: CGFloat((rgb &   0xFF00) >>  8)/255.0,
            blue:  CGFloat((rgb &     0xFF)      )/255.0,
            alpha: alpha)
    }
}

