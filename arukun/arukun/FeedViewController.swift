//
//  FeedViewController.swift
//  arukun
//
//  Created by 坂本一 on 2015/06/22.
//  Copyright (c) 2015年 chikaratada. All rights reserved.
//

import UIKit
import SpriteKit
import AVFoundation


class FeedViewController: UIViewController {
  
  var audioPlayer :AVAudioPlayer?
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let scene = FeedScene.unarchiveFromFile("GameScene") as? FeedScene {
            // Configure the view.
            let skView = self.view as! SKView
            skView.showsFPS = true
            skView.showsNodeCount = true
            
            /* Sprite Kit applies additional optimizations to improve rendering performance */
            skView.ignoresSiblingOrder = true
            
            /* Set the scale mode to scale to fit the window */
            scene.scaleMode = .AspectFill
            
            skView.presentScene(scene)
        }
    }
    
    override func shouldAutorotate() -> Bool {
        return true
    }
    
    override func supportedInterfaceOrientations() -> Int {
        if UIDevice.currentDevice().userInterfaceIdiom == .Phone {
            return Int(UIInterfaceOrientationMask.AllButUpsideDown.rawValue)
        } else {
            return Int(UIInterfaceOrientationMask.All.rawValue)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
  override func viewWillAppear(animated: Bool) {
    if let path = NSBundle.mainBundle().pathForResource("click", ofType: "mp3") {
      audioPlayer = AVAudioPlayer(contentsOfURL: NSURL(fileURLWithPath: path), fileTypeHint: "mp3", error: nil)
      if let sound = audioPlayer {
        sound.prepareToPlay()
        sound.play()
      }
    }
  }

}
