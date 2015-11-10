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
  var sprite = SKSpriteNode(imageNamed:"0")

  var Counter :Int = 0
  
  var Rooms: NSArray!
  var Furnitures: NSArray!
  
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
    sprite.position = CGPoint(x: self.size.width*0.5, y: self.size.height*0.5)
    
    self.addChild(sprite)
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
    var text :String = ""
    var backnumber :Int = 0
    for data in Rooms{
      backnumber = data.valueForKey("background") as! Int
    }
    
    var i = 0
    for fur in Furnitures{
      if(backnumber == i){
        text = fur.valueForKey("image") as! String
        break
      }
      i++
    }
    let background = SKSpriteNode(imageNamed: text)
    background.position = CGPoint(x: self.size.width*0.5, y: self.size.height*0.5)
    background.xScale = 0.5
    background.yScale = 0.5
    self.addChild(background)
    
  }
  
  override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
    /* Called when a touch begins */
    
    for touch in (touches as! Set<UITouch>) {
      let location = touch.locationInNode(self)
      var move = SKAction.moveTo(CGPoint(x: location.x, y: location.y), duration: 1.5)
      sprite.runAction(move)
    }
  }

}
