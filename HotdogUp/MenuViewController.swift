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
    @IBOutlet weak var startButton: UIButton!
    @IBOutlet weak var settingsButton: UIButton!
    @IBOutlet weak var helpButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(hex: "#85C5B5")
//        startButton.setImage(UIImage(named:"startClicked"), for: .highlighted)
//        startButton.imageView?.contentMode = .scaleAspectFill
        
//        settingsButton.setImage(UIImage(named: "settingsClicked"), for: .highlighted)
//        helpButton.setImage(UIImage(named:"helpClicked"), for: .highlighted)
    }

    @IBAction func startButtonPressed(_ sender: Any) {
//        let gameVC = GameViewController()
//        self.present(gameVC, animated: true, completion: nil)
    }
    
    @IBAction func settingsButtonPressed(_ sender: Any) {
    }
    
    @IBAction func helpButtonPressed(_ sender: Any) {
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

