//
//  RecordScene.swift
//  arukun
//
//  Created by 坂本一 on 2015/06/23.
//  Copyright (c) 2015年 chikaratada. All rights reserved.
//

import Foundation
import SpriteKit

class RecScene: SKScene {
    var appDelegate:AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    var myLabel1 = SKLabelNode()
    var myLabel2 = SKLabelNode()
    var myLabel3 = SKLabelNode()

    override func didMoveToView(view: SKView) {
        /* Setup your scene here */
        self.backgroundColor = UIColor(red: 1.0, green: 1.0, blue: 0.5, alpha: 1.0)
        let myLabel1 = SKLabelNode(fontNamed:"Chalkduster")
        myLabel1.text = "歩数";
        myLabel1.fontColor = UIColor.blackColor()
        myLabel1.fontSize = 65;
        myLabel1.position = CGPoint(x:CGRectGetMidX(self.frame), y:self.frame.height*0.3);
        myLabel1.name = "about1"
        myLabel1.targetForAction("about1:", withSender: self)
        
        let myLabel2 = SKLabelNode(fontNamed:"Chalkduster")
        myLabel2.text = "カロリー";
        myLabel2.fontColor = UIColor.blackColor()
        myLabel2.fontSize = 65;
        myLabel2.position = CGPoint(x:CGRectGetMidX(self.frame), y:CGRectGetMidY(self.frame));
        myLabel2.name = "about2"
        
        let myLabel3 = SKLabelNode(fontNamed:"Chalkduster")
        myLabel3.text = "距離";
        myLabel3.fontColor = UIColor.blackColor()
        myLabel3.fontSize = 65;
        myLabel3.position = CGPoint(x:CGRectGetMidX(self.frame), y:self.frame.height*0.7);
        myLabel3.name = "about3"
        
        self.myLabel1 = myLabel1
        self.myLabel2 = myLabel2
        self.myLabel3 = myLabel3
        
        self.addChild(myLabel1)
        self.addChild(myLabel2)
        self.addChild(myLabel3)
    }
    
    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
        /* Called when a touch begins */
        
        for touch: AnyObject in touches{
            let location = touch.locationInNode(self)
            let touchedNode = self.nodeAtPoint(location)
            if touchedNode.name == "about1" {
                appDelegate.data = "歩数"
                next()
            }
            else if touchedNode.name == "about2" {
                appDelegate.data = "カロリー"
                next()
            }
            else if touchedNode.name == "about3" {
                appDelegate.data = "距離"
                next()
            }

        }
    }
    
    func next(){
        let tr = SKTransition.fadeWithColor(UIColor.whiteColor(), duration: 1.0)
        let newScene = RecAbout(size: self.scene!.size)
        newScene.scaleMode = SKSceneScaleMode.AspectFill
        self.scene!.view!.presentScene(newScene, transition: tr)
    }
    
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
    }
}

