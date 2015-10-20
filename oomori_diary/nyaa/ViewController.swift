//
//  ViewController.swift
//  nyaa
//
//  Created by yuya omori on 2015/09/30.
//  Copyright (c) 2015年 yuya omori. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource
{
    var tableView: UITableView!
    
    var tableData: [Dictionary<String,AnyObject>]!
    
    var heightLeftCell: CustomLeftTableViewCell = CustomLeftTableViewCell()
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        let myImage: UIImage = UIImage(named: "23.jpg")!
        let myImageView: UIImageView = UIImageView()
        myImageView.image = myImage
        
        myImageView.frame = CGRectMake(-150, -10, myImage.size.width, myImage.size.height)
        
        self.view.addSubview(myImageView)
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "23.jpg")!)
        
        
        
        // データを初期化します
        tableData = [
            ["name": "にゃんこ1", "type": 1, "image": "23.jpg", "created": "昨日", "message": "おはようございます\nねむいにゃん"],
            ["name": "にゃんこ2", "type": 2, "image": "23.jpg", "created": "今日", "message": "おはよー\nさむくなってきたね"],
            ["name": "にゃんこ3", "type": 3, "image": "23.jpg", "created": "今日", "message": "おはよー\n今日も頑張ろう！"],
            ["name": "にゃんこ4", "type": 4, "image": "23.jpg", "created": "今日", "message": "こんちゃーす\nさむくなってきたね"],
            ["name": "にゃんこ5", "type": 5, "image": "23.jpg", "created": "今日", "message": "どーも\nさむくなってきたね"],
            ["name": "にゃんこ6", "type": 6, "image": "23.jpg", "created": "今日", "message": "おはよー\nさむくなってきたね"],
            ["name": "にゃんこ7", "type": 7, "image": "23.jpg", "created": "今日", "message": "おはよー\nさむくなってきたね"],
        ]
        
        // VIEWをセットします
        setView()
    }
    
    // VIEWをセットします
    func setView()
    {
        let statusBarHeight: CGFloat = UIApplication.sharedApplication().statusBarFrame.height
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
        1 == self.tableData[indexPath.row]["type"] as! Int
        return heightLeftCell.setData(tableView.frame.size.width - 20, data: self.tableData[indexPath.row])
    }
    
    // テーブルセルにデータをセットします
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        1 == self.tableData[indexPath.row]["type"] as! Int
        var cell = tableView.dequeueReusableCellWithIdentifier("CustomLeftTableViewCell", forIndexPath: indexPath) as! CustomLeftTableViewCell
        cell.setData(tableView.frame.size.width - 20, data: self.tableData[indexPath.row])
        cell.backgroundColor = UIColor.clearColor()
        // cell内のcontentViewの背景を透過
        return cell
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
}