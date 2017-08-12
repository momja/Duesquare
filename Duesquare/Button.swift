//
//  Button.swift
//  Duesquare
//
//  Created by Maxwell James Omdal on 8/10/17.
//  Copyright © 2017 Maxwell James Omdal. All rights reserved.
//

import Foundation
import SpriteKit

class Button: SKNode {
    
    //run when touches are down inside
    func animateAcceptedTouch() {
        let action1 = SKTScaleEffect(node: self, duration: 0.15, startScale: CGPoint(x: 1.0, y: 1.0), endScale: CGPoint(x: 0.5, y: 0.5))
        let action2 = SKTScaleEffect(node: self, duration: 0.15, startScale: CGPoint(x: 1.0, y: 1.0), endScale: CGPoint(x:2.0, y: 2.0))
        action2.timingFunction = SKTTimingFunctionBackEaseOut(_:)
        let sequence = SKAction.sequence([SKAction.actionWithEffect(action1), SKAction.actionWithEffect(action2)])
        if !self.hasActions() {
            self.run(sequence)
        }
    }
    
    func animateRejectedTouch() {
        let action1 = SKTScaleEffect(node: self, duration: 0.2, startScale: CGPoint(x: 1.0, y: 1.0), endScale: CGPoint(x: 0.5, y: 0.5))
        let action2 = SKTScaleEffect(node: self, duration: 0.2, startScale: CGPoint(x: 1.0, y: 1.0), endScale: CGPoint(x:2.0, y: 2.0))
        action2.timingFunction = SKTTimingFunctionBackEaseOut(_:)
        let sequence = SKAction.sequence([SKAction.actionWithEffect(action1), SKAction.actionWithEffect(action2)])
        if !self.hasActions() {
            self.run(sequence)
        }
    }
    
    //run with viewDidLoad
    func animateLoad() {
        self.isHidden = false
        let action1 = SKTScaleEffect(node: self, duration: 0.5, startScale: CGPoint(x: 0.1, y: 0.1), endScale: CGPoint(x: 1.0, y: 1.0))
        action1.timingFunction = SKTTimingFunctionElasticEaseOut(_:)
        let sequence = SKAction.sequence([SKAction.actionWithEffect(action1)])
        self.run(sequence)
    }
    
}
