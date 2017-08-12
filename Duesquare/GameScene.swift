//
//  GameScene.swift
//  Duesquare
//
//  Created by Maxwell James Omdal on 7/12/17.
//  Copyright © 2017 Maxwell James Omdal. All rights reserved.
//

import SpriteKit
import GameKit

var width: CGFloat = 0
var height: CGFloat = 0
let colorBlocksArray = [UIColor(red:1.00, green:0.84, blue:0.13, alpha:1.0), UIColor(red:0.03, green:0.53, blue:0.91, alpha:1.0), (UIColor.white), UIColor(red:1.00, green:0.35, blue:0.08, alpha:1.0), UIColor(red:0.14, green:0.91, blue:0.34, alpha:1.0)]
let colorBallsArray = [UIColor(red:1.00, green:0.84, blue:0.13, alpha:1.0), UIColor(red:0.03, green:0.53, blue:0.91, alpha:1.0), UIColor(red:1.00, green:0.35, blue:0.08, alpha:1.0), UIColor(red:0.14, green:0.91, blue:0.34, alpha:1.0)]

class GameScene: SKScene {
    
    var aimStick: SKNode = Funnel(level: 1)
    var scoreBlocks = [SKSpriteNode]()
    var scoreLabel = SKLabelNode()
    var countdownLabel = SKLabelNode()
    let gameover = GameOverScreen()
    
    
    var score = 0
    var saver1 = CGFloat(integerLiteral: 0)
    var saver3 = CGFloat(integerLiteral: 0)
    var presentBallsArray = [SKSpriteNode]()
    var delta = CGFloat(0)
    var xinitial = CGFloat(0)
    var fingerDownLeft = false
    var fingerDownRight = false
    let rotateMode = UserDefaults.standard.object(forKey: "rotateMode") as! String

    
    override func didMove(to view: SKView) {

        self.physicsWorld.gravity = CGVector(dx: 0.0, dy: -5.0)
        width = self.frame.size.width
        height = self.frame.size.height
        
        let ready = Ready()
        self.addChild(ready)
        
        makeScoreBlocks()
        scoreLabel = (self.childNode(withName: "score_label") as? SKLabelNode)!
        countdownLabel = (self.childNode(withName: "countdown_label") as? SKLabelNode)!
        colorScoreBlocks()
        
        if UserDefaults.standard.object(forKey: "isLevelMode") as! Bool == true {
            self.levelMode()
        }
        else {
            aimStick = Funnel(level: 1)
        }
        aimStick.zRotation = -1/10*CGFloat.pi
        self.addChild(aimStick)
        
        self.gameover.position = CGPoint(x: 0, y: -height + self.gameover.frame.height)
        self.gameover.isHidden = true
        self.addChild(self.gameover)
    }
    
    func levelMode() {
        aimStick = getFunnel()
        let speedMode = UserDefaults.standard.object(forKey: "speedMode") as! Bool
        let fewerLivesMode = UserDefaults.standard.object(forKey: "fewerLivesMode") as! Bool
        if speedMode == true {
            self.physicsWorld.speed = 1.3
        }
        if fewerLivesMode == true {
            self.countdownLabel.text = String(5)
        }
        
    }
    
    func getFunnel() -> Funnel {
        let level = UserDefaults.standard.object(forKey: "level") as! Int
        func getSet() -> Int {
            return Int(ceil(CGFloat(level)/3.0))
        }
        let funnel = Funnel(level: getSet())
        return funnel
    }
    
