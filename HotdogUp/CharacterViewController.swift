//
//  CharacterViewController.swift
//  HotdogUp
//
//  Created by Cathy Oun on 8/19/17.
//  Copyright © 2017 Cathy Oun. All rights reserved.
//

import UIKit
import SnapKit

class CharacterViewController: UIViewController {
    
    var priceCTABtn = UIButton()
    @IBOutlet weak var doneBtn: UIButton!
    var characterImageView = UIImageView()
    override func viewDidLoad() {
        createCharacterImageView()
        createArrowButtons()
        createCTAButton()
        super.viewDidLoad()
        doneBtn.titleLabel?.font = UIFont(name: "BradleyHandITCTT-Bold", size: 16)
        doneBtn.titleLabel?.textColor = UIColor.black
        // Do any additional setup after loading the view.
    }
    
    func createCharacterImageView() {
        let img = UIImage(named: "store_jane_image")!
        let ratio = img.size.width / img.size.height
        characterImageView = UIImageView(image: img)
        self.view.addSubview(characterImageView)
        characterImageView.snp.makeConstraints { (make) in
            make.center.equalTo(self.view)
            make.width.equalTo(2 * self.view.bounds.size.width / 3)
            make.height.equalTo(2 * self.view.bounds.size.width / 3 / ratio)
        }
    }
    
    func createArrowButtons() {
        let left = UIButton(type: .custom)
        left.setBackgroundImage(UIImage(named: "previous"), for: .normal)
        self.view.addSubview(left)
        left.snp.makeConstraints { (make) in
            make.centerY.equalTo(self.view)
            make.width.height.equalTo(50)
            make.right.equalTo(characterImageView.snp.left).offset(-10)
        }
        let right = UIButton(type: .custom)
        right.setBackgroundImage(UIImage(named: "next"), for: .normal)
        self.view.addSubview(right)
        right.snp.makeConstraints { (make) in
            make.centerY.equalTo(self.view)
            make.width.height.equalTo(50)
            make.left.equalTo(characterImageView.snp.right).offset(10)
        }
    }
    
    func createCTAButton() {
        priceCTABtn = UIButton(type: .custom)
        let img = UIImage(named: "free")!
        let ratio = img.size.height / img.size.width
        priceCTABtn.setBackgroundImage(img, for: .normal)
        self.view.addSubview(priceCTABtn)
        priceCTABtn.snp.makeConstraints { (make) in
            make.centerX.equalTo(self.view)
            make.width.equalTo(150.0)
            make.height.equalTo(150.0 * ratio)
            make.bottom.equalTo(characterImageView.snp.top).offset(-10)
        }
    }
    
    @IBAction func doneButtonPressed(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func selectWomanHotdog(_ sender: Any) {
        UserDefaults.standard.set(1, forKey: "UserDefaultsSelectCharacterKey")
    }
    
    
    @IBAction func selectManHotdog(_ sender: Any) {
        UserDefaults.standard.set(0, forKey: "UserDefaultsSelectCharacterKey")
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
