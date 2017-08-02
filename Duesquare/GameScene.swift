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
let colorArray = [(UIColor(red: 0, green: 255/255, blue: 0, alpha: 1)), (UIColor(red: 0, green: 0, blue: 255/255, alpha: 1)), (UIColor(red: 255/255, green: 251/255, blue: 0/255, alpha: 1)), (UIColor(red: 255/255, green: 147/255, blue: 0/255, alpha: 1))]


class GameScene: SKScene {
    
    var aimStick: SKNode = Funnel(level: 1)
    var scoreBlocks = [SKSpriteNode]()
    var scoreLabel = SKLabelNode()
    var countdownLabel = SKLabelNode()
    let gameover = GameOverScreen()
    
    var saver1 = CGFloat(integerLiteral: 0)
    var saver3 = CGFloat(integerLiteral: 0)
    var presentBallsArray = [SKSpriteNode]()
    var delta = CGFloat(0)
    var xinitial = CGFloat(0)
    var fingerDownLeft = false
    var fingerDownRight = false

    
    override func didMove(to view: SKView) {
        
        let ready = Ready()
        self.addChild(ready)
        
        self.physicsWorld.gravity = CGVector(dx: 0.0, dy: -6.0)
        width = self.frame.size.width
        height = self.frame.size.height
        

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
        for i in 0...3 {
            let container = ScoreBlock(color: colorArray[i], position: CGPoint(x: width/4.0*CGFloat(i) - width/2.0 + width/8.0, y: -height/2.0))
            self.addChild(container)
            scoreBlocks.append(container)
        }
    }
    
    class Ready: SKSpriteNode {
        init() {
            let texture = SKTexture(image: #imageLiteral(resourceName: "red_ball"))
            super.init(texture: texture, color: UIColor.clear, size: texture.size())
            self.name = "ready_sprite"
        }
        
        required init?(coder aDecoder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
    }
    
    class ScoreBlock: SKSpriteNode {
        init(color: UIColor, position: CGPoint) {
            let texture = SKTexture(image: #imageLiteral(resourceName: "catcher"))
            super.init(texture: texture, color: color, size: CGSize(width: width/4, height: texture.size().height))
            self.colorBlendFactor = 1.0
            self.position = position
            self.physicsBody = SKPhysicsBody(texture: texture, size: CGSize(width: width/4, height: texture.size().height))
            self.physicsBody?.pinned = true
            self.physicsBody?.isDynamic = false
            self.physicsBody?.affectedByGravity = false
        }
        
        required init?(coder aDecoder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
    }
    
    func rotateByConstant() {
        let angle: CGFloat = 1/70*CGFloat.pi
        if fingerDownRight {
            aimStick.run(SKAction.rotate(byAngle: -angle, duration: 0.1))
        }
        else if fingerDownLeft {
            aimStick.run(SKAction.rotate(byAngle: angle, duration: 0.1))
        }
    }

//    func touchMoved(toPoint pos : CGPoint) {
//        var xfinal = pos.x - saver3
//        delta = xfinal - xinitial
//        if (delta > 20) {
//            print("moving too fast: " + delta.description)
//            xfinal = xinitial + 20
////            saver3 += 20
//        }
//        else if (delta < -20) {
//            print("moving too fast: " + delta.description)
//            xfinal = xinitial - 20
////            saver3 -= 20
//        }
//        let angle = saver1 + (xfinal)/width*CGFloat.pi
////        let rotateAction = SKAction.rotate(byAngle: angle, duration: 0.1)
////        aimStick.run(rotateAction)
//        aimStick.zRotation = angle
//        xinitial = xfinal
//    }
    
    func touchEnded(atPoint pos : CGPoint) {
//        saver1 = aimStick.zRotation
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
        
//        saver3 = pos.x
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
        let wait = SKAction.wait(forDuration: 1.4)
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
        for i in 0...(colorArray.count - 1) {
            print(i)
            scoreBlocks[i].color = colorArray[i]
        }
    }
    
    func checkBall() {
        
        func checkForScore(ball: Ball, indexOfScoreBlocks: Int) {
            let scoreParticle = SKEmitterNode(fileNamed: "ScoreParticle")
            scoreParticle?.position = CGPoint(x: width*CGFloat(indexOfScoreBlocks)/4 - width/2 + width/8, y: -height/2 + scoreBlocks[0].frame.height/2)
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
        
        var score = Int(scoreLabel.text!)
        score = score! + 1
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
            self.gameover.createHomeScreenCountdown()
            checkHighscore()
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
    
    func checkHighscore() {
        var score: Int = 0
        if (UserDefaults.standard.object(forKey: "highscore") != nil) {
            score = UserDefaults.standard.object(forKey: "highscore") as! Int
        }
        if Int(scoreLabel.text!)! > score {
            print("new highscore!")
            UserDefaults.standard.set(Int(scoreLabel.text!), forKey: "highscore")
            // Submit score to GC leaderboard
            let bestScoreInt = GKScore(leaderboardIdentifier: "quadsquare_highscore_leaderboard")
            bestScoreInt.value = Int64(score)
            GKScore.report([bestScoreInt]) { (error) in
                if error != nil {
                    print(error!.localizedDescription)
                } else {
                    print("Best Score submitted to your Leaderboard!")
                }
            }
        }
    }
    
    override func update(_ currentTime: TimeInterval) {
        checkBall()
        if fingerDownLeft == true {
            rotateByConstant()
        }
        else if fingerDownRight == true {
            rotateByConstant()
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
            color = colorArray[0]
        }
        else if (random <= 2){
            color = colorArray[1]
        }
        else if (random <= 3) {
            color = colorArray[2]
        }
        else {
           color = colorArray[3]
        }
        return color
    }
}
