//
//  GameView.swift
//  breakout-cs193p
//
//  Created by Ivan on 07.10.16.
//  Copyright © 2016 Ivan. All rights reserved.
//

import UIKit
import CoreMotion

class GameView: NamedBezierPathsView, UIDynamicAnimatorDelegate {

    // TODO
    // + decrease score if ball hits bottom
    // + cooldown of tap gesture
    // - consider using of DI instead of singleton for user settings
    
    lazy var userDefaults: UserDefaultsSingleton = {
        return UserDefaultsSingleton.sharedInstance
    }()
    
    // MARK - settings restore
    override func layoutSubviews() {
        super.layoutSubviews()
        ballBehavior.setMagnitude(magnitude: gravityValue!)
        ballBehavior.setElasticity(elasticity: elasticityValue!)
        ballBehavior.setAllowsRotation(allowsRotation: ballMoving!)
        ballBehavior.setAngle(angle: 90 * CGFloat(M_PI) / 180)
    }
    
    private var gravityValue: CGFloat? {
        get {
            return userDefaults.defaults!.object(
//            return UserDefaultsSingleton.sharedInstance.defaults!.object(
                forKey: UserDefaultsSingleton.Keys.Gravity) as? CGFloat ?? 0.0
        }
    }
    
    private var elasticityValue: CGFloat? {
        get {
            return userDefaults.defaults!.object(
                forKey: UserDefaultsSingleton.Keys.Elasticity) as? CGFloat ?? 1.0
        }
    }
    
    private var ballMoving: Bool? {
        get {
            return userDefaults.defaults!.object(
                forKey: UserDefaultsSingleton.Keys.BallMoving) as? Bool ?? false
        }
    }
    
    private var realGravity: Bool? {
        get {
            return userDefaults.defaults!.object(
                forKey: UserDefaultsSingleton.Keys.RealGravity) as? Bool ?? false
        }
    }
    
    private var bricksCount: Int {
        get {
            return userDefaults.defaults!.object(
                forKey: UserDefaultsSingleton.Keys.BricksCount) as? Int ?? 30
        }
    }

    // MARK - clear the game for start
    func prepareForGameStart() {
        // clear
        if doubleViews.count > 0 {
            for (_, doubleView) in doubleViews {
                doubleView.view.removeFromSuperview()
            }
        }
        doubleViews = [:]
        ballBehavior.resetBallBehavior()
        breaksCount = 0
        if let ball = gameBall {
            ballBehavior.removeItem(item: ball)
            ball.removeFromSuperview()
        }
        // fill
        isDoubleViewsBuilded = false
        addBreaks()
        isDoubleViewsBuilded = true
        addBottomBoundary()
        addBall()
        if breaksCountLabel != nil {
            self.bringSubview(toFront: breaksCountLabel!)
        } else {
            addCountLabel()
        }
    }
    
    // MARK - game over closure
    var gameOver: ((Void) -> Void)?
    
    // MARK - score
    var breaksCount: Int = 0 {
        didSet{
            breaksCountLabel?.text = "Score: \(breaksCount)"
            if let ball = gameBall {
                print("ball velocity: \(ballBehavior.getItemVelocity(item: ball))")
            }
        }
    }
    
    // MARK - game score label setup
    var breaksCountLabel : UILabel?
    let countLabelScale = 5
    private var countLabelSize : CGSize {
        let size = bounds.size.width / CGFloat(countLabelScale) * 2
        return CGSize(width: size / 3 * 2, height: size / 4)
    }
    
    func addCountLabel() {
        var frame = CGRect(origin: CGPoint.zero, size: countLabelSize)
        frame.origin.x = bounds.size.width - frame.width
        let label = UILabel(frame: frame)
        label.textColor = UIColor.white
        label.text = "Score: 0"
        addSubview(label)
        breaksCountLabel = label
        //        ballBehavior.recordBallHits = ({ [weak weakSelf = self] (inputValue: Void) -> Void in
        //            weakSelf?.breaksCount += 1
        //            })
    }
    
    
    // MARK - plate and bricks setup
    private struct PathNames {
        static let Plate = "Plate"
        static let Break = "Break"
        static let Bottom = "Bottom"
    }
    
    private var plateSize : CGSize {
        let size = ballSize.width * 3
        return CGSize(width: size, height: ballSize.height/2)
    }
    
    func movePlate(toXPoint xPoint: CGFloat) {
        if bezierPaths[PathNames.Plate] != nil {
            bezierPaths[PathNames.Plate] = nil
        }
        
        let path = UIBezierPath(ovalIn: CGRect(center: CGPoint(x: xPoint, y:bounds.maxY - plateSize.height), size: plateSize))
        ballBehavior.addBarrier(path: path, named: PathNames.Plate)
        bezierPaths[PathNames.Plate] = path
    }
    
