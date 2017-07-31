//
//  Funnel.swift
//  Duesquare
//
//  Created by Maxwell James Omdal on 7/31/17.
//  Copyright © 2017 Maxwell James Omdal. All rights reserved.
//

import SpriteKit

extension GameScene {
    class Funnel: SKNode {
        init(textures: [SKTexture]) {
            super.init()
        }
        
        func stitchTextures(textures: [SKTexture]) {
            //textures will be stiched from left to right so textures should be ordered in that way when making the class
            for texture in textures {
                let part = SKSpriteNode(texture: texture)
                part.physicsBody = SKPhysicsBody(texture: texture, size: texture.size())
                part.physicsBody?.affectedByGravity = false
                part.physicsBody?.pinned = true
                part.physicsBody?.isDynamic = false
                part.physicsBody?.restitution = 0.2
                self.addChild(part)
            }
        }
        
        required init?(coder aDecoder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
        func rotate() {
            
        }
        
    }
}
