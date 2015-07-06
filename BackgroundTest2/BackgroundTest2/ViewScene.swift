//
//  ViewScene.swift
//  BackgroundTest2
//
//  Created by 坂本一 on 2015/07/02.
//  Copyright (c) 2015年 Hajime Sakamoto. All rights reserved.
//

import Foundation
import SpriteKit


class ViewScene: SKScene {
    
    var app:AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    var Label = UILabel()
    
    override func didMoveToView(view: SKView) {
        var Label = UILabel()
        backgroundColor = UIColor.whiteColor()
        Label.text = "0"
        Label.backgroundColor = UIColor(red: 1.0, green: 1.0, blue: 0.9, alpha: 1.0)
        Label.frame = CGRectMake(0, 0, 200, 50)
        Label.layer.position = CGPoint(x: view.frame.width*0.5, y: view.frame.height*0.5)
        Label.textAlignment = NSTextAlignment.Center
        self.Label = Label
        view.addSubview(Label)
        
    }
    
    override func update(currentTime: NSTimeInterval) {
       Label.text = toString(app.counter)
    }
    
    
}