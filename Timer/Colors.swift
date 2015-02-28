//
//  colors.swift
//  Timer
//
//  Created by Qi Junyuan on 2/28/15.
//  Copyright (c) 2015 Qi Junyuan. All rights reserved.
//

import Foundation
import UIKit

class Colors {
    let colorTop = UIColor(red: 45/255, green: 151/255, blue: 241/255, alpha: 1).CGColor
    let colorBottom = UIColor(red: 135/255, green: 215/255, blue: 246/255, alpha: 1).CGColor
    let gradientLayer: CAGradientLayer
    
    init() {
        gradientLayer = CAGradientLayer()
        gradientLayer.colors = [colorTop, colorBottom]
        gradientLayer.locations = [0,1]
    }
}