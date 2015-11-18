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
    
    var result: [[String]] = []
    if let csvPath = NSBundle.mainBundle().pathForResource("random", ofType: "csv") {
      let csvString = NSString(contentsOfFile: csvPath, encoding: NSUTF8StringEncoding, error: nil) as! String
      csvString.enumerateLines { (line, stop) -> () in
        result.append(line.componentsSeparatedByString(","))
      }
    }
    
    var line = result.count
    var text: [NSString] = []
    for _ in 0...19{
      for i in 0...2{
        var a = Int(arc4random() )
        text.append(result[a % line][i])
      }
      println("\(text[0])\(text[1])\(text[2]) \n")
      text.removeAll(keepCapacity: true)
    }
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
    
    // plist の読み込み開始
    let path:NSString = NSBundle.mainBundle().pathForResource("Seed", ofType: "plist")!
    var masterDataDictionary:NSDictionary = NSDictionary(contentsOfFile: path as String)!
    //ここまで
    
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
    //SELECT * FROM...
    let appDel: AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    let PersonContext: NSManagedObjectContext = appDel.managedObjectContext!
    let PersonRequest: NSFetchRequest = NSFetchRequest(entityName: "Person")
    PersonRequest.returnsObjectsAsFaults = false
    
    //Where...
    let predicate = NSPredicate(format: "%K < %d", "age", 21)
    //let predicate = NSPredicate(format: "%K = %d", "makeat", "2015-05-20")
    PersonRequest.predicate = predicate
    
    //検索！
    var results: NSArray! = PersonContext.executeFetchRequest(PersonRequest, error: nil)
    
    //デバッグ用
    println("できたかな？")
    println(results)
    
    
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

