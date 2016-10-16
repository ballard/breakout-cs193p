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
    var recordBallHits : ((Void) -> Void)?
    var removeBreak: ((String) -> Void)?
    
    let gravity : UIGravityBehavior = {
        let gravity = UIGravityBehavior()
        gravity.magnitude = 0.5
        return gravity
    }() //better some public API
    
    let collider : UICollisionBehavior = {
        let collider = UICollisionBehavior()
        collider.translatesReferenceBoundsIntoBoundary = true
        return collider
    }()
    
    func resetGame(){
        for gravityItem in gravity.items{
            gravity.removeItem(gravityItem)
        }
        for colliderItem in collider.items{
            collider.removeItem(colliderItem)
        }
        for itemBehaviorItem in itemBehavior.items{
            itemBehavior.removeItem(itemBehaviorItem)
        }
    }
    
    private let itemBehavior : UIDynamicItemBehavior = {
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
        if let boundary = identifier as? String, boundary.hasPrefix("Break") {
            recordBallHits?()
            removeBreak?(boundary)
            collider.removeBoundary(withIdentifier: boundary as NSCopying)
            print("break hitted")
        }
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
