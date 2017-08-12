//
//  Homescreen.swift
//  Duesquare
//
//  Created by Maxwell James Omdal on 7/29/17.
//  Copyright © 2017 Maxwell James Omdal. All rights reserved.
//

import SpriteKit
import GameKit

class Homescreen: SKScene, GKGameCenterControllerDelegate {
    
//    var store_icon = SKSpriteNode()
//    var shop_icon = SKSpriteNode()
    var play_icon = Button()
    var leaderboard_icon = Button()
    var level_icon = Button()
    var mode_icon = SKLabelNode()
    
    /* Variables */
    var gcEnabled = Bool() // Check if the user has Game Center enabled
    var gcDefaultLeaderBoard = String() // Check the default leaderboardID
    
    var score = 0
    
    let LEADERBOARD_ID = "quadsquare_highscore_leaderboard"
    
    override func didMove(to view: SKView) {
        
        Chartboost.cacheInterstitial(CBLocationHomeScreen)

        // Call the GC authentication controller
        authenticateLocalPlayer()
        
//        self.store_icon = (self.childNode(withName: "store_icon") as? SKSpriteNode)!
//        self.shop_icon = (self.childNode(withName: "shop_icon") as? SKSpriteNode)!
        let playImage = SKSpriteNode(imageNamed: "play-icon-gradient")
        self.play_icon.addChild(playImage)
        play_icon.position = CGPoint(x: 0, y: -327)
        self.addChild(play_icon)
        let leaderBoardImage = SKSpriteNode(imageNamed: "leaderboard-icon-gradient")
        self.leaderboard_icon.addChild(leaderBoardImage)
        self.addChild(leaderboard_icon)
        leaderboard_icon.position = CGPoint(x: -248.5, y: -375)
        let levelImage = SKSpriteNode(imageNamed: "level-icon-gradient")
        self.level_icon.addChild(levelImage)
        self.addChild(level_icon)
        level_icon.position = CGPoint(x: 248.5, y: -375)
        self.mode_icon = (self.childNode(withName: "mode_icon") as? SKLabelNode)!
        
        self.mode_icon.text = "mode: " + getMode()
        
        let highscore_label = (self.childNode(withName: "highscore_label") as? SKLabelNode)!
        highscore_label.text = "Best: " + String(getHighscore())
    }

    func getHighscore() -> Int {
        if UserDefaults.standard.object(forKey: "highscore") != nil {
            return UserDefaults.standard.object(forKey: "highscore") as! Int
        }
        else {
            return 0
        }
    }
    
    func getMode() -> String {
        if let rotateMode = UserDefaults.standard.object(forKey: "rotateMode") as? String {
            return rotateMode
        }
        else {
            UserDefaults.standard.set("normal", forKey: "rotateMode")
            return "normal"
        }
    }
    
    func toggleMode() -> String {
        if getMode() == "normal" {
            UserDefaults.standard.set("inverted", forKey: "rotateMode")
            return "inverted"
        }
        else {
            UserDefaults.standard.set("normal", forKey: "rotateMode")
            return "normal"
        }
    }
    
    // MARK: - AUTHENTICATE LOCAL PLAYER
    func authenticateLocalPlayer() {
        let localPlayer: GKLocalPlayer = GKLocalPlayer.localPlayer()
        
        localPlayer.authenticateHandler = {(ViewController, error) -> Void in
            if((ViewController) != nil) {
                // 1. Show login if player is not logged in
                let vc = self.view?.window?.rootViewController
                vc?.present(ViewController!, animated: true, completion: nil)
            } else if (localPlayer.isAuthenticated) {
                // 2. Player is already authenticated & logged in, load game center
                self.gcEnabled = true
                
                // Get the default leaderboard ID
                localPlayer.loadDefaultLeaderboardIdentifier(completionHandler: { (leaderboardIdentifer, error) in
                    if error != nil { print(error!)
                    } else { self.gcDefaultLeaderBoard = leaderboardIdentifer! }
                })
                
            } else {
                // 3. Game center is not enabled on the users device
                self.gcEnabled = false
                print("Local player could not be authenticated!")
                print(error!)
            }
        }
    }
    
    // Delegate to dismiss the GC controller
    func gameCenterViewControllerDidFinish(_ gameCenterViewController: GKGameCenterViewController) {
        gameCenterViewController.dismiss(animated: true, completion: nil)
    }

    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let t = touches.first!.location(in: self)
        if play_icon.contains(t) {
            play_icon.animateAcceptedTouch()
        }
        else if leaderboard_icon.contains(t) {
            leaderboard_icon.animateAcceptedTouch()
        }
        else if level_icon.contains(t) {
            level_icon.animateAcceptedTouch()
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        let t = touches.first!.location(in: self)
        let transition = SKTransition.fade(withDuration: 0.3)
        //        if store_icon.contains(t) {
        //
        //        }
        //        else if shop_icon.contains(t) {
        //
        //        }
        if play_icon.contains(t) {
            UserDefaults.standard.set(false, forKey: "isLevelMode")
            let newScene = SKScene(fileNamed: "GameScene")
            newScene?.scaleMode = .aspectFill
            scene?.view?.presentScene(newScene!, transition: transition)
        }
            
        else if leaderboard_icon.contains(t) {
            let gcVC = GKGameCenterViewController()
            let vc = self.view?.window?.rootViewController
            gcVC.gameCenterDelegate = self as GKGameCenterControllerDelegate
            gcVC.viewState = .leaderboards
            gcVC.leaderboardIdentifier = LEADERBOARD_ID
            vc?.present(gcVC, animated: true, completion: nil)
        }
        else if level_icon.contains(t) {
            let newScene = SKScene(fileNamed: "LevelScene")
            newScene?.scaleMode = .aspectFill
            scene?.view?.presentScene(newScene!, transition: transition)
        }
        else if mode_icon.contains(t) {
            mode_icon.text = "mode: " + toggleMode()
        }
    }
}