    func addBreaks() {
        if bezierPaths[PathNames.Break] != nil {
            bezierPaths[PathNames.Break] = nil
        }
        let breakWidth = ballSize.width * 2
        let breakHeight = ballSize.height
        
        print("ball moving: \(ballMoving!)")
        
        for i in 0..<bricksCount {
            
            let heightScale = Int(i / 5)
            let widthScale = Int(i % 5 + 1)
            
            let pathRectCenterX = ((breakWidth) * CGFloat(widthScale)) - breakWidth/2
            let pathRectCenterY = (breakHeight * CGFloat(heightScale)) + breakHeight/2
            
            let path = UIBezierPath(roundedRect: CGRect(center: CGPoint(x: pathRectCenterX, y: pathRectCenterY), size: CGSize(width: breakWidth, height: breakHeight)), cornerRadius: breakHeight/5)
            
            let view = UIView(frame: CGRect(center: CGPoint(x: pathRectCenterX, y: pathRectCenterY), size: CGSize(width: breakWidth, height: breakHeight)))
            
            let breakName = "Break" + String(i)
            
            var hits = false
            if i % 2 == 0 {
                hits = true
            }
            
            ballBehavior.addBarrier(path: path, named: breakName)
            
            let doubleView = DoubleView(hits: hits, view: view, path: path)
            doubleViews[breakName] = doubleView
        }
        
        ballBehavior.removeBreak = ({[weak weakSelf = self] (deletingBreak: String) -> Void in
            
            if let rotating = weakSelf?.ballMoving, rotating == true {
                weakSelf?.pushLastBall(angle: CGFloat.random(max: 360) * CGFloat(M_PI) / 180)
            }
            
            if let brick = weakSelf?.doubleViews[deletingBreak] {
                
                if !brick.hits {
                    weakSelf?.breaksCount += 1
                    UIView.transition(
                        with: brick.view,
                        duration: 0.5,
                        options: [.transitionFlipFromTop,.curveLinear],
                        animations: nil,
                        completion: { completion in
                            weakSelf?.doubleViews[deletingBreak]!.view.removeFromSuperview()
//                            weakSelf?.doubleViews[deletingBreak] = nil
                            _ = weakSelf?.doubleViews.removeValue(forKey: deletingBreak)
//                            print(weakSelf?.doubleViews.count)
                            if weakSelf?.doubleViews.count == 0 {
                                weakSelf?.gameOver?()
                            }
                        }
                    )
                } else {
                    weakSelf?.doubleViews[deletingBreak]?.hits = false
                    weakSelf?.doubleViews[deletingBreak]?.view.backgroundColor = UIColor.purple
                    weakSelf?.ballBehavior.addBarrier(path: brick.path, named: deletingBreak)
                    print("double brick hitted, named: \(deletingBreak)")
                }
            }
        })
    }
    
    // MARK - bottom setup
    func addBottomBoundary() {
        ballBehavior.collider.addBoundary(withIdentifier: PathNames.Bottom as NSCopying, from: CGPoint(x: bounds.minX, y: bounds.maxY), to: CGPoint(x: bounds.maxX, y: bounds.maxY))
        ballBehavior.hitBottom = ({ [weak weakSelf = self] in
            weakSelf?.breaksCount -= 1
        })
        
    }
    
    
    // MARK - animator setup
    private lazy var animator : UIDynamicAnimator = {[unowned self] in
        let animator = UIDynamicAnimator(referenceView: self)
        animator.delegate = self
        return animator
        }()
    
    var animating : Bool = false {
        didSet{
            if animating {
                animator.addBehavior(ballBehavior)
                updateRealGravity()
            } else {
                animator.removeBehavior(ballBehavior)
            }
        }
    }
    
    // MARK - ball setup
    let ballBehavior = BallBehavior()
    
    let ballScale = 10
    
    private var ballSize : CGSize {
        let size = bounds.size.width / CGFloat(ballScale)
        return CGSize(width: size, height: size)
    }
    
    var gameBall : UIView?

    func addBall (){
        var frame = CGRect(origin: CGPoint.zero, size: ballSize)
        frame.origin.x = (bounds.size.width / 2) - (frame.width / 2)
        frame.origin.y = bounds.midY
        let ball = RoundedUIView(frame: frame)
        ball.layer.cornerRadius = ball.frame.width / 2
        ball.backgroundColor = UIColor.red
        addSubview(ball)
        ballBehavior.addItem(item: ball)
        gameBall = ball
        
    }
    
    func pushLastBall(angle: CGFloat) {
        let pushBehavior = UIPushBehavior(items: [gameBall!], mode: .instantaneous)
        pushBehavior.magnitude = 0.3
        pushBehavior.angle = angle//CGFloat.random(max: 360)
        pushBehavior.action = {[unowned pushBehavior] in
            pushBehavior.dynamicAnimator!.removeBehavior(pushBehavior)
        }
        animator.addBehavior(pushBehavior)
    }
    
    // MARK - real gravity setup
    private let motionManager = CMMotionManager()
    
    private func updateRealGravity(){
        if realGravity! {
            if motionManager.isAccelerometerAvailable && !motionManager.isAccelerometerActive {
                motionManager.accelerometerUpdateInterval = 0.25
                motionManager.startAccelerometerUpdates(to: OperationQueue.main) {
                    [unowned self ] (data, error) in
                    
                    if self.ballBehavior.dynamicAnimator != nil{
                        if var dx = data?.acceleration.x, var dy = data?.acceleration.y {
                            switch UIDevice.current.orientation {
                            case .portrait: dy = -dy
                            case .portraitUpsideDown: break
                            case .landscapeLeft: swap(&dx, &dy); dy = -dy
                            case .landscapeRight: swap(&dx, &dy)
                            default: dx = 0; dy = 0
                            }
                            self.ballBehavior.gravity.gravityDirection = CGVector(dx: dx, dy: dy)
                        }
                    } else {
                        self.motionManager.stopAccelerometerUpdates()
                    }
                }
            }
        } else {
            motionManager.stopAccelerometerUpdates()
        }
    }
}
