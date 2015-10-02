//
//  FirstViewController.swift
//  Charting Demo
//
//  Created by Nikhil Kalra on 12/5/14.
//  Copyright (c) 2014 Nikhil Kalra. All rights reserved.
//

import UIKit
import JBChart







class FirstViewController: UIViewController, JBBarChartViewDelegate, JBBarChartViewDataSource {
    
    
    
    
    
    @IBOutlet weak var barChart: JBBarChartView!
    @IBOutlet weak var informationLabel: UILabel!
    @IBOutlet weak var data: UILabel!
    @IBOutlet weak var data2: UILabel!
    @IBOutlet weak var data3: UILabel!
    @IBOutlet weak var data4: UILabel!
    
    
    //値
    var chartData = [5002, 8031, 14543, 620, 20175, 7579, 10003]
    
    
    
    override func viewDidLoad() {
        //日付のやつ
        let Day1 = NSDate()
        let Day2: NSDate! = NSDate(timeInterval: -60*60*24*1 ,sinceDate: Day1)
        let Day3: NSDate! = NSDate(timeInterval: -60*60*24*2 ,sinceDate: Day1)
        let Day4: NSDate! = NSDate(timeInterval: -60*60*24*3 ,sinceDate: Day1)
        let Day5: NSDate! = NSDate(timeInterval: -60*60*24*4 ,sinceDate: Day1)
        let Day6: NSDate! = NSDate(timeInterval: -60*60*24*5 ,sinceDate: Day1)
        let Day7: NSDate! = NSDate(timeInterval: -60*60*24*6 ,sinceDate: Day1)
        let dateFormatter = NSDateFormatter()                                   // フォーマットの取得
        dateFormatter.locale = NSLocale(localeIdentifier: "ja_JP")  // JPロケール
        dateFormatter.dateFormat = "MM/dd"         // フォーマットの指定
        //日付のやつ
        
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        //背景の色
        view.backgroundColor = UIColor(red: 255.0/255, green: 241.0/255, blue: 210.0/255, alpha: 1.0)
        
        // bar chart setup
        barChart.backgroundColor = UIColor(red: 255.0/255, green: 241.0/255, blue: 210.0/255, alpha: 1.0)
        barChart.delegate = self
        barChart.dataSource = self
        barChart.minimumValue = 0
        barChart.maximumValue = 25000
        
        barChart.reloadData()
        
        barChart.setState(.Collapsed, animated: false)
        
        
        data.font = UIFont(name: "HiraKakuProN-W3", size: 16)
        data2.font = UIFont(name: "HiraKakuProN-W3", size: 16)
        data3.font = UIFont(name: "HiraKakuProN-W3", size: 16)
        data4.font = UIFont(name: "HiraKakuProN-W3", size: 16)
        
        data.text = "今日の消費カロリー・・・\(chartData[0]/55)カロリー"
        
        data2.text = "今日の歩数・・・\(chartData[0])歩"
        
        data3.text = "\(dateFormatter.stringFromDate(Day7))〜\(dateFormatter.stringFromDate(Day1))の平均・・・\((chartData[0]+chartData[1]+chartData[2]+chartData[3]+chartData[4]+chartData[5]+chartData[6])/7)歩"
        data4.text = "\(dateFormatter.stringFromDate(Day7))〜\(dateFormatter.stringFromDate(Day1))の燃焼カロリー・・・\((chartData[0]+chartData[1]+chartData[2]+chartData[3]+chartData[4]+chartData[5]+chartData[6])/55)kcal"
        
        }
    
    
    
    
    
    
    override func viewWillAppear(animated: Bool) {
        
        //日付のやつ
        let Day1 = NSDate()
        let Day2: NSDate! = NSDate(timeInterval: -60*60*24*1 ,sinceDate: Day1)
        let Day3: NSDate! = NSDate(timeInterval: -60*60*24*2 ,sinceDate: Day1)
        let Day4: NSDate! = NSDate(timeInterval: -60*60*24*3 ,sinceDate: Day1)
        let Day5: NSDate! = NSDate(timeInterval: -60*60*24*4 ,sinceDate: Day1)
        let Day6: NSDate! = NSDate(timeInterval: -60*60*24*5 ,sinceDate: Day1)
        let Day7: NSDate! = NSDate(timeInterval: -60*60*24*6 ,sinceDate: Day1)
        let dateFormatter = NSDateFormatter()                                   // フォーマットの取得
        dateFormatter.locale = NSLocale(localeIdentifier: "ja_JP")  // JPロケール
        dateFormatter.dateFormat = "MM/dd"         // フォーマットの指定
        //日付のやつ
        
        super.viewWillAppear(animated)
        
        var footerView = UIView(frame: CGRectMake(0, 0, barChart.frame.width, 16))
        
        //グラフの横幅を表示
        println("viewDidLoad: \(barChart.frame.width)")
        
        
        
        //グラフの横軸の値左
        var footer1 = UILabel(frame: CGRectMake(2, 0, barChart.frame.width/2 - 8, 16))
        footer1.textColor = UIColor(red: 244.0/255, green: 205.0/255, blue: 119.0/255, alpha: 1.0)
        footer1.font = UIFont(name: "HiraKakuProN-W3", size: 12)
        footer1.text = "\(dateFormatter.stringFromDate(Day7))"
        //グラフの横軸の値右
        var footer2 = UILabel(frame: CGRectMake(barChart.frame.width/7 - 1, 0, barChart.frame.width/2 - 8, 16))
        footer2.textColor = UIColor(red: 244.0/255, green: 205.0/255, blue: 119.0/255, alpha: 1.0)
        footer2.font = UIFont(name: "HiraKakuProN-W3", size: 12)
        footer2.text = "\(dateFormatter.stringFromDate(Day6))"
        footer2.textAlignment = NSTextAlignment.Left
        
        
        var footer3 = UILabel(frame: CGRectMake(barChart.frame.width/7 * 2 - 0, 0, barChart.frame.width/2 - 8, 16))
        footer3.textColor = UIColor(red: 244.0/255, green: 205.0/255, blue: 119.0/255, alpha: 1.0)
        footer3.font = UIFont(name: "HiraKakuProN-W3", size: 12)
        footer3.text = "\(dateFormatter.stringFromDate(Day5))"
        footer3.textAlignment = NSTextAlignment.Left
        
        var footer4 = UILabel(frame: CGRectMake(barChart.frame.width/7 * 3 - 0, 0, barChart.frame.width/2 - 8, 16))
        footer4.textColor = UIColor(red: 244.0/255, green: 205.0/255, blue: 119.0/255, alpha: 1.0)
        footer4.font = UIFont(name: "HiraKakuProN-W3", size: 12)
        footer4.text = "\(dateFormatter.stringFromDate(Day4))"
        footer4.textAlignment = NSTextAlignment.Left
        
        var footer5 = UILabel(frame: CGRectMake(barChart.frame.width/7 * 4 - 0, 0, barChart.frame.width/2 - 8, 16))
        footer5.textColor = UIColor(red: 244.0/255, green: 205.0/255, blue: 119.0/255, alpha: 1.0)
        footer5.font = UIFont(name: "HiraKakuProN-W3", size: 12)
        footer5.text = "\(dateFormatter.stringFromDate(Day3))"
        footer5.textAlignment = NSTextAlignment.Left
        
        var footer6 = UILabel(frame: CGRectMake(barChart.frame.width/7 * 5 - 0, 0, barChart.frame.width/2 - 8, 16))
        footer6.textColor = UIColor(red: 244.0/255, green: 205.0/255, blue: 119.0/255, alpha: 1.0)
        footer6.font = UIFont(name: "HiraKakuProN-W3", size: 12)
        footer6.text = "\(dateFormatter.stringFromDate(Day2))"
        footer6.textAlignment = NSTextAlignment.Left
        
        var footer7 = UILabel(frame: CGRectMake(barChart.frame.width/7 * 6 - 0, 0, barChart.frame.width/2 - 8, 16))
        footer7.textColor = UIColor(red: 244.0/255, green: 205.0/255, blue: 119.0/255, alpha: 1.0)
        footer7.font = UIFont(name: "HiraKakuProN-W3", size: 12)
        footer7.text = "\(dateFormatter.stringFromDate(Day1))"
        footer7.textAlignment = NSTextAlignment.Left
        
        
        
        
        footerView.addSubview(footer1)
        footerView.addSubview(footer2)
        footerView.addSubview(footer3)
        footerView.addSubview(footer4)
        footerView.addSubview(footer5)
        footerView.addSubview(footer6)
        footerView.addSubview(footer7)
        
        
        
        var header = UILabel(frame: CGRectMake(0, 0, barChart.frame.width, 50))
        header.textColor = UIColor(red: 244.0/255, green: 205.0/255, blue: 119.0/255, alpha: 1.0)
        header.font = UIFont.systemFontOfSize(24)
        header.font = UIFont(name: "HiraKakuProN-W3", size: 24)
        header.text = "記録"
        header.textAlignment = NSTextAlignment.Center
        
        barChart.footerView = footerView
        barChart.headerView = header
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        // our code
        barChart.reloadData()
        
        var timer = NSTimer.scheduledTimerWithTimeInterval(0.5, target: self, selector: Selector("showChart"), userInfo: nil, repeats: false)
    }
    
    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
        hideChart()
    }
    
    func hideChart() {
        barChart.setState(.Collapsed, animated: true)
    }
    
    func showChart() {
        barChart.setState(.Expanded, animated: true)
    }
    
    // MARK: JBBarChartView
    
    func numberOfBarsInBarChartView(barChartView: JBBarChartView!) -> UInt {
        return UInt(chartData.count)
    }
    
    func barChartView(barChartView: JBBarChartView!, heightForBarViewAtIndex index: UInt) -> CGFloat {
        return CGFloat(chartData[Int(index)])
    }
    
    func barChartView(barChartView: JBBarChartView!, colorForBarViewAtIndex index: UInt) -> UIColor! {
        return (index % 2 == 0) ? UIColor(red: 244.0/255, green: 205.0/255, blue: 119.0/255, alpha: 1.0) : UIColor(red: 244.0/255, green: 205.0/255, blue: 146.0/255, alpha: 1.0)
    }
    
    func barChartView(barChartView: JBBarChartView!, didSelectBarAtIndex index: UInt) {
        
        //日付のやつ
        let Day1 = NSDate()
        let Day2: NSDate! = NSDate(timeInterval: -60*60*24*1 ,sinceDate: Day1)
        let Day3: NSDate! = NSDate(timeInterval: -60*60*24*2 ,sinceDate: Day1)
        let Day4: NSDate! = NSDate(timeInterval: -60*60*24*3 ,sinceDate: Day1)
        let Day5: NSDate! = NSDate(timeInterval: -60*60*24*4 ,sinceDate: Day1)
        let Day6: NSDate! = NSDate(timeInterval: -60*60*24*5 ,sinceDate: Day1)
        let Day7: NSDate! = NSDate(timeInterval: -60*60*24*6 ,sinceDate: Day1)
        let dateFormatter = NSDateFormatter()                                   // フォーマットの取得
        dateFormatter.locale = NSLocale(localeIdentifier: "ja_JP")  // JPロケール
        dateFormatter.dateFormat = "MM/dd"         // フォーマットの指定
        //日付のやつ
       
        var onclick = ["\(dateFormatter.stringFromDate(Day7))", "\(dateFormatter.stringFromDate(Day6))", "\(dateFormatter.stringFromDate(Day5))", "\(dateFormatter.stringFromDate(Day4))", "\(dateFormatter.stringFromDate(Day3))", "\(dateFormatter.stringFromDate(Day2))", "\(dateFormatter.stringFromDate(Day1))"]
        
        let data = chartData[Int(index)]
        let key = onclick[Int(index)]
        
        informationLabel.textColor = UIColor(red: 244.0/255, green: 205.0/255, blue: 119.0/255, alpha: 1.0)
        informationLabel.font = UIFont.systemFontOfSize(24)
        informationLabel.font = UIFont(name: "HiraKakuProN-W3", size: 24)
        informationLabel.text = "\(key) \(data)歩"
    }
    
    func didDeselectBarChartView(barChartView: JBBarChartView!) {
        informationLabel.text = ""
    }
}

