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
    
    lazy var settingsController : SettingsTableViewController = {
       return SettingsTableViewController()
    }()

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
        
        _ = allGameBalls.map { ball in
            ballBehavior.removeItem(item: ball)
            ball.removeFromSuperview()
        }
        allGameBalls.removeAll()
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
            if breaksCount % 10 == 0, breaksCount > 0 {
                addBall()
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
        
        var newXPoint = xPoint
        if newXPoint < plateSize.width / 2 {
            newXPoint = plateSize.width / 2
        } else if newXPoint > self.bounds.maxX - plateSize.width / 2 {
            newXPoint = self.bounds.maxX - plateSize.width / 2
        }
        
        let path = UIBezierPath(ovalIn: CGRect(center: CGPoint(x: newXPoint, y:bounds.maxY - plateSize.height), size: plateSize))
        ballBehavior.addBarrier(path: path, named: PathNames.Plate)
        bezierPaths[PathNames.Plate] = path
    }
    
    func addBreaks() {
        if bezierPaths[PathNames.Break] != nil {
            bezierPaths[PathNames.Break] = nil
        }
        let breakWidth = ballSize.width * 2
        let breakHeight = ballSize.height
        
        print("ball moving: \(settingsController.ballMoving)")
        
        for i in 0..<settingsController.bricksCount {
            
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
            
            if let rotating = weakSelf?.settingsController.ballMoving, rotating == true {
                weakSelf?.pushBalls(angle: CGFloat.random(max: 360) * CGFloat(M_PI) / 180)
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
//        ballBehavior.hitBottom = { [weak weakSelf = self] in
//            weakSelf?.breaksCount -= 1
//        }
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
    
    public var allGameBalls = [UIView]()
    
    func addBall() {
        var frame = CGRect(origin: CGPoint.zero, size: ballSize)
        frame.origin.x = (bounds.size.width / 2) - (frame.width / 2)
        frame.origin.y = bounds.midY
        let ball = RoundedUIView(frame: frame)
        ball.layer.cornerRadius = ball.frame.width / 2
        ball.backgroundColor = UIColor.red
        addSubview(ball)
        ballBehavior.addItem(item: ball)
        allGameBalls.append(ball)
        
        ballBehavior.hitBottom = { [weak weakSelf = self] ball in
            weakSelf?.ballBehavior.removeItem(item: ball)
            ball.removeFromSuperview()
            weakSelf?.allGameBalls = (weakSelf?.allGameBalls)!.filter { storedBall in
                return storedBall != ball
            }
            if weakSelf?.allGameBalls.count == 0 {
                weakSelf?.gameOver?()
            }
        }
    }
    
    func pushBalls(angle: CGFloat) {
        _ = allGameBalls.map { ball in
            self.push(ball: ball, forAngle: angle)
        }
    }
    
    private func push(ball: UIView, forAngle angle: CGFloat) {
        let pushBehavior = UIPushBehavior(items: [ball], mode: .instantaneous)
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
        if settingsController.realGravity {
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
