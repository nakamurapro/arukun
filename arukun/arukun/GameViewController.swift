//
//  GameViewController.swift
//  arukun
//
//  Created by chikaratada on H27/06/10.
//  Copyright (c) 平成27年 chikaratada. All rights reserved.
//

import UIKit
import SpriteKit
import CoreData

extension SKNode {
    class func unarchiveFromFile(file : String) -> SKNode? {
      if let path = NSBundle.mainBundle().pathForResource(file, ofType: "sks") {
            var sceneData = NSData(contentsOfFile: path, options: .DataReadingMappedIfSafe, error: nil)!
            var archiver = NSKeyedUnarchiver(forReadingWithData: sceneData)

            archiver.setClass(self.classForKeyedUnarchiver(), forClassName: "SKScene")
            let scene = archiver.decodeObjectForKey(NSKeyedArchiveRootObjectKey) as! SKScene
            archiver.finishDecoding()
            return scene
        } else {
            return nil
        }
   }
}

class GameViewController: UIViewController {
    var app:AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    override func viewDidLoad() {
        super.viewDidLoad()

        if let scene = GameScene.unarchiveFromFile("GameScene") as? GameScene {
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
      let categoryContext: NSManagedObjectContext = app.managedObjectContext!
      let categoryRequest: NSFetchRequest = NSFetchRequest(entityName: "User")
      var resultPoint = categoryContext.executeFetchRequest(categoryRequest, error: nil)!
      for data in resultPoint{
        var money = data.valueForKey("money") as! Int
        money = money + (app.counter - app.i)
        data.setValue(money, forKey: "money")
        var error: NSError?
        categoryContext.save(&error)
        app.i = app.counter
      }
      viewDidLoad()
    }

}
