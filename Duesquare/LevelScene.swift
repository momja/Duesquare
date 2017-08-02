//
//  LevelScene.swift
//  Duesquare
//
//  Created by Maxwell James Omdal on 7/31/17.
//  Copyright © 2017 Maxwell James Omdal. All rights reserved.
//

import SpriteKit

class LevelScene: SKScene {
    
    let backButton = BackButton()
    var levelsArray = [LevelButton]()
    var bestLevel = UserDefaults.standard.object(forKey: "bestLevel") as? Int
    
    override func didMove(to view: SKView) {
        backButton.position = CGPoint(x: 100, y: -75)
        backButton.zPosition = 100
        self.addChild(backButton)
        if UserDefaults.standard.object(forKey: "bestLevel") as? Int == nil {
            UserDefaults.standard.set(1, forKey: "bestLevel")
        }
        bestLevel = UserDefaults.standard.object(forKey: "bestLevel") as? Int
        for y in (1...5) {
            for x in (1...3) {
                //create 15 LevelBlocks and give corresponding level values
                let level = LevelButton(level: x + ((y - 1) * 3))
                level.name = "Level_" + String(x + ((y - 1) * 3))
                level.position = CGPoint(x: self.frame.width*CGFloat(x)/4, y: -self.frame.height*CGFloat(y)/6 + 50)
                self.addChild(level)
                level.isHidden = true
                level.animateLoad()
                levelsArray.append(level)
                print(self.frame.width*CGFloat(x)/3)
                
                if bestLevel! < (x + ((y - 1) * 3)) {
                    level.button.colorBlendFactor = 0.5
                    level.button.color = UIColor.gray
                }
            }
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let t = touches.first!.location(in: self)
        for button in levelsArray {
            if button.contains(t) {
                print(button.name! + " was pressed")
                if bestLevel! >= button.level{
                    button.animateAcceptedTouch()
                }
                else {
                    button.animateRejectedTouch()
                }
            }
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        let t = touches.first!.location(in: self)
        for button in levelsArray {
            if button.contains(t) {
                UserDefaults.standard.set(true, forKey: "isLevelMode")
                button.alterChallengeLevel()
                button.handleTouch()
            }
        }
        if backButton.contains(t) {
            backButton.handleTouch()
        }
    }
    
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
    
    class BackButton: Button {
        
        override init() {
            let label = SKLabelNode(text: "Back")
            label.fontSize = 72
            
            super.init()

            self.addChild(label)
        }
        
        required init?(coder aDecoder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
        func handleTouch() {
            if let myParent = self.parent as? LevelScene {
                let transition = SKTransition.fade(withDuration: 0.3)
                let newScene = SKScene(fileNamed: "Homescreen")
                newScene?.scaleMode = .aspectFill
                myParent.view?.presentScene(newScene!, transition: transition)
            }
        }
    }
    
    class LevelButton: Button {
        
        var level = 0
        var button: SKSpriteNode
        
        init(level: Int) {
            self.level = level
            let texture = SKTexture(image: #imageLiteral(resourceName: "red_ball"))
            self.button = SKSpriteNode(texture: texture, size: texture.size())

            super.init()
            
            self.addChild(button)
            
            let levelLabel = SKLabelNode(text: "Level " + String(level))
            levelLabel.position.y = -100
            self.addChild(levelLabel)
        }
        
        required init?(coder aDecoder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
        func getSet() -> Int {
            return Int(ceil(CGFloat(level)/3.0))
        }
        
        func getLevelInSet() -> Int {
            if level % 3 != 0 {
                return level % 3
            }
            else {
                return 3
            }
        }
        
        func alterChallengeLevel() {
            if getLevelInSet() >= 2 {
                UserDefaults.standard.set(true, forKey: "speedMode")
                if getLevelInSet() >= 3 {
                    UserDefaults.standard.set(true, forKey: "fewerLivesMode")
                }
            }
            else {
                UserDefaults.standard.set(false, forKey: "speedMode")
                UserDefaults.standard.set(false, forKey: "fewerLivesMode")
            }
        }
        
        func handleTouch() {
            if UserDefaults.standard.object(forKey: "bestLevel") as! Int >= self.level {
                UserDefaults.standard.set(self.level, forKey: "level")
                
                if let myParent = self.parent as? LevelScene {
                    let transition = SKTransition.fade(withDuration: 0.3)
                    let newScene = SKScene(fileNamed: "GameScene")
                    newScene?.scaleMode = .aspectFill
                    myParent.view?.presentScene(newScene!, transition: transition)
                }
            }
        }
    }
    
}
