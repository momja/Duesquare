//
//  GameScene.swift
//  Duesquare
//
//  Created by Maxwell James Omdal on 7/12/17.
//  Copyright © 2017 Maxwell James Omdal. All rights reserved.
//

import SpriteKit
import GameplayKit

var ball = SKSpriteNode()
var aimStick = SKSpriteNode()

class GameScene: SKScene {
    
    
    override func didMove(to view: SKView) {
        aimStick = (self.childNode(withName: "aimStick") as? SKSpriteNode)!
        ball = (self.childNode(withName: "ball") as? SKSpriteNode)!
    }

    func touchMoved(toPoint pos : CGPoint) {
        aimStick.zRotation = pos.x/self.frame.size.width*CGFloat.pi
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchMoved(toPoint: t.location(in: self)) }
    }
    
    func dropBall() {
        ball.position = CGPoint(x: 0, y: self.frame.size.height/2 + ball.frame.size.height/2)
        ball.physicsBody?.velocity = CGVector(dx: 0, dy: 0)
        print("reset ball")
    }
    
    func checkBall() -> Bool {
        if (ball.position.y < -self.frame.size.height/2-ball.frame.size.height/2) {
            dropBall()
            return true
        }
        else {
            return false
        }
    }
    
    override func update(_ currentTime: TimeInterval) {
        print(ball.position.y)
        checkBall()
    }
}
