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
    var flg = false
    var counter = 0

    override func didMoveToView(view: SKView) {
        /* Setup your scene here */
        self.backgroundColor = UIColor.whiteColor()
        let myLabel1 = SKLabelNode(fontNamed:"Courier")
        myLabel1.text = "";
        myLabel1.fontSize = 50;
        myLabel1.fontColor = UIColor.redColor()
        myLabel1.position = CGPoint(x:CGRectGetMidX(self.frame), y:CGRectGetMidY(self.frame));
        self.myLabel1 = myLabel1
        self.addChild(myLabel1)
        
        let myLabel2 = SKLabelNode(fontNamed:"Courier")
        myLabel2.text = "";
        myLabel2.fontSize = 30;
        myLabel2.fontColor = UIColor.greenColor()
        myLabel2.position = CGPoint(x:CGRectGetMidX(self.frame), y:CGRectGetMidY(self.frame)*0.5);
        self.addChild(myLabel2)
        
        self.backgroundColor = UIColor.whiteColor()
        let myLabel3 = SKLabelNode(fontNamed:"Courier")
        myLabel3.text = "";
        myLabel3.fontSize = 50;
        myLabel3.fontColor = UIColor.blueColor()
        myLabel3.position = CGPoint(x:CGRectGetMidX(self.frame), y:CGRectGetMidY(self.frame)*1.3);
        self.myLabel1 = myLabel1
        self.addChild(myLabel3)
        
        myMotionManager = CMMotionManager()
        
        // 更新周期を設定.
        myMotionManager.accelerometerUpdateInterval = 1/6
        
        // 加速度の取得を開始.
        myMotionManager.startAccelerometerUpdatesToQueue(NSOperationQueue.mainQueue(), withHandler: {(accelerometerData:CMAccelerometerData!, error:NSError!) -> Void in
            
            var x = accelerometerData.acceleration.x
            var y = accelerometerData.acceleration.y
            var z = accelerometerData.acceleration.z

            var com = sqrt(pow(x,2)+pow(y,2)+pow(z,2))
            myLabel2.text = "\(com)"
            
            if(self.flg == false){
                if(com > 1.2){
                   self.flg = true
                }
            }else{
                if(com > 0.9){
                    self.flg = false
                    self.counter = self.counter + 1
                }
            }
            
            myLabel3.text = "\(self.counter)歩"
        })

        
    }
    
    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
        /* Called when a touch begins */
        
    }
   
    override func update(currentTime: CFTimeInterval) {
        self.myLabel1.text = "\(XXXX.Counter)歩"
    }
}
