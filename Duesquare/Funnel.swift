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
    var funnel_3 = [SKTexture(image: #imageLiteral(resourceName: "funnel-3-1")), SKTexture(image: #imageLiteral(resourceName: "funnel-3-2")), SKTexture(image: #imageLiteral(resourceName: "funnel-3-3"))]
    var funnel_4 = [SKTexture(image: #imageLiteral(resourceName: "funnel-4-1")), SKTexture(image: #imageLiteral(resourceName: "funnel-4-2"))]
    var funnel_5 = [SKTexture(image: #imageLiteral(resourceName: "funnel-5-2")), SKTexture(image: #imageLiteral(resourceName: "funnel-5-1"))]
    
    var textures: [SKTexture]
    
    init(level: Int) {
        let funnelSet = [funnel_1, funnel_2, funnel_3, funnel_4, funnel_5]
        self.textures = funnelSet[level - 1]
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
            part.physicsBody?.friction = 1.0
            self.addChild(part)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

