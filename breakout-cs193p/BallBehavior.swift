//
//  BallBehavior.swift
//  breakout-cs193p
//
//  Created by Ivan on 08.10.16.
//  Copyright © 2016 Ivan. All rights reserved.
//

import UIKit

class BallBehavior: UIDynamicBehavior, UICollisionBehaviorDelegate {
    
    // callback closures
//    var recordBallHits : ((Void) -> Void)?
    var removeBreak: ((String) -> Void)?
    var hitBottom : ((UIView) -> Void)?
    
    let gravity : UIGravityBehavior = {
        let gravity = UIGravityBehavior()
        gravity.magnitude = 0.0
        gravity.angle = 90 * CGFloat(M_PI) / 180
        return gravity
    }()
    
    let collider : UICollisionBehavior = {
        let collider = UICollisionBehavior()
        collider.translatesReferenceBoundsIntoBoundary = true
        return collider
    }()
    
    func resetBallBehavior(){
        _ = gravity.items.map { gravity.removeItem($0) }
        _ = collider.items.map { collider.removeItem($0) }
        _ = itemBehavior.items.map { itemBehavior.removeItem($0) }
        _ = collider.boundaryIdentifiers?.map { collider.removeBoundary(withIdentifier: $0) }
    }
    
    let itemBehavior : UIDynamicItemBehavior = {
        let itemBehavior = UIDynamicItemBehavior()
        itemBehavior.elasticity = 1
        itemBehavior.resistance = 0
        itemBehavior.allowsRotation = false
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
        if let boundary = identifier as? String {
            if boundary.hasPrefix("Break") {
                collider.removeBoundary(withIdentifier: boundary as NSCopying)
                //            recordBallHits?()
                removeBreak?(boundary)
            } else if boundary == "Bottom" {
                
                print("gotcha")
                hitBottom?(item as! UIView)
            }
        }
    }
    
    override init() {
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
    
    func removeItem(item : UIDynamicItem) {
        gravity.removeItem(item)
        collider.removeItem(item)
        itemBehavior.removeItem(item)
    }
}
