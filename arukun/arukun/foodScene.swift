//
//  food.swift
//  chara_screen
//
//  Created by chikaratada on H27/10/05.
//  Copyright (c) 平成27年 SenshuUNIV. All rights reserved.
//

import SpriteKit
import Foundation

class foodScene: SKScene {
  var app:AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
  var phoneSize :CGSize = UIScreen.mainScreen().bounds.size //画面サイズ
  var pointLabel = SKLabelNode(fontNamed:"Hiragino Kaku Gothic ProN")
  var scoreSprite = SKSpriteNode(imageNamed: "score")
  var Label = SKLabelNode(fontNamed:"Hiragino Kaku Gothic ProN")
  var sprite = SKSpriteNode(imageNamed:"0")
  
  var Counter :Int = 0
  
  var Flg :Bool = false
  
  var Furniture :Array<SKSpriteNode> = []
  
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
    sprite.position = CGPoint(x: self.size.width*0.5, y: self.size.height*0.2)
    
    self.addChild(sprite)
    
    Label.text = "戻る"
    Label.fontSize = 50
    Label.fontColor = UIColor(red:0 , green: 0, blue: 0, alpha: 1)//黒
    Label.position = CGPoint(x: self.size.width*0.4, y: self.size.height*0.1)
    Label.zPosition = 0
    Label.name = "next"
    
    self.addChild(Label)
  }
  
  func scoreLayout(){
    //        scoreSprite.xScale = 1
    //        scoreSprite.yScale = 1
    scoreSprite.position = CGPoint(x: self.size.width*0.5, y: self.size.height-50)
    pointLabel.text = "画面が切り替わった！"
    pointLabel.fontSize = 20
    pointLabel.fontColor = UIColor(red:0 , green: 0, blue: 0, alpha: 1)//黒
    pointLabel.position = CGPoint(x:scoreSprite.position.x, y:scoreSprite.position.y-5)
    pointLabel.zPosition = 7
    self.addChild(scoreSprite)
    self.addChild(pointLabel)
    
    
  }
  override func update(currentTime: NSTimeInterval) {
    // pointLabel.text = toString(Counter) + "歩"
  }
  
  func layoutObject(){

    var backnumber :Int = 0
    var i = 0
    
    let background = SKSpriteNode(imageNamed: "con.jpg")
    background.position = CGPoint(x: self.size.width*0.5, y: self.size.height*0.5)
    background.xScale = 1.5
    background.yScale = 1.5
    self.addChild(background)
    
  }
  
  override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
    /* Called when a touch begins */
    
    for touch in (touches as! Set<UITouch>) {
      let location = touch.locationInNode(self)
      let touchedNode = self.nodeAtPoint(location)
      if(touchedNode.name == "next"){
        let tr = SKTransition.crossFadeWithDuration(0.1)
        let newScene = GameScene(size: self.scene!.size)
        newScene.scaleMode = SKSceneScaleMode.AspectFill
        self.scene!.view!.presentScene(newScene, transition: tr)
      }
    }
  }
  
}
