//
//  RecAbout.swift
//  arukun
//
//  Created by 坂本一 on 2015/06/24.
//  Copyright (c) 2015年 chikaratada. All rights reserved.
//

import Foundation
import SpriteKit

class RecAbout: SKScene {
    var appDelegate:AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate

    override func didMoveToView(view: SKView) {
        /* Setup your scene here */
        var message = appDelegate.data
        self.backgroundColor = UIColor(red: 1.0, green: 0.8, blue: 0.5, alpha: 1.0)
        let myLabel1 = SKLabelNode(fontNamed:"Chalkduster")
        myLabel1.text = "\(message)の詳細"
        myLabel1.fontColor = UIColor.blackColor()
        myLabel1.fontSize = 40;
        myLabel1.position = CGPoint(x:CGRectGetMidX(self.frame), y:self.frame.height*0.7);

        self.addChild(myLabel1)
        
        var backTexture = SKTexture(imageNamed: "1179")
        var backButton = SKSpriteNode(texture: backTexture)
        backButton.size = CGSize(width: backTexture.size().width*0.3, height: backTexture.size().height*0.3)
        backButton.position = CGPointMake(self.size.width*0.3, self.size.height*0.3)
        backButton.name = "goback"
        
        self.addChild(backButton)

    }
    
    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
        /* Called when a touch begins */
        
        for touch: AnyObject in touches{
            let location = touch.locationInNode(self)
            let touchedNode = self.nodeAtPoint(location)
            if touchedNode.name == "goback" {
                let tr = SKTransition.fadeWithColor(UIColor.whiteColor(), duration: 1.0)
                let newScene = RecScene(size: self.scene!.size)
                newScene.scaleMode = SKSceneScaleMode.AspectFill
                self.scene!.view!.presentScene(newScene, transition: tr)
            }
            
        }
    }
    

    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
    }
}
