////
//  AppDelegate.swift
//  arukun
//
//  Created by chikaratada on H27/06/10.
//  Copyright (c) 平成27年 chikaratada. All rights reserved.
//

import UIKit
import CoreData
import CoreMotion

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
  
  var data:String!
  var myMotionManager: CMMotionManager!
  var window: UIWindow?
  var counter: Int = 0 //こっちが見せるやつ
  var step: Int = 0 //こっちがデータベース登録用のやつ
  var FoodFlg = false
  var backgroundFlg = false
  var i :Int = 0 //これはポイント用
  
  //ここはエサ関係
  var esaNumber :Int!
  var esaName :String!
  
  var X:Double! = 1.0
  var Y:Double! = 1.0
  var Z:Double! = 1.0
  
  func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
    // Override point for customization after application launch.
    var i : NSTimeInterval = 180
    UIApplication.sharedApplication().setMinimumBackgroundFetchInterval(i)
    
    return true
  }
  
  func application(application: UIApplication, performFetchWithCompletionHandler completionHandler: (UIBackgroundFetchResult) -> Void){
    let now = NSDate() // 現在日時の取得
    
    let dateFormatter = NSDateFormatter()
    dateFormatter.locale = NSLocale(localeIdentifier: "en_US")
    dateFormatter.dateFormat = "yyyy/MM/dd HH:mm:ss"
    
    println(dateFormatter.stringFromDate(now))
    completionHandler(UIBackgroundFetchResult.NewData)
    
  }
  
  func applicationWillResignActive(application: UIApplication) {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
  }
  
  func applicationDidEnterBackground(application: UIApplication) {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    if(backgroundFlg == false){
      NSTimer.scheduledTimerWithTimeInterval(60*60*5, target: self, selector: "UpdateCoredata:", userInfo: nil, repeats: true)
      NSTimer.scheduledTimerWithTimeInterval(10, target: self, selector: "UpdateMoney:", userInfo: nil, repeats: true)
      backgroundFlg = true
    }
  }
  
  func UpdateCoredata(timer :NSTimer){
    //今日の日付
    let categoryContext: NSManagedObjectContext = managedObjectContext!
    var day :NSDate = NSDate()
    let categoryEntity: NSEntityDescription! = NSEntityDescription.entityForName(
      "Pedometer", inManagedObjectContext: categoryContext)
    var new_data  = NSManagedObject(entity: categoryEntity, insertIntoManagedObjectContext: categoryContext)
    new_data.setValue(day, forKey: "date")
    new_data.setValue(step, forKey: "step")
    self.step = 0
    var error: NSError?
    categoryContext.save(&error)
    
  }
  
  func UpdateMoney(timer :NSTimer){
    let categoryContext: NSManagedObjectContext = managedObjectContext!
    let categoryRequest: NSFetchRequest = NSFetchRequest(entityName: "User")
    var resultPoint = categoryContext.executeFetchRequest(categoryRequest, error: nil)!
    for data in resultPoint{
      var money = data.valueForKey("money") as! Int
      money = money + (counter - i)
      data.setValue(money, forKey: "money")
      var error: NSError?
      categoryContext.save(&error)
      i = counter
    }
  }
  
  func applicationWillEnterForeground(application: UIApplication) {
  }
  
  func applicationDidBecomeActive(application: UIApplication) {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    
    self.counter = 0
    let calendar :NSCalendar! = NSCalendar(identifier: NSCalendarIdentifierGregorian)
    var today = NSDate()
    var dateFormatter = NSDateFormatter()
    dateFormatter.calendar = calendar
    dateFormatter.dateFormat = "yyyy-MM-dd"
    var String = dateFormatter.stringFromDate(today)
    dateFormatter.dateFormat = "yyyy-MM-dd hh:mm:ss"
    today = dateFormatter.dateFromString("\(String) 09:00:00")!
    
    let PedometerContext: NSManagedObjectContext = managedObjectContext!
    let PedometerRequest: NSFetchRequest = NSFetchRequest(entityName: "Pedometer")
    PedometerRequest.returnsObjectsAsFaults = false
    let predicate = NSPredicate(format: "SELF.date BETWEEN {%@, %@}", today,
      NSDate(timeInterval: 60*60*24-1, sinceDate: today))
    PedometerRequest.returnsObjectsAsFaults = false
    PedometerRequest.predicate = predicate
    var results: NSArray! = PedometerContext.executeFetchRequest(PedometerRequest, error: nil)
    for data in results {
      var step :Int = data.valueForKey("step") as! Int
      self.counter = self.counter + step
    }
    
    i = counter
    myMotionManager = CMMotionManager()
    
    // 更新周期を設定.
    myMotionManager.accelerometerUpdateInterval = 1/2
    
    // 加速度の取得を開始.
    myMotionManager.startAccelerometerUpdatesToQueue(NSOperationQueue.mainQueue(), withHandler: {(accelerometerData:CMAccelerometerData!, error:NSError!) -> Void in
      
      var x = accelerometerData.acceleration.x
      var y = accelerometerData.acceleration.y
      var z = accelerometerData.acceleration.z
      var CheckX = abs(self.X - x)
      var CheckY = abs(self.Y - y)
      var CheckZ = abs(self.Z - z)
      
      if(CheckX > 0.65 || CheckY > 0.65 || CheckZ > 0.65){
        self.counter = self.counter + 1
        self.step = self.step + 1
      }
      self.X = x; self.Y = y; self.Z = z
      
    }) //ここまで
  }
  
  func applicationWillTerminate(application: UIApplication) {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    // Saves changes in the application's managed object context before the application terminates.
    self.saveContext()
  }
  
  // MARK: - Core Data stack
  
  lazy var applicationDocumentsDirectory: NSURL = {
    // The directory the application uses to store the Core Data store file. This code uses a directory named "Hajime-Sakamoto.CoreData_DateTest" in the application's documents Application Support directory.
    let urls = NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask)
    return urls[urls.count-1] as! NSURL
    }()
  
  lazy var managedObjectModel: NSManagedObjectModel = {
    // The managed object model for the application. This property is not optional. It is a fatal error for the application not to be able to find and load its model.
    let modelURL = NSBundle.mainBundle().URLForResource("Model", withExtension: "momd")!
    return NSManagedObjectModel(contentsOfURL: modelURL)!
    }()
  
  lazy var persistentStoreCoordinator: NSPersistentStoreCoordinator? = {
    // The persistent store coordinator for the application. This implementation creates and return a coordinator, having added the store for the application to it. This property is optional since there are legitimate error conditions that could cause the creation of the store to fail.
    // Create the coordinator and store
    var coordinator: NSPersistentStoreCoordinator? = NSPersistentStoreCoordinator(managedObjectModel: self.managedObjectModel)
    let url = self.applicationDocumentsDirectory.URLByAppendingPathComponent("arukun.sqlite")
    var error: NSError? = nil
    var failureReason = "There was an error creating or loading the application's saved data."
    if coordinator!.addPersistentStoreWithType(NSSQLiteStoreType, configuration: nil, URL: url, options: nil, error: &error) == nil {
      coordinator = nil
      // Report any error we got.
      var dict = [String: AnyObject]()
      dict[NSLocalizedDescriptionKey] = "Failed to initialize the application's saved data"
      dict[NSLocalizedFailureReasonErrorKey] = failureReason
      dict[NSUnderlyingErrorKey] = error
      error = NSError(domain: "YOUR_ERROR_DOMAIN", code: 9999, userInfo: dict)
      // Replace this with code to handle the error appropriately.
      // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
      NSLog("Unresolved error \(error), \(error!.userInfo)")
      abort()
    }
    
    return coordinator
    }()
  
  lazy var managedObjectContext: NSManagedObjectContext? = {
    // Returns the managed object context for the application (which is already bound to the persistent store coordinator for the application.) This property is optional since there are legitimate error conditions that could cause the creation of the context to fail.
    let coordinator = self.persistentStoreCoordinator
    if coordinator == nil {
      return nil
    }
    var managedObjectContext = NSManagedObjectContext()
    managedObjectContext.persistentStoreCoordinator = coordinator
    return managedObjectContext
    }()
  
  // MARK: - Core Data Saving support
  
  func saveContext () {
    if let moc = self.managedObjectContext {
      var error: NSError? = nil
      if moc.hasChanges && !moc.save(&error) {
        // Replace this implementation with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
        NSLog("Unresolved error \(error), \(error!.userInfo)")
        abort()
      }
    }
  }
  
}