    func makeScoreBlocks() {
        for i in 0...4 {
            // if its the middle block, then we want the container to be a separator
            if i == 2 {
                let texture = SKTexture(image: #imageLiteral(resourceName: "separator"))
                let separator = SKSpriteNode(texture: SKTexture(image: #imageLiteral(resourceName: "separator")), color: colorBlocksArray[i], size: CGSize(width: width/5, height: texture.size().height))
                separator.position = CGPoint(x: width/5.0*CGFloat(i) - width/2.0 + width/10.0, y: -height/2.0)
                separator.physicsBody = SKPhysicsBody(texture: separator.texture!, size: CGSize(width: width/5, height: (separator.texture?.size().height)!))
                separator.physicsBody?.isDynamic = false
                separator.physicsBody?.pinned = true
                self.addChild(separator)
                scoreBlocks.append(separator)
            }
            else {
                let container = ScoreBlock(color: colorBlocksArray[i], position: CGPoint(x: width/5.0*CGFloat(i) - width/2.0 + width/10.0, y: -height/2.0))
                self.addChild(container)
                scoreBlocks.append(container)
            }
        }
    }
    
    class ScoreBlock: SKSpriteNode {
        init(color: UIColor, position: CGPoint) {
            let texture = SKTexture(image: #imageLiteral(resourceName: "container"))
            super.init(texture: texture, color: color, size: CGSize(width: width/5, height: texture.size().height))
            self.colorBlendFactor = 1.0
            self.position = position
            self.physicsBody = SKPhysicsBody(texture: texture, size: CGSize(width: width/5, height: texture.size().height))
            self.physicsBody?.pinned = true
            self.physicsBody?.isDynamic = false
            self.physicsBody?.affectedByGravity = false
        }
        
        required init?(coder aDecoder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
    }
    
    func rotateByConstant(fingerRight: Bool, fingerLeft: Bool) {
        var angle: CGFloat = 1/60*CGFloat.pi
        if rotateMode == "inverted" {
            angle = -angle
        }
        if fingerRight {
            aimStick.run(SKAction.rotate(byAngle: angle, duration: 0.1))
        }
        else if fingerLeft {
            aimStick.run(SKAction.rotate(byAngle: -angle, duration: 0.1))
        }
    }

//    func touchMoved(toPoint pos : CGPoint) {
//        var xfinal = pos.x - saver3
//        delta = xfinal - xinitial
//        var rotationDuration: TimeInterval = TimeInterval(abs(delta/50))
//        if (delta > 20) {
//            print("moving too fast: " + delta.description)
////            xfinal = xinitial + 20
////            saver3 += 20
//        }
//        else if (delta < -20) {
//            print("moving too fast: " + delta.description)
////            xfinal = xinitial - 20
////            saver3 -= 20
//        }
//        let angle = saver1 + (xfinal)/width*CGFloat.pi
////        if !aimStick.hasActions() {
//            let rotateAction = SKAction.rotate(toAngle: angle, duration: rotationDuration)
//            aimStick.run(rotateAction)
////        }
////        aimStick.zRotation = angle
//        xinitial = xfinal
//    }
    
    func touchEnded(atPoint pos : CGPoint) {
        saver1 = aimStick.zRotation
        fingerDownLeft = false
        fingerDownRight = false
    }
    
    func touchBegan(atPoint pos : CGPoint) {
        if let ready = self.childNode(withName: "ready_sprite") {
            ready.removeFromParent()
            self.aimStick.isPaused = false
            self.prepareNextDrop()
            self.prepareNextDrop()
        }
        
        saver3 = pos.x
        if gameover.isHidden == false {
            if gameover.contains(pos) {
                //let additionToCountdown: Int = gameover.touches(pos: pos)
                //countdownLabel.text = String(additionToCountdown + Int(countdownLabel.text!)!)
                gameover.touches(pos: pos)
                self.isPaused = false
            }
        }

        if pos.x < 0 {
            fingerDownLeft = true
        }
        
        else if pos.x > 0 {
            fingerDownRight = true
        }
        
    }
    
//    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
//        for t in touches { self.touchMoved(toPoint: t.location(in: self)) }
//    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchEnded(atPoint: t.location(in: self)) }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches{ self.touchBegan(atPoint: t.location(in: self)) }
    }
    
    func prepareNextDrop() {
        let wait = SKAction.wait(forDuration: 1.6)
        let drop = SKAction.run {
            
            self.dropBall()
        }
        let sequence = SKAction.sequence([wait, drop])
        self.run(SKAction.repeatForever(sequence), withKey: "drop_sequence")
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
        for i in 0...(colorBlocksArray.count - 1) {
            scoreBlocks[i].color = colorBlocksArray[i]
        }
    }
    
    func checkBall() {
        
        func checkForScore(ball: Ball, indexOfScoreBlocks: Int) {
            let scoreParticle = SKEmitterNode(fileNamed: "ScoreParticle")
            scoreParticle?.position = CGPoint(x: width*CGFloat(indexOfScoreBlocks)/5 - width/2 + width/10, y: -height/2)
            scoreParticle?.particleColorBlendFactor = 1.0
            scoreParticle?.particleColorSequence = nil
            if ball.color == scoreBlocks[indexOfScoreBlocks].color {
                scoreParticle?.particleColor = ball.color
                self.addChild(scoreParticle!)
                scored()
            }
            else {
                scoreParticle?.particleColor = UIColor.red
                self.addChild(scoreParticle!)
                gameOver()
            }
        }
        
        for ball in presentBallsArray {
            if ball.position.y <= -height/2 - ball.frame.size.height/2 {
                print("ball has made it to the bottom")
                if ball.position.x <= (width/5 - width/2) {
                    // ball is in score block 1
                    checkForScore(ball: ball as! GameScene.Ball, indexOfScoreBlocks: 0)
                }
                else if ball.position.x <= (width*2/5 - width/2) {
                    // ball is in score block 2
                    checkForScore(ball: ball as! GameScene.Ball, indexOfScoreBlocks: 1)

                }
                
                else if ball.position.x <= (width*4/5 - width/2) {
                    // ball is in score block 3
                    checkForScore(ball: ball as! GameScene.Ball, indexOfScoreBlocks: 3)
                }
                
                else if ball.position.x <= (width - width/2) {
                    // ball is in score block 4
                    checkForScore(ball: ball as! GameScene.Ball, indexOfScoreBlocks: 4)
                }
                ball.removeFromParent()
                presentBallsArray.remove(at: presentBallsArray.index(of: ball)!)

            }
        }
        
        
    }
    
    func scored() {
        var score = Int(scoreLabel.text!)
        score = score! + 1
        self.score = score!
        scoreLabel.text = String(score!)
//        colorizeScoreBlocks()
        if UserDefaults.standard.object(forKey: "isLevelMode") as! Bool == true {
            if score! >= 20 {
                let currentLevel = UserDefaults.standard.object(forKey: "level") as! Int
                var bestLevel = UserDefaults.standard.object(forKey: "bestLevel") as! Int
                if currentLevel == bestLevel {
                    bestLevel = bestLevel + 1
                    UserDefaults.standard.set(bestLevel, forKey: "bestLevel")
                }
                let newScene = SKScene(fileNamed: "LevelScene")
                newScene?.scaleMode = .aspectFill
                scene?.view?.presentScene(newScene)
            }
        }
    }
    
    func gameOver() {
        let currentLoss = Int(countdownLabel.text!)
        if currentLoss == 1 {
            countdownLabel.text = String(0)
            
            self.gameover.moveAction(yLocation: 50)
            self.gameover.animateCountdownBar()
            self.gameover.scoreLabel.text = self.gameover.getScore().description
            self.gameover.checkHighscore()
            self.aimStick.isPaused = true
            self.removeAction(forKey: "drop_sequence")
            for ball in presentBallsArray {
                ball.removeFromParent()
            }
        }
        else if currentLoss! > 1 {
            countdownLabel.text = String(currentLoss! - 1)
        }
    }
    
    override func update(_ currentTime: TimeInterval) {
        checkBall()
        if fingerDownLeft == true {
            rotateByConstant(fingerRight: false, fingerLeft: true)
        }
        else if fingerDownRight == true {
            rotateByConstant(fingerRight: true, fingerLeft: false)
        }
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
            color = colorBallsArray[0]
        }
        else if (random <= 2){
            color = colorBallsArray[1]
        }
        else if (random <= 3) {
            color = colorBallsArray[2]
        }
        else {
           color = colorBallsArray[3]
        }
        return color
    }
}
