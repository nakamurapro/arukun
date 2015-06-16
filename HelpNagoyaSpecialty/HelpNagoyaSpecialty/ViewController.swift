//
//  ViewController.swift
//  HelpNagoyaSpecialty
//
//  Created by 坂本一 on 2015/06/13.
//  Copyright (c) 2015年 Hajime Sakamoto. All rights reserved.
//

import UIKit
import SpriteKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let scene = GameScene()
        let view = self.view as! SKView
        view.showsFPS = true
        view.showsNodeCount = true
        scene.size = view.frame.size
        view.presentScene(scene)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

