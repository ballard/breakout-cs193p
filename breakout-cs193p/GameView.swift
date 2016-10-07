//
//  GameView.swift
//  breakout-cs193p
//
//  Created by Ivan on 07.10.16.
//  Copyright © 2016 Ivan. All rights reserved.
//

import UIKit

class GameView: UIView, UIDynamicAnimatorDelegate {
    
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
