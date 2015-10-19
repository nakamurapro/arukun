//
//  ViewController.swift
//  CoreData_DateTest
//
//  Created by 坂本一 on 2015/10/18.
//  Copyright (c) 2015年 Hajime Sakamoto. All rights reserved.
//

import UIKit
import CoreData
import Foundation

class ViewController: UIViewController {
    
    //stepはデータベース埋め込み用
    var step :Array<Int> = [3000,5000,2000,2500,1000,1000,5600,7541,6154,1257,1364,8765,1315,1351,2472]
    //stepsもデータベース埋め込み用
    var steps :Int!
    
    var Days :Array<NSDate> = []
    var totalStep :Array<Int> = [0,0,0,0,0,0,0]
    
    override func viewDidLoad() {
        steps = step.count
        
        //今日の日付の0時を返すには…？
        let calendar :NSCalendar! = NSCalendar(identifier: NSCalendarIdentifierGregorian)
        var Date = NSDate()
        let dateFormatter = NSDateFormatter()
        dateFormatter.calendar = calendar
        dateFormatter.dateFormat = "yyyy-MM-dd"
        var String = dateFormatter.stringFromDate(Date)
        dateFormatter.dateFormat = "yyyy-MM-dd hh:mm:ss"
        Date = dateFormatter.dateFromString("\(String) 00:00:00")!
        //返し終わり。でも現段階だと今日の15:00が返ってくるのであとで修正…
        
        Days.append(Date)
        for i in 1...6 {
            Days.append(NSDate(timeInterval: -60*60*24*NSTimeInterval(i), sinceDate: Days[0]))
        }
        
        super.viewDidLoad()
        var results:NSArray = readData()
        if(results.count == 0) {
            initMasters()
        }
        
        /*  Date1.compare(Date2) == NSComparisonResult.OrderedAscending では、
        Date2 > Date1ならtrueが、 (Date2の方が未来)
        Date2 < Date1ならfalseが返ってくる。*/
        for result in results{
            var dataDay = result.valueForKey("date") as! NSDate
            var dataStep = result.valueForKey("step") as! Int
            println("\(dataDay),\(dataStep)")
            for i in 0...6 {
                if (Days[i].compare(dataDay) == NSComparisonResult.OrderedAscending){
                    totalStep[i] += dataStep
                    break
                }
            }
        }
        
        for step in totalStep{
            println(step)
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func readData() -> NSArray{
        println("readData ------------")
        let app: AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let categoryContext: NSManagedObjectContext = app.managedObjectContext!
        let categoryRequest: NSFetchRequest = NSFetchRequest(entityName: "Date")
        
        var results: NSArray! = categoryContext.executeFetchRequest(categoryRequest, error: nil)
        return results
    }
    
    func initMasters() {
        println("initMasters ------------")
        let app: AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let categoryContext: NSManagedObjectContext = app.managedObjectContext!
        
        //Seed.plistを元にしてPersonというエンティティに値を入れていく
        for(var i = 0; i<=100; i++) {
            var day :NSDate = NSDate(timeInterval: -60*60*3*NSTimeInterval(i), sinceDate: Days[0])
            let categoryEntity: NSEntityDescription! = NSEntityDescription.entityForName(
                "Date", inManagedObjectContext: categoryContext)
            var new_data  = NSManagedObject(entity: categoryEntity, insertIntoManagedObjectContext: categoryContext)
            new_data.setValue(day, forKey: "date")
            new_data.setValue(step[i%steps], forKey: "step")
            
            var error: NSError?
            categoryContext.save(&error)
        }
        
        
        println("------------")
    }
}

