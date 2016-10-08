//
//  GameView.swift
//  breakout-cs193p
//
//  Created by Ivan on 07.10.16.
//  Copyright © 2016 Ivan. All rights reserved.
//

import UIKit

class GameView: UIView, UIDynamicAnimatorDelegate {
    
    var countLabel : UILabel?
    let countLabelScale = 10
    
    private var countLabelSize : CGSize {
        let size = bounds.size.width / CGFloat(countLabelScale)
        return CGSize(width: size, height: size)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        if countLabel == nil {
            addCountLabel()
        }
    }
    
    func addCountLabel(){
        var frame = CGRect(origin: CGPoint.zero, size: countLabelSize)
        frame.origin.x = bounds.size.width - frame.width
        let label = UILabel(frame: frame)
        addSubview(label)
        countLabel = label
        ballBehavior.recordBallHits = ({ [weak weakSelf = self] (inputValue: Int) -> Void in
            weakSelf?.countLabel?.text = String(inputValue)
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
