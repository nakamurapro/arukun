//
//  GameScene.swift
//  chara_screen
//
//  Created by chikaratada on H27/10/05.
//  Copyright (c) 平成27年 SenshuUNIV. All rights reserved.
//

import SpriteKit
import Foundation

class GameScene: SKScene {
    var app:AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    var pointLabel = SKLabelNode(fontNamed:"Hiragino Kaku Gothic ProN")
    var scoreSprite = SKSpriteNode(imageNamed: "score")
    var sprite = SKSpriteNode(imageNamed:"0")

    
    override func didMoveToView(view: SKView) {
//        /* Setup your scene here */
        layoutObject()
        scoreLayout()
//        self.physicsWorld.contactDelegate = self
        self.physicsWorld.gravity = CGVector(dx: 0, dy: 0)
        self.physicsBody = SKPhysicsBody(edgeLoopFromRect: self.frame)
        sprite.physicsBody = SKPhysicsBody(circleOfRadius: 1000)
        
        sprite.xScale = 0.05
        sprite.yScale = 0.05
        sprite.position = CGPoint(x: self.size.width*0.5, y: self.size.height*0.5)
        
        self.addChild(sprite)
    }
    
    func scoreLayout(){
//        scoreSprite.xScale = 1
//        scoreSprite.yScale = 1
        scoreSprite.position = CGPoint(x: self.size.width*0.5, y: self.size.height-50)
        pointLabel.text = "0歩"
        pointLabel.fontSize = 20
        pointLabel.fontColor = UIColor(red:0 , green: 0, blue: 0, alpha: 1)//黒
        pointLabel.position = CGPoint(x:scoreSprite.position.x, y:scoreSprite.position.y-5)
        pointLabel.zPosition = 7
        self.addChild(scoreSprite)
        self.addChild(pointLabel)

        
    }
    override func update(currentTime: NSTimeInterval) {
        pointLabel.text = toString(app.counter) + "歩"
    }
    
    func layoutObject(){
        let background = SKSpriteNode(imageNamed: "mgbace")
        background.position = CGPoint(x: self.size.width*0.5, y: self.size.height*0.5)
        background.size = self.size
        self.addChild(background)
        
    }
    
    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
        /* Called when a touch begins */
        
        for touch in (touches as! Set<UITouch>) {
            let location = touch.locationInNode(self)
//            let sprite = SKSpriteNode(imageNamed:"0")
//            sprite.xScale = 0.05
//            sprite.yScale = 0.05
//            sprite.position = location
//            self.addChild(sprite)
            var move = SKAction.moveTo(CGPoint(x: location.x, y: location.y), duration: 1.5)
//            println((120 - location.y/10)/100)
//            var scale = SKAction.scaleTo((100 - location.y/10)/100, duration: 1.0)
//            sprite.runAction(scale)
            sprite.runAction(move)
        }
    }

}
