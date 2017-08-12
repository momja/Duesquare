//
//  GameViewController.swift
//  Duesquare
//
//  Created by Maxwell James Omdal on 7/12/17.
//  Copyright © 2017 Maxwell James Omdal. All rights reserved.
//

import UIKit
import SpriteKit

class GameViewController: UIViewController, ChartboostDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        Chartboost.setAutoCacheAds(true)
        
        if let view = self.view as! SKView? {
            // Load the SKScene from 'GameScene.sks'
            if let scene = SKScene(fileNamed: "Homescreen") {
                // Set the scale mode to scale to fit the window
                scene.scaleMode = .aspectFill
                
                // Present the scene
                view.presentScene(scene)
            }
            view.ignoresSiblingOrder = true
            view.showsFPS = true
            view.showsNodeCount = true
        }
    }
    
    override var shouldAutorotate: Bool {
        return true
    }

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return .allButUpsideDown
        } else {
            return .all
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }
}
