//
//  ViewController.swift
//  SeedDataTest2
//
//  Created by 坂本一 on 2015/07/16.
//  Copyright (c) 2015年 Hajime Sakamoto. All rights reserved.
//
import UIKit
import CoreData

class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //var results:NSArray = readData()
        
        //if(results.count == 0) {
            // 初期データーの投入
            //initMasters()
            readData()
            //results = readData()
        //}
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //func readData() -> NSArray{
    func readData(){
        println("readData ------------")
        let appDel: AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let myContext: NSManagedObjectContext = appDel.managedObjectContext!
        let myRequest: NSFetchRequest = NSFetchRequest(entityName: "People")
        myRequest.returnsObjectsAsFaults = false
        var myResults: NSArray! = myContext.executeFetchRequest(myRequest, error: nil)
        
        for myData in myResults {
            var people: People
        }
    }
    
    func initMasters() {
        println("initMasters ------------")
        
        // plist の読み込み
        let path:NSString = NSBundle.mainBundle().pathForResource("MasterData", ofType: "plist")!
        
        var masterDataDictionary:NSDictionary = NSDictionary(contentsOfFile: path as! String)!
        
        
        let app: AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let categoryContext: NSManagedObjectContext = app.managedObjectContext!
        
        for(var i = 1; i<=masterDataDictionary.count; i++) {
            let index_name: String = "People" + String(i)
            var item: AnyObject = masterDataDictionary[index_name]!
            
            
            
            let appDel: AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
            let memoContext: NSManagedObjectContext = appDel.managedObjectContext!
            let memoEntity: NSEntityDescription! = NSEntityDescription.entityForName("People", inManagedObjectContext: memoContext)
            var newData = People(entity: memoEntity, insertIntoManagedObjectContext: memoContext)
            
            newData.name = item["name"] as! String
            newData.age = item["age"] as! Int
            newData.makeat = item["makeat"] as! NSDate
            
            var error: NSError?
            categoryContext.save(&error)
        }
        
        
        println("------------")
    }
}