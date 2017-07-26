//
//  GameScene.swift
//  Duesquare
//
//  Created by Maxwell James Omdal on 7/12/17.
//  Copyright © 2017 Maxwell James Omdal. All rights reserved.
//

import SpriteKit
import GameplayKit

var aimStick = SKSpriteNode()
let circleTexture = SKTexture(image: #imageLiteral(resourceName: "white_ball"))
var scoreBlocks = [SKSpriteNode]()

var saver1 = CGFloat(integerLiteral: 0)
var saver3 = CGFloat(integerLiteral: 0)


class GameScene: SKScene {
    
    
    override func didMove(to view: SKView) {
        aimStick = (self.childNode(withName: "aimStick") as? SKSpriteNode)!
        scoreBlocks = [(self.childNode(withName: "score_block_1") as? SKSpriteNode)!, (self.childNode(withName: "score_block_2") as? SKSpriteNode)!]
//        dropBall()
        let wait = SKAction.wait(forDuration: 1)
        let drop = SKAction.run { 
//            self.prepareNextDrop()
        }
        let sequence = SKAction.sequence([wait, drop])
        run(SKAction.repeatForever(sequence))
    }

    func touchMoved(toPoint pos : CGPoint) {

        aimStick.zRotation = saver1 + ((pos.x - saver3))/self.frame.size.width*CGFloat.pi
    }
    
    func touchEnded(atPoint pos : CGPoint) {
        saver1 = aimStick.zRotation
    }
    
    func touchBegan(atPoint pos : CGPoint) {
        saver3 = pos.x
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchMoved(toPoint: t.location(in: self)) }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchEnded(atPoint: t.location(in: self)) }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches{ self.touchBegan(atPoint: t.location(in: self)) }
    }
    
    func prepareNextDrop() {
        dropBall()
        let colors = randomizeColor()
        for i in 0...(scoreBlocks.count - 1) {
            scoreBlocks[i].run(SKAction.colorize(with: colors[i], colorBlendFactor: 1, duration: 0))
        }
    }
    
    func dropBall() {
        let ball = SKSpriteNode(texture: circleTexture)
        self.addChild(ball)
        let colorize = SKAction.colorize(with: randomizeColor()[0], colorBlendFactor: 1, duration: 0)
        ball.run(colorize)
        ball.position = CGPoint(x: randomizeDrop(), y: self.frame.size.height/2 + (ball.frame.size.height)/2)
        ball.physicsBody = SKPhysicsBody(circleOfRadius: ball.frame.size.height/2)
        ball.physicsBody?.velocity = CGVector(dx: 0, dy: 0)
        print("reset ball")
    }
    
    func randomizeDrop() -> CGFloat {
        return CGFloat(arc4random_uniform(16)) - 8
    }
    
    func randomizeColor() -> [UIColor] {
        let random = arc4random_uniform(2)
        var colorArray = [UIColor]()
        if (random >= 1) {
            colorArray.append(UIColor(red: 0, green: 1, blue: 0, alpha: 1))
            colorArray.append(UIColor(red: 0, green: 0, blue: 1, alpha: 1))
        }
        else {
            colorArray.append(UIColor(red: 0, green: 0, blue: 1, alpha: 1))
            colorArray.append(UIColor(red: 0, green: 1, blue: 0, alpha: 1))
        }
        return colorArray
    }
    
    func checkBall() -> Bool {
        return false
    }
    
    override func update(_ currentTime: TimeInterval) {
        checkBall()
    }
}
