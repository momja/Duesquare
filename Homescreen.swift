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
    
    var store_icon = SKSpriteNode()
    var shop_icon = SKSpriteNode()
    var play_icon = SKSpriteNode()
    var leaderboard_icon = SKSpriteNode()
    var level_icon = SKSpriteNode()
    
    /* Variables */
    var gcEnabled = Bool() // Check if the user has Game Center enabled
    var gcDefaultLeaderBoard = String() // Check the default leaderboardID
    
    var score = 0
    
    // IMPORTANT: replace the red string below with your own Leaderboard ID (the one you've set in iTunes Connect)
    let LEADERBOARD_ID = "quadsquare_highscore_leaderboard"
    
    override func didMove(to view: SKView) {
        // Call the GC authentication controller
        authenticateLocalPlayer()
        
        self.store_icon = (self.childNode(withName: "store_icon") as? SKSpriteNode)!
        self.shop_icon = (self.childNode(withName: "shop_icon") as? SKSpriteNode)!
        self.play_icon = (self.childNode(withName: "play_icon") as? SKSpriteNode)!
        self.leaderboard_icon = (self.childNode(withName: "leaderboard_icon") as? SKSpriteNode)!
        self.level_icon = (self.childNode(withName: "level_icon") as? SKSpriteNode)!
        
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
        let transition = SKTransition.fade(withDuration: 0.3)
        if store_icon.contains(t) {
            
        }
        else if shop_icon.contains(t) {
            
        }
        else if play_icon.contains(t) {
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
    }
}
