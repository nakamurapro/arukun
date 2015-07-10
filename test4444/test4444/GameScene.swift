//
//  GameScene.swift
//  test4444
//
//  Created by 坂本一 on 2015/07/03.
//  Copyright (c) 2015年 Hajime Sakamoto. All rights reserved.
//

import SpriteKit
import CoreMotion

class GameScene: SKScene {
    var myMotionManager: CMMotionManager!
    var XXXX:AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    var myLabel1 = SKLabelNode()

    override func didMoveToView(view: SKView) {
        /* Setup your scene here */
        self.backgroundColor = UIColor.whiteColor()
        let myLabel1 = SKLabelNode(fontNamed:"Courier")
        myLabel1.text = "";
        myLabel1.fontSize = 50;
        myLabel1.fontColor = UIColor.redColor()
        myLabel1.position = CGPoint(x:CGRectGetMidX(self.frame), y:CGRectGetMidY(self.frame)*0.9);
        self.myLabel1 = myLabel1
        self.addChild(myLabel1)
        
        let myLabel2 = SKLabelNode(fontNamed:"Courier")
        myLabel2.text = "";
        myLabel2.fontSize = 20;
        myLabel2.fontColor = UIColor.greenColor()
        myLabel2.position = CGPoint(x:CGRectGetMidX(self.frame), y:CGRectGetMidY(self.frame));
        self.addChild(myLabel2)
    
        let myLabel3 = SKLabelNode(fontNamed:"Courier")
        myLabel3.text = "";
        myLabel3.fontSize = 20;
        myLabel3.fontColor = UIColor.blueColor()
        myLabel3.position = CGPoint(x:CGRectGetMidX(self.frame), y:CGRectGetMidY(self.frame)*1.1);
        self.addChild(myLabel3)
        
        
        
    }
    
    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
        /* Called when a touch begins */
        
    }
   
    override func update(currentTime: CFTimeInterval) {
        self.myLabel1.text = "\(XXXX.Counter)歩"
    }
}
