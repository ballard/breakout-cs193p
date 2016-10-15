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
    
    func restartGame() {
        let alertController = UIAlertController(title: "Game Over!", message: "Press OK to restart", preferredStyle: .alert)
        
        let OKAction = UIAlertAction(title: "OK", style: .default) { [weak weakSelf = self] (action:UIAlertAction!) in
            print("Game restarted!");
            print("place new bricks and ball here")
            
            weakSelf?.gameView.addBreaks()
            weakSelf?.gameView.addBall()
        }
        alertController.addAction(OKAction)
        
        self.present(alertController, animated: true, completion: nil)
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        gameView.animating = true
        gameView.backgroundColor = UIColor.black
        platePoint = gameView.bounds.midX
        gameView.movePlate(toXPoint: platePoint)
        gameView.addBreaks()
        gameView.addBall()
        gameView.addCountLabel()
        gameView.gameOver = ({ [weak weakSelf = self] (inputValue: Void) -> Void in
            weakSelf?.restartGame()
            })
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        gameView.animating = false
    }

}
