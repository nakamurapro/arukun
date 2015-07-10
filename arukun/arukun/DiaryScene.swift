//
//  DiaryScene.swift
//  arukun
//
//  Created by 坂本一 on 2015/06/22.
//  Copyright (c) 2015年 chikaratada. All rights reserved.
//

import Foundation
import SpriteKit

class DiaryScene: SKScene {
    
    override func didMoveToView(view: SKView) {
        /* Setup your scene here */
        self.backgroundColor = UIColor(red: 0.7, green: 1.0, blue: 0.7, alpha: 1.0)
        let myLabel = SKLabelNode(fontNamed:"Chalkduster")
        myLabel.text = "日記";
        myLabel.fontColor = UIColor.blackColor()
        myLabel.fontSize = 65;
        myLabel.position = CGPoint(x:CGRectGetMidX(self.frame), y:CGRectGetMidY(self.frame));
        myLabel.name = "HELLO"
        
        self.addChild(myLabel)
    }
    
    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
        /* Called when a touch begins */
        
        for touch: AnyObject in touches{
            let location = touch.locationInNode(self)
            let touchedNode = self.nodeAtPoint(location)
            
            if touchedNode.name == "goBack" {
                let tr = SKTransition.crossFadeWithDuration(0.5)
                let newScene = GameScene(size: self.scene!.size)
                newScene.scaleMode = SKSceneScaleMode.AspectFill
                self.scene!.view!.presentScene(newScene, transition: tr)
            }
        }
    }
    
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
    }
}