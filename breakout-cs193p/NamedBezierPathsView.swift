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
        _ = bezierPaths.map { (name, path) in
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
    
    struct DoubleView {
        var hits: Bool
        var view: UIView
        var path: UIBezierPath
    }
    
    var isDoubleViewsBuilded = false
    
    var doubleViews : [String : DoubleView] = [:] {
        didSet {
            if isDoubleViewsBuilded == false {
                addSubViews(doubleViews)
            }
        }
    }
    
    private func addSubViews(_: [String : DoubleView]) {
        _ = doubleViews.map { (_, doubleView) in
            if doubleView.hits {
                doubleView.view.backgroundColor = UIColor.blue
            } else {
                doubleView.view.backgroundColor = UIColor.purple
            }
            doubleView.view.layer.borderColor = UIColor.black.cgColor
            doubleView.view.layer.borderWidth = 2.0
            doubleView.view.layer.cornerRadius = doubleView.view.bounds.height / 5
            addSubview(doubleView.view)
        }
    }
}
