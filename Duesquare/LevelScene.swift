//
//  LevelScene.swift
//  Duesquare
//
//  Created by Maxwell James Omdal on 7/31/17.
//  Copyright © 2017 Maxwell James Omdal. All rights reserved.
//

import SpriteKit

class LevelScene: SKScene {
    
    override func didMove(to view: SKView) {
        for y in 1...5 {
            for x in 1...3 {
                //create 15 LevelBlocks and give corresponding level values
                let level = LevelBlock(level: x*y)
                level.name = "Level_" + String(x*y)
                level.position = CGPoint(x: self.frame.width/CGFloat(x) - level.frame.width/2, y: self.frame.height/CGFloat(y) - level.frame.height/2)
                self.addChild(level)
            }
        }
    }
    
    class LevelBlock: SKSpriteNode {
        init(level: Int) {
            let texture = SKTexture(image: #imageLiteral(resourceName: "red_ball"))
            
            super.init(texture: texture, color: UIColor.red, size: texture.size())
        }
        
        required init?(coder aDecoder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
    }
    
}
