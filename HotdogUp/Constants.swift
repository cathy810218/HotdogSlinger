//
//  Constants.swift
//  HotdogUp
//
//  Created by Cathy Oun on 7/31/17.
//  Copyright © 2017 Cathy Oun. All rights reserved.
//

import UIKit
import SpriteKit

let kMinJumpHeight: Int = Int(UIScreen.main.bounds.size.height / 5.0)
let kMaxJumpHeight: Int = 180
let kJumpIntensity: Int = 30
let kHotdogMoveVelocityIncrement: CGFloat = 6.0
let kNumOfStairsToUpdate: Int = 1 // multiply by 5 = stairs when update

let kGameSpeed: CGFloat = 1.2
let kSpeedIncrement: CGFloat = UIDevice.current.userInterfaceIdiom == .pad ? 0.06 : 0.08
let kLevel: Int = 10
