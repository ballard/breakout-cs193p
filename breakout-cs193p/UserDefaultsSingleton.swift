//
//  UserDefaultsSingleton.swift
//  breakout-cs193p
//
//  Created by Ivan on 19.10.16.
//  Copyright © 2016 Ivan. All rights reserved.
//

import Foundation


class UserDefaultsSingleton {
    
    struct Keys{
        static let BricksCount = "Breakout.BricksCount"
        static let Gravity = "Breakout.Gravity"
        static let Elasticity = "Breakout.Elasticity"
    }
    
    static let sharedInstance = UserDefaultsSingleton()
    
    var defaults : UserDefaults?
    
    init() {
        defaults = UserDefaults.standard
    }
}
