//
//  GameScene.swift
//  arukun
//
//  Created by chikaratada on H27/06/10.
//  Copyright (c) 平成27年 chikaratada. All rights reserved.
//

import SpriteKit

class GameScene: SKScene {
    override func didMoveToView(view: SKView) {
        /* Setup your scene here */
        self.backgroundColor = UIColor(red: 0.7, green: 0.7, blue: 1.0, alpha: 1.0)
        let myLabel = SKLabelNode(fontNamed:"Chalkduster")
        myLabel.text = "メイン画面";
        myLabel.fontColor = UIColor.blackColor()
        myLabel.fontSize = 65;
        myLabel.position = CGPoint(x:CGRectGetMidX(self.frame), y:CGRectGetMidY(self.frame));
        myLabel.name = "no"
        
        self.addChild(myLabel)

    }
    
    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
        /* Called when a touch begins */

        
    }
   
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
    }
}
