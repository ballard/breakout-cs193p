//
//  BallBehavior.swift
//  breakout-cs193p
//
//  Created by Ivan on 08.10.16.
//  Copyright © 2016 Ivan. All rights reserved.
//

import UIKit

class BallBehavior: UIDynamicBehavior {
    let gravity = UIGravityBehavior() //better some public API
    
    private let collider : UICollisionBehavior = {
        let collider = UICollisionBehavior()
        collider.translatesReferenceBoundsIntoBoundary = true
        return collider
    }()
    
    private let itemBehavior : UIDynamicItemBehavior = {
        let itemBehavior = UIDynamicItemBehavior()
        itemBehavior.elasticity = 0.85
//        itemBehavior.allowsRotation = false
        return itemBehavior
    }()
    
    func addBarrier(path: UIBezierPath, named name: String){
        collider.removeBoundary(withIdentifier: name as NSCopying)
        collider.addBoundary(withIdentifier: name as NSCopying, for: path)
        
    }
    
    
    override init(){
        super.init()
        addChildBehavior(gravity)
        addChildBehavior(collider)
        addChildBehavior(itemBehavior)
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
