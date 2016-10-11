//
//  GameViewController.swift
//  breakout-cs193p
//
//  Created by Ivan on 07.10.16.
//  Copyright © 2016 Ivan. All rights reserved.
//

import UIKit

class GameViewController: UIViewController {
    
    @IBOutlet weak var gameView: GameView! {
        didSet{
            gameView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(pushBall(recognizer:))))
            gameView.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(movePlate(recognizer:))))
        }
    }
    
    func pushBall(recognizer: UITapGestureRecognizer) {
        if recognizer.state == .ended {
            gameView.pushLastBall()
        }
    }
    
    private var platePoint : CGFloat = 0
    
    func movePlate(recognizer: UIPanGestureRecognizer){
        let gesturePoint = recognizer.translation(in: gameView)
        if recognizer.state == .changed {
            platePoint += gesturePoint.x
            gameView.movePlate(toXPoint: platePoint)
            recognizer.setTranslation(CGPoint.zero, in: gameView)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        gameView.animating = true
        platePoint = gameView.bounds.midX
        gameView.movePlate(toXPoint: platePoint)
        gameView.addBall()
        gameView.addBreaks()
        
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        gameView.animating = false
    }

}
