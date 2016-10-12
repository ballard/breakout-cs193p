//
//  NamedBezierPathsView.swift
//  DropIt
//
//  Created by CS193p Instructor.
//  Copyright © 2016 Stanford University. All rights reserved.
//

import UIKit

class NamedBezierPathsView: UIView
{
    var bezierPaths = [String:UIBezierPath]() { didSet { setNeedsDisplay() } }
    
    override func draw(_ rect: CGRect) {
        for (_, path) in bezierPaths {
            UIColor.purple.setFill()
            path.fill()
            UIColor.yellow.setStroke()
            path.lineWidth = 2.0
            path.stroke()
        }
    }
}
