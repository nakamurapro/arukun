//
//  ViewController.swift
//  backgroundtest
//
//  Created by 坂本一 on 2015/06/30.
//  Copyright (c) 2015年 Hajime Sakamoto. All rights reserved.
//

import UIKit
import SpriteKit

class ViewController: UIViewController {
    
    var Label = UILabel()

    override func viewDidLoad() {
        super.viewDidLoad()
        var Label = UILabel()
        Label.text = "0"
        Label.backgroundColor = UIColor(red: 1.0, green: 1.0, blue: 0.9, alpha: 1.0)
        Label.frame = CGRectMake(0, 0, 200, 50)
        Label.layer.position = CGPoint(x: self.view.frame.width*0.5, y: self.view.frame.height*0.5)
        self.Label = Label
        self.view.addSubview(Label)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func update(){
        
    }


}

