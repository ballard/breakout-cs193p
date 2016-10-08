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
        }
    }
    
    func pushBall(recognizer: UITapGestureRecognizer) {
        if recognizer.state == .ended {
            gameView.pushLastBall()
        }
    }
    
    func addBall() {
        gameView.addBall()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        gameView.animating = true
        addBall()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        gameView.animating = false
    }

}
