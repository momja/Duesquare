//
//  Ready.swift
//  Duesquare
//
//  Created by Maxwell James Omdal on 8/10/17.
//  Copyright © 2017 Maxwell James Omdal. All rights reserved.
//

import Foundation
import SpriteKit

class Ready: SKNode {
    override init() {
        super.init()
        self.name = "ready_sprite"
        animateTaps()
    }
    
    func animateTaps() {
        
        
        let tappedSide = SKShapeNode(rectOf: CGSize(width: width/2, height: height))
        tappedSide.fillColor = UIColor.black
        tappedSide.lineWidth = 0
        tappedSide.alpha = 0.25
        tappedSide.position = CGPoint(x: width/4, y: 0)

        self.addChild(tappedSide)
        
        let tapTexture = SKTexture(image: #imageLiteral(resourceName: "tap-icon"))
        let tap = SKSpriteNode(texture: tapTexture)
        self.addChild(tap)

        
        let fadeIn = SKAction.fadeIn(withDuration: 0.1)
        let rescale = SKAction.actionWithEffect(SKTScaleEffect(node: tap, duration: 0.2, startScale: CGPoint(x: 1.0, y: 1.0), endScale: CGPoint(x: 1.2, y: 1.2)))
        let rescaleReverse = SKAction.actionWithEffect(SKTScaleEffect(node: tap, duration: 0.2, startScale: CGPoint(x: 1.0, y: 1.0), endScale: CGPoint(x: 0.8333, y: 0.8333)))
        let rescaleSequence = SKAction.sequence([rescale, rescaleReverse])
        
        let switchTapAction = SKAction.run {
            tap.alpha = 0.0
            var angle = 1/5*CGFloat.pi
            if let myParent = self.parent as? GameScene {
                if myParent.rotateMode == "inverted" {
                    angle = -angle
                }
                if tap.position.x <= 0 {
                    tap.position.x = 188
                    tappedSide.position.x = width/4
                    myParent.aimStick.run(SKAction.rotate(byAngle: angle, duration: 0.5))
                }
                else if tap.position.x > 0 {
                    tap.position.x = -188
                    tappedSide.position.x = -width/4
                    myParent.aimStick.run(SKAction.rotate(byAngle: -angle, duration: 0.5))
                }
                let actionsGroup = SKAction.group([fadeIn, rescaleSequence])
                tap.run(actionsGroup)
            }
        }
        tap.run(SKAction.repeatForever(SKAction.sequence([switchTapAction, SKAction.wait(forDuration: 0.5)])))
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
