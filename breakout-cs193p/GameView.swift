//
//  GameView.swift
//  breakout-cs193p
//
//  Created by Ivan on 07.10.16.
//  Copyright © 2016 Ivan. All rights reserved.
//

import UIKit

class GameView: NamedBezierPathsView, UIDynamicAnimatorDelegate {
    
    var countLabel : UILabel?
    let countLabelScale = 5
    
    private var countLabelSize : CGSize {
        let size = bounds.size.width / CGFloat(countLabelScale)
        return CGSize(width: size, height: size/2)
    }
    
    private struct PathNames {
        static let Plate = "Plate"
        static let Break = "Break"
    }
    
    private var plateSize : CGSize {
        let size = ballSize.width * 3
        return CGSize(width: size, height: ballSize.height/2)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        if countLabel == nil {
            addCountLabel()
        }
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
        
        for i in 0..<20 {
            
            let heightScale = Int(i / 5)
            let widthScale = Int(i % 5 + 1)
            
            let pathRectCenterX = ((breakWidth) * CGFloat(widthScale)) - breakWidth/2
            let pathRectCenterY = (breakHeight * CGFloat(heightScale)) + breakHeight/2
            
            let path = UIBezierPath(roundedRect: CGRect(center: CGPoint(x: pathRectCenterX, y: pathRectCenterY), size: CGSize(width: breakWidth, height: breakHeight)), cornerRadius: breakHeight/5)
            
            let view = UIView(frame: CGRect(center: CGPoint(x: pathRectCenterX, y: pathRectCenterY), size: CGSize(width: breakWidth, height: breakHeight)))
            
            let breakName = "Break" + String(i)
            
            
            ballBehavior.addBarrier(path: path, named: breakName)
            
            views[breakName] = view
            
            
//            bezierPaths[breakName] = path
        }
        ballBehavior.removeBreak = ({[weak weakSelf = self] (deletingBreak: String) -> Void in
            
            weakSelf?.bezierPaths[deletingBreak] = nil
            })
    }
    
    func addCountLabel(){
        var frame = CGRect(origin: CGPoint.zero, size: countLabelSize)
        frame.origin.x = bounds.size.width - frame.width
        let label = UILabel(frame: frame)
        label.textColor = UIColor.white
        label.text = "Score: 0"
        addSubview(label)
        countLabel = label
        ballBehavior.recordBallHits = ({ [weak weakSelf = self] (inputValue: Int) -> Void in
            weakSelf?.countLabel?.text = "Score: \(inputValue)"
            })
    }
    
    private lazy var animator : UIDynamicAnimator = {[unowned self] in
        let animator = UIDynamicAnimator(referenceView: self)
        animator.delegate = self
        return animator
        }()
    
    var animating : Bool = false {
        didSet{
            if animating {
                animator.addBehavior(ballBehavior)
            } else {
                animator.removeBehavior(ballBehavior )
            }
        }
    }

    private let ballBehavior = BallBehavior()
    
    let ballScale = 10

    private var ballSize : CGSize {
        let size = bounds.size.width / CGFloat(ballScale)
        return CGSize(width: size, height: size)
    }
    
    private var lastBall : UIView?

    func addBall (){
        var frame = CGRect(origin: CGPoint.zero, size: ballSize)
        frame.origin.x = (bounds.size.width / 2) - (frame.width / 2)
        frame.origin.y = bounds.midY
        let ball = UIView(frame: frame)
        ball.layer.cornerRadius = ball.frame.width / 2
        ball.backgroundColor = UIColor.red
        addSubview(ball)
        ballBehavior.addItem(item: ball)
        lastBall = ball
    }
    
    func pushLastBall() {
        let pushBehavior = UIPushBehavior(items: [lastBall!], mode: .instantaneous)
        pushBehavior.magnitude = 0.8
        pushBehavior.angle = CGFloat.random(max: 360)
        pushBehavior.action = {[unowned pushBehavior] in
            pushBehavior.dynamicAnimator!.removeBehavior(pushBehavior)
            
        }
        animator.addBehavior(pushBehavior)
    }
}
