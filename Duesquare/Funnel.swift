//
//  Funnel.swift
//  Duesquare
//
//  Created by Maxwell James Omdal on 7/31/17.
//  Copyright © 2017 Maxwell James Omdal. All rights reserved.
//

import SpriteKit

class Funnel: SKNode {
    
    var funnel_1 = [SKTexture(image: #imageLiteral(resourceName: "funnel-1-1")), SKTexture(image: #imageLiteral(resourceName: "funnel-1-2")) ]
    var funnel_2 = [SKTexture(image: #imageLiteral(resourceName: "funnel-2-1"))]
    
    var textures: [SKTexture]
    
    init(level: Int) {
        self.textures = self.funnel_1
        super.init()
        stitchTextures()
    }
    
    func stitchTextures() {
        //textures will be stiched from left to right so textures should be ordered in that way when making the class
        for texture in self.textures {
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
    
}
