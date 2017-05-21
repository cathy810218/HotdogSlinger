//
//  MenuViewController.swift
//  HotdogSlinger
//
//  Created by Cathy Oun on 5/21/17.
//  Copyright © 2017 Cathy Oun. All rights reserved.
//

import UIKit

class MenuViewController: UIViewController {
    @IBOutlet weak var startButton: UIButton!
    @IBOutlet weak var settingsButton: UIButton!
    @IBOutlet weak var helpButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        startButton.setImage(UIImage(named:"startClicked"), for: .highlighted)
        startButton.imageView?.contentMode = .scaleAspectFill
        
        settingsButton.setImage(UIImage(named: "settingsClicked"), for: .highlighted)
        helpButton.setImage(UIImage(named:"helpClicked"), for: .highlighted)
    }

    @IBAction func startButtonPressed(_ sender: Any) {
    }
    
    @IBAction func settingsButtonPressed(_ sender: Any) {
    }
    
    @IBAction func helpButtonPressed(_ sender: Any) {
    }
}
