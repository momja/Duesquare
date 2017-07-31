//
//  Ball.swift
//  Duesquare
//
//  Created by Maxwell James Omdal on 7/31/17.
//  Copyright © 2017 Maxwell James Omdal. All rights reserved.
//

import SpriteKit

extension GameScene {
    
    class Ball: SKSpriteNode {
        init() {
            let circleTexture = SKTexture(image: #imageLiteral(resourceName: "white_ball_small"))
            super.init(texture: circleTexture, color: UIColor.clear, size: circleTexture.size())
            self.physicsBody = SKPhysicsBody(circleOfRadius: self.frame.size.height/2 + 1)
            self.physicsBody?.restitution = 0.05
            //            self.physicsBody?.friction = 0.0
            self.physicsBody?.usesPreciseCollisionDetection = true
            let color = self.randomizeColor()
            self.color = color
            self.colorBlendFactor = 1.0
        }
        
        required init?(coder aDecoder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
        func randomizeDrop() -> CGFloat {
            return CGFloat(arc4random_uniform(16)) - 8
        }
    }
}
