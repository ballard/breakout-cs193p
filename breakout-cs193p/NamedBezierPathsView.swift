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
        for (name, path) in bezierPaths {
            if name == "Plate" {
                UIColor.green.setFill()
                path.lineWidth = 0.0
            } else {
                UIColor.purple.setFill()
                path.lineWidth = 2.0
            }
            path.fill()
            UIColor.black.setStroke()
            path.stroke()
        }
    }
    
    var views : [String : UIView] = [:] { didSet { addSubViews(views) } }
    
    private func addSubViews(_: [String : UIView]) {
        for (_, view) in views {
            view.backgroundColor = UIColor.purple
            view.layer.borderColor = UIColor.black.cgColor
            view.layer.borderWidth = 2.0
            view.layer.cornerRadius = view.bounds.height / 5
            addSubview(view)
        }
    }
    
}
