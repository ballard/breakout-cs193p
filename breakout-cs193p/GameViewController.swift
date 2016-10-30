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
            if !pushCooldown{
                gameView.pushLastBall(angle: 270.0 * CGFloat(M_PI) / 180.0)//CGFloat.random(max: 360))
                pushCooldown = true
            }
        }
    }
    
    private var platePoint : CGFloat = 0
    
    func movePlate(recognizer: UIPanGestureRecognizer) {
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
        let alertController = UIAlertController(title: "Game Over!", message: "Press OK to restart the game", preferredStyle: .alert)
        
        let OKAction = UIAlertAction(title: "OK", style: .default) { [weak weakSelf = self] (action:UIAlertAction!) in
//            print("Game restarted!");
//            print("place new bricks and ball here")
            weakSelf?.startGame()
        }
        alertController.addAction(OKAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    private func startGame() {
        gameView.animating = true
        gameView.prepareForGameStart()
        platePoint = gameView.bounds.midX
        gameView.movePlate(toXPoint: platePoint)
        gameView.gameOver = ({ [weak weakSelf = self] (inputValue: Void) -> Void in
            weakSelf?.restartGame()
            })
        gameView.pushLastBall(angle: 90.0 * CGFloat(M_PI) / 180.0)
    }
    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        UserDefaultsSingleton.sharedInstance
//    }
    
    private var isGamePaused = false
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if !isGamePaused {
            startGame()
        } else {
            gameView.animating = true
            if let ball = gameView.gameBall{
                gameView.ballBehavior.setItemVelocity(item: ball, velocity: ballVelocity )
            }
            
            isGamePaused = false
        }
    }
    
    var ballVelocity = CGPoint.zero
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        isGamePaused = true
        
        if let ball = gameView.gameBall{
            ballVelocity = gameView.ballBehavior.getItemVelocity(item: ball)
        }
        gameView.animating = false
    }
    
    
    // MARK - push ball cooldown
    
    var pushCooldown: Bool = false {
        didSet {
            startPushCooldown()
        }
    }
    
    func startPushCooldown() {
        if pushCooldown {
            gameView.addSubview(coolDownImageView!)
            Timer.scheduledTimer(
                timeInterval: 3,
                target: self, selector: #selector(GameViewController.resetPushCooldown),
                userInfo: nil,
                repeats: false
            )
        }
    }
    
    func resetPushCooldown() {
        coolDownImageView?.removeFromSuperview()
        pushCooldown = false
    }
    
    lazy var coolDownImageView : UIImageView? = { [unowned self] in
        let size : CGFloat = self.gameView.bounds.width / 10;
        var cooldownImage = UIImage(named: "Cooldown")
        var coolDownImageView = UIImageView(image: cooldownImage)
        coolDownImageView.frame = CGRect(center: CGPoint(x: self.gameView.bounds.minX + size/2, y: self.gameView.bounds.minY + size/2), size: CGSize(width: size, height: size))
        return coolDownImageView
    }()
}
