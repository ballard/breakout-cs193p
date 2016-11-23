//
//  SettingsTableViewController.swift
//  breakout-cs193p
//
//  Created by Ivan on 07.10.16.
//  Copyright © 2016 Ivan. All rights reserved.
//

import UIKit

class SettingsTableViewController: UITableViewController {
    
    // MARK - constants
    struct Keys {
        static let BricksCount = "Breakout.BricksCount"
        static let Gravity = "Breakout.Gravity"
        static let Elasticity = "Breakout.Elasticity"
        static let BallMoving = "Breakout.BallMoving"
        static let RealGravity = "Breakout.RealGravity"
    }
    
    // MARK - settings init
    let settings = UserDefaults.standard
    
    // MARK - bricks count
    @IBOutlet weak var bricksCountSegmentedControlOutlet: UISegmentedControl! {
        didSet {
            bricksCountSegmentedControlOutlet.selectedSegmentIndex = (bricksCount / 10) - 1
        }
    }
    
    @IBAction func bricksCountSegmentedControlAction(_ sender: UISegmentedControl) {
        bricksCount = (sender.selectedSegmentIndex + 1) * 10
    }
    
    var bricksCount: Int {
        get {
            return settings.object(forKey: Keys.BricksCount) as? Int ?? 30
        }
        set{
            settings.set(newValue, forKey: Keys.BricksCount)
        }
    }
    
    // MARK - gravity
    @IBOutlet weak var gravitySliderOutlet: UISlider! {
        didSet {
            gravitySliderOutlet.value = Float(gravity)
        }
    }
    
    @IBAction func gravitySliderAction(_ sender: UISlider) {
        gravity = CGFloat(sender.value)
    }
    
    var gravity: CGFloat {
        get {
            return settings.object(forKey: Keys.Gravity) as? CGFloat ?? 0.0
        }
        set{
            settings.set(newValue, forKey: Keys.Gravity)
        }
    }
    
    // MARK - elasticity
    @IBOutlet weak var elasticitySliderOutlet: UISlider! {
        didSet {
            elasticitySliderOutlet.value = Float(elasticity)
        }
    }
    @IBAction func elasticitySliderAction(_ sender: UISlider) {
        elasticity = CGFloat(sender.value)
    }
    
    var elasticity: CGFloat {
        get {
            return settings.object(forKey: Keys.Elasticity) as? CGFloat ?? 1.0
        }
        set{
            settings.set(newValue, forKey: Keys.Elasticity)
        }
    }
    
    // MARK - ball moving
    @IBOutlet weak var ballMovingOutlet: UISwitch! {
        didSet {
            ballMovingOutlet.isOn = ballMoving
        }
    }
    
    @IBAction func ballMovingAction(_ sender: UISwitch) {
        ballMoving = sender.isOn
    }
    
    var ballMoving: Bool {
        get {
            return settings.object(forKey: Keys.BallMoving) as? Bool ?? false
        }
        set{
            settings.set(newValue, forKey: Keys.BallMoving)
        }
    }
    
    // MARK - real gravity
    @IBOutlet weak var realGravitySwitchOutlet: UISwitch! {
        didSet {
            realGravitySwitchOutlet.isOn = realGravity
        }
    }
    
    @IBAction func realGravitySwitchAction(_ sender: UISwitch) {
        realGravity = sender.isOn
    }
    
    var realGravity: Bool {
        get {
            return settings.object(forKey: Keys.RealGravity) as? Bool ?? false
        }
        set{
            settings.set(newValue, forKey: Keys.RealGravity)
        }
    }
}
