//
//  GameScene.swift
//  Duesquare
//
//  Created by Maxwell James Omdal on 7/12/17.
//  Copyright © 2017 Maxwell James Omdal. All rights reserved.
//

import SpriteKit
import GameplayKit

var width: CGFloat = 0
var height: CGFloat = 0

let aimStick = SKNode()
var scoreBlocks = [SKSpriteNode]()
var scoreLabel = SKLabelNode()

var saver1 = CGFloat(integerLiteral: 0)
var saver3 = CGFloat(integerLiteral: 0)
var presentBallsArray = [SKSpriteNode]()


class GameScene: SKScene {
    
    
    override func didMove(to view: SKView) {
        self.physicsWorld.gravity = CGVector(dx: 0.0, dy: -6.0)
        width = self.frame.size.width
        height = self.frame.size.height
        let texture = SKTexture(image: #imageLiteral(resourceName: "funnel"))
        let left = SKSpriteNode(texture: texture, color: UIColor.red, size: texture.size())
        left.colorBlendFactor = 1.0
        left.position.x = -117
        left.physicsBody = SKPhysicsBody(texture: texture, size: texture.size())
        left.physicsBody?.affectedByGravity = false
        left.physicsBody?.pinned = true
        left.physicsBody?.isDynamic = false
        left.physicsBody?.restitution = 0.0
        let textureRight = SKTexture(image: #imageLiteral(resourceName: "funnel-right"))
        let right = SKSpriteNode(texture: textureRight, color: UIColor.red, size: texture.size())
        right.colorBlendFactor = 1.0
        right.position.x = 117
        right.physicsBody = SKPhysicsBody(texture: textureRight, size: texture.size())
        right.physicsBody?.affectedByGravity = false
        right.physicsBody?.pinned = true
        right.physicsBody?.isDynamic = false
        right.physicsBody?.restitution = 0.0
        aimStick.addChild(left)
        aimStick.addChild(right)
        self.addChild(aimStick)
        scoreBlocks = [(self.childNode(withName: "score_block_1") as? SKSpriteNode)!, (self.childNode(withName: "score_block_2") as? SKSpriteNode)!, (self.childNode(withName: "score_block_3") as? SKSpriteNode)!, (self.childNode(withName: "score_block_4") as? SKSpriteNode)!]
        scoreLabel = (self.childNode(withName: "score_label") as? SKLabelNode)!
        colorScoreBlocks()
        dropBall()
        let wait = SKAction.wait(forDuration: 1.7)
        let drop = SKAction.run {
            
            self.prepareNextDrop()
        }
        let sequence = SKAction.sequence([wait, drop])
        run(SKAction.repeatForever(sequence))
    }

    func touchMoved(toPoint pos : CGPoint) {

        aimStick.zRotation = saver1 + ((pos.x - saver3))/width*CGFloat.pi
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
    }
    
    class Ball: SKSpriteNode {
        init() {
            let circleTexture = SKTexture(image: #imageLiteral(resourceName: "white_ball_small"))
            super.init(texture: circleTexture, color: UIColor.clear, size: circleTexture.size())
            self.physicsBody = SKPhysicsBody(circleOfRadius: self.frame.size.height/2)
            self.physicsBody?.restitution = 0.0
            self.physicsBody?.friction = 0.0
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
    
    // prepare a new ball to be dropped
    func dropBall() {
        let ball = Ball()
        ball.position = CGPoint(x: ball.randomizeDrop(), y: height/2 + (ball.frame.size.height)/2)
        presentBallsArray.append(ball)
        self.addChild(ball)
    }
    
//    func colorizeScoreBlocks() {
//        let colors = scoreBlocks[0].randomizeColor()
//        for i in 0...(scoreBlocks.count - 1) {
//            scoreBlocks[i].color = colors[i]
//        }
//    }
    
    func colorScoreBlocks() {
        let colorArray = [(UIColor(red: 0, green: 255/255, blue: 0, alpha: 1)), (UIColor(red: 0, green: 0, blue: 255/255, alpha: 1)), (UIColor(red: 255/255, green: 251/255, blue: 0/255, alpha: 1)), (UIColor(red: 255/255, green: 147/255, blue: 0/255, alpha: 1))]
        for i in 0...(colorArray.count - 1) {
            print(i)
            scoreBlocks[i].color = colorArray[i]
        }
    }
    
    func checkBall() {
        
        func checkForScore(ball: Ball, indexOfScoreBlocks: Int) {
            if ball.color == scoreBlocks[indexOfScoreBlocks].color {
                scored()
            }
            else {
                gameOver()
            }
        }
        
        for ball in presentBallsArray {
            if ball.position.y <= -height/2 - ball.frame.size.height/2 {
                print("ball has made it to the bottom")
                if ball.position.x <= -width/4 {
                    // ball is in score block 1
                    checkForScore(ball: ball as! GameScene.Ball, indexOfScoreBlocks: 0)
                }
                else if ball.position.x <= 0 {
                    // ball is in score block 2
                    checkForScore(ball: ball as! GameScene.Ball, indexOfScoreBlocks: 1)

                }
                
                else if ball.position.x <= width/4 {
                    // ball is in score block 3
                    checkForScore(ball: ball as! GameScene.Ball, indexOfScoreBlocks: 2)
                }
                
                else {
                    // ball is in score block 4
                    checkForScore(ball: ball as! GameScene.Ball, indexOfScoreBlocks: 3)
                }
                ball.removeFromParent()
                presentBallsArray.remove(at: presentBallsArray.index(of: ball)!)

            }
        }
        
        
    }
    
    func scored() {
        let score = Int(scoreLabel.text!)
        scoreLabel.text = String(score! + 1)
//        colorizeScoreBlocks()
    }
    
    func gameOver() {
        let gameOver = SKLabelNode(text: "Game Over")
        gameOver.position = CGPoint(x: 0, y: 0)
        gameOver.fontSize = 60
        self.addChild(gameOver)
        //self.isPaused = true
    }
    
    override func update(_ currentTime: TimeInterval) {
        checkBall()
    }
}

//extension SKSpriteNode {
//    func randomizeColor() -> [UIColor] {
//        let random = arc4random_uniform(2)
//        var colorArray = [UIColor]()
//        if (random >= 1) {
//            colorArray.append(UIColor(red: 0, green: 1, blue: 0, alpha: 1))
//            colorArray.append(UIColor(red: 0, green: 0, blue: 1, alpha: 1))
//        }
//        else {
//            colorArray.append(UIColor(red: 0, green: 0, blue: 1, alpha: 1))
//            colorArray.append(UIColor(red: 0, green: 1, blue: 0, alpha: 1))
//        }
//        return colorArray
//    }
//}

extension SKSpriteNode {
    func randomizeColor() -> UIColor {
        let random = arc4random_uniform(5)
        var color = UIColor()
        print(random)
        if (random <= 1) {
            color = (UIColor(red: 0, green: 255/255, blue: 0, alpha: 1))
        }
        else if (random <= 2){
            color = (UIColor(red: 0, green: 0, blue: 255/255, alpha: 1))
        }
        else if (random <= 3) {
            color = (UIColor(red: 255/255, green: 251/255, blue: 0/255, alpha: 1))
        }
        else {
            color = (UIColor(red: 255/255, green: 147/255, blue: 0/255, alpha: 1))
        }
        return color
    }
}
