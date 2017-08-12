//
//  GameOverPopup.swift
//  Duesquare
//
//  Created by Maxwell James Omdal on 7/31/17.
//  Copyright © 2017 Maxwell James Omdal. All rights reserved.
//

import SpriteKit
import GameKit

extension GameScene {
    class GameOverScreen: SKNode, ChartboostDelegate {
        var adPlayButton: SKSpriteNode
//        var coinPlayButton: SKSpriteNode
        var scoreContainer: SKSpriteNode
        var countdownBar: SKSpriteNode
        var scoreLabel: SKLabelNode
        var continuePlayButton: Button
        var replay = false
        override init() {
            
            let gameOverTextTexture = SKTexture(image: #imageLiteral(resourceName: "game-over-text"))
            let gameOverText = SKSpriteNode(texture: gameOverTextTexture)
            gameOverText.position = CGPoint(x: 0, y: 409)
            
            let scoreContainerTexture = SKTexture(image: #imageLiteral(resourceName: "score-container"))
            scoreContainer = SKSpriteNode(texture: scoreContainerTexture)
            scoreContainer.position = CGPoint(x: 0, y: 73)
            
            self.scoreLabel = SKLabelNode(fontNamed: "Hiragino Kaku Gothic StdN")
            self.scoreLabel.fontSize = 200
            self.scoreLabel.position = CGPoint(x: 0, y: 5)
            
            let adPlayTexture = SKTexture(image: #imageLiteral(resourceName: "continue-button"))
            self.adPlayButton = SKSpriteNode(texture: adPlayTexture)
            self.adPlayButton.position = CGPoint(x: 0, y: 0)
//            let coinPlayTexture = SKTexture(image: #imageLiteral(resourceName: "store-icon"))
//            self.coinPlayButton = SKSpriteNode(texture: coinPlayTexture)
//            self.coinPlayButton.position = CGPoint(x: 87, y: -86)
            
            let countdownBarTexture = SKTexture(image: #imageLiteral(resourceName: "countdown-bar"))
            self.countdownBar = SKSpriteNode(texture: countdownBarTexture)
            self.countdownBar.centerRect = CGRect(x: 0.106639, y: 0.0, width: 0.786721, height: 1.0)
            self.countdownBar.anchorPoint = CGPoint(x: 0.0, y: 0.5)
            self.countdownBar.position = CGPoint(x: -self.adPlayButton.frame.width/2 + 60, y: -40)
            
            continuePlayButton = Button()
            
            super.init()
            
            Chartboost.setDelegate(self)
                        
            self.zPosition = 9
            self.adPlayButton.zPosition = 11
            self.scoreLabel.zPosition = 12
//            self.coinPlayButton.zPosition = 11
            self.countdownBar.zPosition = 10
            
            self.addChild(gameOverText)
            self.addChild(self.scoreContainer)
            self.addChild(self.scoreLabel)
//            self.addChild(self.coinPlayButton)
            
            continuePlayButton.addChild(adPlayButton)
            continuePlayButton.addChild(countdownBar)
            continuePlayButton.position = CGPoint(x: 0, y: -313)
            self.addChild(continuePlayButton)
        }
        
        required init?(coder aDecoder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
        func touches(pos: CGPoint) {
            if continuePlayButton.contains(pos) {
                continuePlayButton.animateAcceptedTouch()
                // Show interstitial at location Gamescreen. See chartboost.h for available location options
                Chartboost.showInterstitial(CBLocationHomeScreen)
                print("showing ad")
            }
                
//            else if coinPlayButton.contains(pos) {
//                // from here the game continues with the loss of a coin
//                self.moveAction(yLocation: Int(-(self.parent?.frame.size.height)! + self.frame.height))
//                if let myParent = self.parent as? GameScene {
//                    let ready = Ready()
//                    myParent.addChild(ready)
//                    myParent.countdownLabel.text = String(Int(myParent.countdownLabel.text!)! + 5)
//                    replay = true
//                }
//            }
            
            else {
                self.returnToHomescreen()
            }
        }
        
        func createHomeScreenCountdown() {
            let countdown = SKLabelNode(text: "Continue...10")
            countdown.fontColor = UIColor.white
            countdown.fontSize = 72
            countdown.zPosition = 10
            var number = 10
            countdown.position = CGPoint(x: 0, y: -self.scoreContainer.frame.size.height/2 - 100)
            let decreaseCount = SKAction.run {
                number = number - 1
                let index = countdown.text?.index((countdown.text?.startIndex)!, offsetBy: 11)
                countdown.text = (countdown.text?.substring(to: index!))! + String(number)
            }
            let fadeOut = SKAction.fadeOut(withDuration: 0.5)
            let fadeIn = SKAction.fadeIn(withDuration: 0.8)
            let sequence = SKAction.sequence([fadeOut, decreaseCount, fadeIn])
            let count = SKAction.repeat(sequence, count: 10)
            self.addChild(countdown)
            countdown.run(count, completion: returnToHomescreen)
        }
        
        func animateCountdownBar() {
            let scaleAction = SKAction.scaleX(to: 0.0, duration: 10)
            self.countdownBar.run(scaleAction, completion: returnToHomescreen)
        }
        
        func animateHighScoreLabel(highscoreLabel: SKSpriteNode) {
            let scaleAction = SKAction.scale(by: 0.95, duration: 0.5)
            scaleAction.timingMode = .easeIn
            let reverseScaleAction = scaleAction.reversed()
            reverseScaleAction.timingMode = .easeOut
            let sequence = SKAction.sequence([scaleAction, reverseScaleAction])
            highscoreLabel.run(SKAction.repeatForever(sequence))
        }
        
        func moveAction(yLocation: Int) {
            if replay == false {
                let moveUp = SKAction.moveTo(y: CGFloat(yLocation), duration: 0.4)
                moveUp.timingMode = SKActionTimingMode.easeInEaseOut
                self.run(moveUp)
                
                if self.isHidden == true {
                    self.isHidden = false
                }
                else {
                    self.isHidden = true
                }
            }
            else {
                self.returnToHomescreen()
            }
        }
        
        // if there is a new highscore, replace the old one
        func checkHighscore() -> Bool {
            var previousHighscore: Int = 0
            if (UserDefaults.standard.object(forKey: "highscore") != nil) {
                previousHighscore = UserDefaults.standard.object(forKey: "highscore") as! Int
            }
            else {
                previousHighscore = 0
            }
            print("previous high score: " + previousHighscore.description)
            //get previous high score and compare to new score
            if getScore() > previousHighscore {
                createHighscoreText()
                print("new highscore!")
                UserDefaults.standard.set(Int(getScore()), forKey: "highscore")
                // Submit score to GC leaderboard
                let bestScoreInt = GKScore(leaderboardIdentifier: "quadsquare_highscore_leaderboard")
                bestScoreInt.value = Int64(getScore())
                GKScore.report([bestScoreInt]) { (error) in
                    if error != nil {
                        print(error!.localizedDescription)
                    } else {
                        print("Best Score submitted to your Leaderboard!")
                    }
                }
                return true
            }
            return false
        }
        
        func createHighscoreText() {
            let highscoreTextTexture = SKTexture(image: #imageLiteral(resourceName: "highscore-text"))
            let highscoreText = SKSpriteNode(texture: highscoreTextTexture)
            highscoreText.position = CGPoint(x: -100, y: 200)
            highscoreText.zPosition = 13
            self.addChild(highscoreText)
            animateHighScoreLabel(highscoreLabel: highscoreText)
        }
        
        func getScore() -> Int {
            if let myParent = self.parent as? GameScene {
                print(myParent.score)
                return myParent.score
            }
            return 0
        }
        
        func returnToHomescreen() {
            // Create random variable to make ad appear 1 out 5 times to not become to annoying to the user
            let random = arc4random_uniform(5)
            if  random >= 4 {
                // Show interstitial at location HomeScreen. See Chartboost.h for available location options.
                Chartboost.showInterstitial(CBLocationHomeScreen)
            }
            let newScene = SKScene(fileNamed: "Homescreen")
            let transition = SKTransition.fade(withDuration: 0.3)
            newScene?.scaleMode = .aspectFill
            scene?.view?.presentScene(newScene!, transition: transition)
        }
        
        func didDisplayInterstitial(_ location: String!) {
            // from here the game continues with an ad intervention
            print("ad has been shown")
            
            for child in self.children {
                child.removeAllActions()
            }
            for child in self.continuePlayButton.children {
                child.removeAllActions()
            }
            self.moveAction(yLocation: Int(-(self.parent?.frame.size.height)! + self.frame.height))

            if let myParent = self.parent as? GameScene {
                let ready = Ready()
                myParent.addChild(ready)
                myParent.countdownLabel.text = String(Int(myParent.countdownLabel.text!)! + 5)
                replay = true
            }

        }
    }
}
