//
//  BallBehavior.swift
//  breakout-cs193p
//
//  Created by Ivan on 08.10.16.
//  Copyright © 2016 Ivan. All rights reserved.
//

import UIKit

class BallBehavior: UIDynamicBehavior, UICollisionBehaviorDelegate {
    
    var ballHits = 0
    
    var recordBallHits : ((Int) -> Void)?
    
    let gravity = UIGravityBehavior() //better some public API
    
    let collider : UICollisionBehavior = {
        let collider = UICollisionBehavior()
        collider.translatesReferenceBoundsIntoBoundary = true
        return collider
    }()
    
    private let itemBehavior : UIDynamicItemBehavior = {
        let itemBehavior = UIDynamicItemBehavior()
        itemBehavior.elasticity = 1
//        itemBehavior.allowsRotation = false
        return itemBehavior
    }()
    
    func addBarrier(path: UIBezierPath, named name: String){
        collider.removeBoundary(withIdentifier: name as NSCopying)
        collider.addBoundary(withIdentifier: name as NSCopying, for: path)
    }
    
    
    
    func collisionBehavior(_ behavior: UICollisionBehavior,
                           beganContactFor item: UIDynamicItem,
                           withBoundaryIdentifier identifier: NSCopying?,
                           at p: CGPoint) {
        ballHits += 1
        recordBallHits?(ballHits)
        print("hit")
    }
    
    override init(){
        super.init()
        addChildBehavior(gravity)
        addChildBehavior(collider)
        addChildBehavior(itemBehavior)
        collider.collisionDelegate = self
    }
    
    func addItem(item : UIDynamicItem) {
        gravity.addItem(item)
        collider.addItem(item)
        itemBehavior.addItem(item)
    }
    
    func removeItem(item : UIDynamicItem){
        gravity.removeItem(item)
        collider.removeItem(item)
        itemBehavior.removeItem(item)
    }

}
