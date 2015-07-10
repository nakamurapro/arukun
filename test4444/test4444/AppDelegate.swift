//
//  AppDelegate.swift
//  test4444
//
//  Created by 坂本一 on 2015/07/03.
//  Copyright (c) 2015年 Hajime Sakamoto. All rights reserved.
//

import UIKit
import CoreMotion

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var myMotionManager: CMMotionManager!
    var window: UIWindow?
    var X:Double! = 1.0
    var Y:Double! = 1.0
    var Z:Double! = 1.0
    var Counter:Int! = 0
    var x:Double!
    var y:Double!
    var z:Double!

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
        return true
    }

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        myMotionManager = CMMotionManager()
        
        // 更新周期を設定.
        myMotionManager.accelerometerUpdateInterval = 1/5
        
        // 加速度の取得を開始.
        myMotionManager.startAccelerometerUpdatesToQueue(NSOperationQueue.mainQueue(), withHandler: {(accelerometerData:CMAccelerometerData!, error:NSError!) -> Void in
            
            self.x = accelerometerData.acceleration.x
            self.y = accelerometerData.acceleration.y
            self.z = accelerometerData.acceleration.z
            var CheckX = self.X - self.x
            var CheckY = self.Y - self.y
            var CheckZ = self.Z - self.z
            
            if(CheckX > 0.7 || CheckY > 0.7 || CheckZ > 0.7){
                self.Counter = self.Counter + 1
            }
            self.X = self.x; self.Y = self.y; self.Z = self.z
            
        })

    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

