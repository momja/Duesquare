//
//  LyceumPage.swift
//  Duesquare
//
//  Created by Maxwell James Omdal on 8/12/17.
//  Copyright © 2017 Maxwell James Omdal. All rights reserved.
//

import Foundation
import SpriteKit

class LyceumPage: SKScene {
    override func didMove(to view: SKView) {
        let waitAction = SKAction.sequence([SKAction.wait(forDuration: 2), SKAction.run {
            if let scene = SKScene(fileNamed: "Homescreen") {
                // Set the scale mode to scale to fit the window
                scene.scaleMode = .aspectFill
                // Present the scene
                view.presentScene(scene)
            }
            }])
        self.run(waitAction)
    }
}
