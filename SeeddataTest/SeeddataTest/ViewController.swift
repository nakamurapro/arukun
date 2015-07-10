//
//  ViewController.swift
//  SeeddataTest
//
//  Created by 坂本一 on 2015/07/10.
//  Copyright (c) 2015年 Hajime Sakamoto. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        var results:NSArray = readData()
        
        if(results.count == 0) {
            // 初期データーの投入
            initMasters()
            results = readData()
        }
        println(results[0].name)
        println(results[1].name)
        println(results[2].name)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func readData() -> NSArray{
        //println("readData ------------")
        let app: AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let categoryContext: NSManagedObjectContext = app.managedObjectContext!
        let categoryRequest: NSFetchRequest = NSFetchRequest(entityName: "Entity")
        
        var results: NSArray! = categoryContext.executeFetchRequest(categoryRequest, error: nil)
        //for data in results {
        //    println("------------")
        //    println(data.name)
        //    println("------------")
        //}
        
        return results
    }
    
    func initMasters() {
        println("initMasters ------------")
        
        // plist の読み込み
        let path:NSString = NSBundle.mainBundle().pathForResource("Seed", ofType: "plist")!
        
        var masterDataDictionary:NSDictionary = NSDictionary(contentsOfFile: path as String)!
        
        
        let app: AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let categoryContext: NSManagedObjectContext = app.managedObjectContext!
        
        for(var i = 1; i<=masterDataDictionary.count; i++) {
            let index_name: String = "Item" + String(i)
            var item: AnyObject = masterDataDictionary[index_name]!
            
            let categoryEntity: NSEntityDescription! = NSEntityDescription.entityForName(
                "Entity", inManagedObjectContext: categoryContext)
            var new_data  = NSManagedObject(entity: categoryEntity, insertIntoManagedObjectContext: categoryContext)
            new_data.setValue(item["name"] as! String, forKey: "name")
            
            var error: NSError?
            categoryContext.save(&error)
        }
        
        
        println("------------")
    }
    
}

