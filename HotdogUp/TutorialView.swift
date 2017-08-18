//
//  TutorialView.swift
//  HotdogUp
//
//  Created by Cathy Oun on 8/16/17.
//  Copyright © 2017 Cathy Oun. All rights reserved.
//

import UIKit
import SnapKit

class TutorialView: UIView {
    private var checkbox = Checkbox()
    private var label = UILabel()
    var showCheckbox = true {
        didSet {
            checkbox.isHidden = !showCheckbox
            label.isHidden = !showCheckbox
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = UIColor(hex: "#000000", alpha: 0.8)
        
        
        let jumpAreaView = UIView()
        self.addSubview(jumpAreaView)
        jumpAreaView.snp.makeConstraints { (make) in
            make.center.height.equalTo(self)
            make.width.equalTo(self).multipliedBy(3.0/5.0)
        }
        jumpAreaView.backgroundColor = UIColor(hex: "#2C2C2C", alpha: 0.5)
        
        let imageView = UIImageView(image: UIImage(named: "tutorial"))
        self.addSubview(imageView)
        imageView.snp.makeConstraints { (make) in
            make.edges.equalTo(self)
        }
        
        createCheckbox()
    }
    
    private func createCheckbox() {
        checkbox = Checkbox(frame: CGRect(x: 50, y: 50, width: 25, height: 25))
        self.addSubview(checkbox)
        checkbox.borderColor = UIColor.white
        checkbox.backgroundColor = UIColor.clear
        checkbox.borderWidth = 3.0
        checkbox.borderStyle = .circle
        checkbox.checkmarkStyle = .tick
        checkbox.checkmarkColor = UIColor.white
        checkbox.snp.makeConstraints { (make) in
            make.centerX.equalTo(self).offset(-80)
            make.centerY.equalTo(self)
            make.height.width.equalTo(25)
        }
        checkbox.addTarget(self, action: #selector(checkboxValueChanged(sender:)), for: .valueChanged)
        
        label = UILabel()
        self.addSubview(label)
        label.snp.makeConstraints { (make) in
            make.left.equalTo(checkbox.snp.right).offset(10)
            make.centerY.height.equalTo(checkbox)
        }
        label.textColor = UIColor.white
        label.text = "Do not show this again"
        checkbox.isHidden = false
        label.isHidden = false
        label.font = UIFont(name: "BradleyHandITCTT-Bold", size: 18)
    }
    
    @objc func checkboxValueChanged(sender: Checkbox) {
        UserDefaults.standard.set(sender.isChecked, forKey: "UserDefaultsDoNotShowTutorialKey")
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
