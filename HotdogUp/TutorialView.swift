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
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor(hex: "#000000", alpha: 0.8)
        
        let jumpAreaView = UIView()
        self.addSubview(jumpAreaView)
        jumpAreaView.snp.makeConstraints { (make) in
            make.center.height.equalTo(self)
            make.width.equalTo(self).multipliedBy(3.0/5.0)
        }
        jumpAreaView.backgroundColor = UIColor.red
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
