//
//  ViewController.swift
//  nyaa
//
//  Created by yuya omori on 2015/09/30.
//  Copyright (c) 2015年 yuya omori. All rights reserved.
//

import UIKit
import CoreData
import AVFoundation


class DiaryViewController: UIViewController, UITableViewDelegate, UITableViewDataSource{
  var tableView: UITableView!
  
  var tableData: [Dictionary<String,AnyObject>] = []
  
  var heightLeftCell: CustomLeftTableViewCell = CustomLeftTableViewCell()
  
  var audioPlayer :AVAudioPlayer?
  override func viewDidLoad(){
    super.viewDidLoad()
    //今日の分の日記があるのかを確認します
    checkTodayDiary()
    //その後にデータベース読み込み
    var Diary = readData()
    
    let myImage: UIImage = UIImage(named: "wood_back")!
    let myImageView: UIImageView = UIImageView()
    myImageView.image = myImage
    
    myImageView.frame = CGRectMake(0, 0, myImage.size.width, myImage.size.height)
    
    self.view.addSubview(myImageView)
    
    var kanbanImage = UIImage(named: "kanban4")
    var kanban = UIImageView(frame: CGRect(x: 0, y: 0, width: kanbanImage!.size.width*0.6, height: kanbanImage!.size.height*0.6))
    kanban.image = kanbanImage
    kanban.layer.position = CGPoint(x: self.view.frame.width*0.5, y: kanbanImage!.size.height*0.3)
    self.view.addSubview(kanban)
    
    // データを初期化します
    var dateFormatter = NSDateFormatter()
    let calendar :NSCalendar! = NSCalendar(identifier: NSCalendarIdentifierGregorian)
    dateFormatter.calendar = calendar
    dateFormatter.dateFormat = "MM/dd"
    
    for data in Diary{
      var writeAt = dateFormatter.stringFromDate(data.valueForKey("writeat")! as! NSDate)
      tableData.append(["name": "にゃんこ","image": "01","created": writeAt,"message": data.valueForKey("text")!])
    }
    
    setView()
  }
  
  // VIEWをセットします
  func setView()
  {
    let statusBarHeight: CGFloat = UIApplication.sharedApplication().statusBarFrame.height+100
    let displayWidth = self.view.frame.width
    let displayHeight = self.view.frame.height
    tableView = UITableView(frame: CGRect(x:0, y:statusBarHeight, width:displayWidth, height:displayHeight - statusBarHeight))
    tableView.registerClass(CustomLeftTableViewCell.self, forCellReuseIdentifier: "CustomLeftTableViewCell")
    tableView.delegate = self
    tableView.dataSource = self
    tableView.separatorColor = UIColor.clearColor()
    tableView.backgroundColor = UIColor.clearColor()
    self.view.addSubview(tableView)
  }
  
  // テーブルセルの高さをかえします
  func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat
  {
    return heightLeftCell.setData(tableView.frame.size.width*0.8, data: self.tableData[indexPath.row])
  }
  
  // テーブルセルにデータをセットします
  func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
  {
    var cell = tableView.dequeueReusableCellWithIdentifier("CustomLeftTableViewCell", forIndexPath: indexPath) as! CustomLeftTableViewCell
    cell.setData(tableView.frame.size.width*0.8, data: self.tableData[indexPath.row])
    cell.backgroundColor = UIColor.clearColor()
    // cell内のcontentViewの背景を透過
    return cell
  }
  
  func readData() -> NSArray{
    let app: AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    let categoryContext: NSManagedObjectContext = app.managedObjectContext!
    let categoryRequest: NSFetchRequest = NSFetchRequest(entityName: "Diary")
    var error: NSError? = nil;
    var results: NSArray! = categoryContext.executeFetchRequest(categoryRequest, error: nil)
    return results!
  }
  
