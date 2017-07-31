//
//  GameOverPopup.swift
//  Duesquare
//
//  Created by Maxwell James Omdal on 7/31/17.
//  Copyright © 2017 Maxwell James Omdal. All rights reserved.
//

import SpriteKit

extension GameScene {
    class GameOverScreen: SKNode {
        var adPlayButton: SKSpriteNode
        var coinPlayButton: SKSpriteNode
        var background: SKSpriteNode
        override init() {
            let backgroundTexture = SKTexture(image: #imageLiteral(resourceName: "game-over-pop-up"))
            background = SKSpriteNode(texture: backgroundTexture)
            let adPlayTexture = SKTexture(image: #imageLiteral(resourceName: "play-icon-small"))
            self.adPlayButton = SKSpriteNode(texture: adPlayTexture)
            self.adPlayButton.position = CGPoint(x: -87, y: -86)
            let coinPlayTexture = SKTexture(image: #imageLiteral(resourceName: "store-icon"))
            self.coinPlayButton = SKSpriteNode(texture: coinPlayTexture)
            self.coinPlayButton.position = CGPoint(x: 87, y: -86)
            
            super.init()
            
            self.zPosition = 10
            self.adPlayButton.zPosition = 11
            self.coinPlayButton.zPosition = 11
            
            self.addChild(background)
            self.addChild(self.adPlayButton)
            self.addChild(self.coinPlayButton)
        }
        
        required init?(coder aDecoder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
        func touches(pos: CGPoint) {
            if adPlayButton.contains(pos) {
                // from here the game continues with an ad intervention
                // Show interstitial at location HomeScreen. See Chartboost.h for available location options.
                Chartboost.showInterstitial(CBLocationHomeScreen)
                print("showing ad")
                self.moveAction(yLocation: Int(-(self.parent?.frame.size.height)! + self.frame.height))
                if let myParent = self.parent as? GameScene {
                    myParent.physicsWorld.speed = 1.0
                    myParent.aimStick.isPaused = false
                    myParent.prepareNextDrop()
                    myParent.countdownLabel.text = String(Int(myParent.countdownLabel.text!)! + 5)
                }
            }
                
            else if coinPlayButton.contains(pos) {
                // from here the game continues with the loss of a coin
                self.moveAction(yLocation: Int(-(self.parent?.frame.size.height)! + self.frame.height))
                if let myParent = self.parent as? GameScene {
                    myParent.physicsWorld.speed = 1.0
                    myParent.aimStick.isPaused = false
                    myParent.prepareNextDrop()
                    myParent.countdownLabel.text = String(Int(myParent.countdownLabel.text!)! + 5)
                }
            }
                
            else {
                self.returnToHomescreen()
            }
        }
        
        func createHomeScreenCountdown() {
            let countdown = SKLabelNode(text: "Continue...10")
            countdown.fontColor = UIColor.black
            countdown.fontSize = 72
            countdown.zPosition = 10
            var number = 10
            countdown.position = CGPoint(x: 0, y: -self.background.frame.size.height/2 - 100)
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
        
        func moveAction(yLocation: Int) {
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
        
        func returnToHomescreen() {
            // Show interstitial at location HomeScreen. See Chartboost.h for available location options.
            Chartboost.showInterstitial(CBLocationHomeScreen)
            let newScene = SKScene(fileNamed: "Homescreen")
            let transition = SKTransition.fade(withDuration: 0.3)
            newScene?.scaleMode = .aspectFill
            scene?.view?.presentScene(newScene!, transition: transition)
        }
    }
}
