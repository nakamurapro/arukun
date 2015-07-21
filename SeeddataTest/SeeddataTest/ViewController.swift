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
    //年齢・名前・作成日をまとめておくための配列を用意
    var ages: [Int] = []
    var names: [NSString] = []
    var makeats: [NSString] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        var results:NSArray = readData()
        if(results.count == 0) {
            initMasters()
        }
        putData()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func readData() -> NSArray{
        //Personエンティティにデータはいくつあるのか？
        //println("readData ------------")
        let app: AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let categoryContext: NSManagedObjectContext = app.managedObjectContext!
        let categoryRequest: NSFetchRequest = NSFetchRequest(entityName: "Person")
        
        var results: NSArray! = categoryContext.executeFetchRequest(categoryRequest, error: nil)
        return results
    }
    
    func initMasters() {
        println("initMasters ------------")
        
        // plist の読み込み
        let path:NSString = NSBundle.mainBundle().pathForResource("Seed", ofType: "plist")!
        
        var masterDataDictionary:NSDictionary = NSDictionary(contentsOfFile: path as String)!
        
        let app: AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let categoryContext: NSManagedObjectContext = app.managedObjectContext!
        
        //Seed.plistを元にしてPersonというエンティティに値を入れていく
        for(var i = 1; i<=masterDataDictionary.count; i++) {
            let index_name: String = "Item" + String(i)
            var item: AnyObject = masterDataDictionary[index_name]!
            
            let categoryEntity: NSEntityDescription! = NSEntityDescription.entityForName(
                "Person", inManagedObjectContext: categoryContext)
            var new_data  = NSManagedObject(entity: categoryEntity, insertIntoManagedObjectContext: categoryContext)
            new_data.setValue(item["name"] as! String, forKey: "name")
            new_data.setValue(item["age"], forKey: "age")
            new_data.setValue(item["makeat"], forKey: "makeat")
            
            var error: NSError?
            categoryContext.save(&error)
        }
        
        
        println("------------")
    }
    
    func putData(){
        let appDel: AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let PersonContext: NSManagedObjectContext = appDel.managedObjectContext!
        let PersonRequest: NSFetchRequest = NSFetchRequest(entityName: "Person")
        PersonRequest.returnsObjectsAsFaults = false
        var results: NSArray! = PersonContext.executeFetchRequest(PersonRequest, error: nil)
        
        ages = []
        names = []
        makeats = []
        
        //NSDate型をCoreDataに入れてそのまま取り出すと"yyyy-MM-dd hh:mm:ss +????"になる。
        //これをわかりやすくするために"yyyy年MM月dd日"のフォーマットに変更。
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyy年MM月dd日"
        
        //配列に対してCoreDataのレコードを1つずつ入れていく
        //"~~.valueForKey("ATTRIBUTEの名前") as! 型"で1つのレコードに対する値が収録出来る
        for data in results {
            names.append(data.valueForKey("name") as! String)
            ages.append(data.valueForKey("age") as! Int)
            
            //CoreDataから取り出したNSDataを先ほどのdateFormatterでフォーマットの変更
            var day = dateFormatter.stringFromDate(data.valueForKey("makeat") as! NSDate)
            makeats.append(day)
        }
        //3要素を取り出す
        println(names)
        println(ages)
        println(makeats)
    }
    
}