  func addData() {
    println("initMasters ------------")
    //plist読み込み
    let app: AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    let categoryContext: NSManagedObjectContext = app.managedObjectContext!
    
    var result: [[String]] = []
    if let csvPath = NSBundle.mainBundle().pathForResource("random", ofType: "csv") {
      let csvString = NSString(contentsOfFile: csvPath, encoding: NSUTF8StringEncoding, error: nil) as! String
      csvString.enumerateLines { (line, stop) -> () in
        result.append(line.componentsSeparatedByString(","))
      }
    }
    
    for _ in 0...15{
      
      var line = result.count
      var text: [NSString] = []
      for j in 0...2{
        var a = Int(arc4random() )
        text.append(result[a % line][j])
      }
      
      let categoryEntity: NSEntityDescription! = NSEntityDescription.entityForName(
        "Diary", inManagedObjectContext: categoryContext)
      var new_data  = NSManagedObject(entity: categoryEntity, insertIntoManagedObjectContext: categoryContext)
      
      var day = NSDate()
      new_data.setValue("\(text[0])\(text[1])\(text[2])", forKey: "text")
      new_data.setValue(day, forKey: "writeat")
      
      var error: NSError?
      categoryContext.save(&error)
      
    }
    println("InitMasters OK!")
    
  }
  
  func makeTodayDiary(){
    let app: AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    let categoryContext: NSManagedObjectContext = app.managedObjectContext!
    
    
    var result: [[String]] = []
    if let csvPath = NSBundle.mainBundle().pathForResource("random", ofType: "csv") {
      let csvString = NSString(contentsOfFile: csvPath, encoding: NSUTF8StringEncoding, error: nil) as! String
      csvString.enumerateLines { (line, stop) -> () in
        result.append(line.componentsSeparatedByString(","))
      }
    }
    
    
    var line = result.count
    var text: [NSString] = []
    for j in 0...2{
      var a = Int(arc4random() )
      text.append(result[a % line][j])
    }
    
    let categoryEntity: NSEntityDescription! = NSEntityDescription.entityForName(
      "Diary", inManagedObjectContext: categoryContext)
    var new_data  = NSManagedObject(entity: categoryEntity, insertIntoManagedObjectContext: categoryContext)
    
    var day = NSDate()
    new_data.setValue("\(text[0])\(text[1])\(text[2])", forKey: "text")
    new_data.setValue(day, forKey: "writeat")
    new_data.setValue("01", forKey: "charaimage")
    
    var error: NSError?
    categoryContext.save(&error)
    
    println("NEW DIARY CREATED")
  }
  
  func checkTodayDiary() {
    let calendar :NSCalendar! = NSCalendar(identifier: NSCalendarIdentifierGregorian)
    var today = NSDate()
    var dateFormatter = NSDateFormatter()
    dateFormatter.calendar = calendar
    dateFormatter.dateFormat = "yyyy-MM-dd"
    var String = dateFormatter.stringFromDate(today)
    dateFormatter.dateFormat = "yyyy-MM-dd hh:mm:ss"
    today = dateFormatter.dateFromString("\(String) 00:00:00")!
    var limit = NSDate(timeInterval: 60*60*24-1, sinceDate: today)
    
    let app: AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    let categoryContext: NSManagedObjectContext = app.managedObjectContext!
    let categoryRequest: NSFetchRequest = NSFetchRequest(entityName: "Diary")
    let predicate = NSPredicate(format: "SELF.writeat BETWEEN {%@, %@}", today, limit)
    categoryRequest.predicate = predicate
    
    var results: NSArray! = categoryContext.executeFetchRequest(categoryRequest, error: nil)
    if(results.count == 0){
      makeTodayDiary()
    }
  }
  
  //・・・UITableViewに必要なメソッドとか
  func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
  {
    if section == 0 {
      return tableData.count
    } else if section == 1 {
      return tableData.count
    } else {
      return 0
    }
  }
  
  override func viewWillDisappear (animated: Bool) {
    if let path = NSBundle.mainBundle().pathForResource("click", ofType: "mp3") {
      audioPlayer = AVAudioPlayer(contentsOfURL: NSURL(fileURLWithPath: path), fileTypeHint: "mp3", error: nil)
      if let sound = audioPlayer {
        sound.prepareToPlay()
        sound.play()
      }
    }
  }
  
}