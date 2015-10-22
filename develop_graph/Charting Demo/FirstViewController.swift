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
    var data: Array<UILabel> = []
    var day: UIButton!
    var month: UIButton!
    var total :Int = 0

    //値
    var PresetData = [5002, 8031, 14543, 620, 20175, 7579, 10003] //日付毎のデータです
    var monthData = [40032, 37175, 50175, 38278, 10941, 34561, 44521] //週毎のデータです
    var chartData = [5002, 8031, 14543, 620, 20175, 7579, 10003] //表示するためのデータです
    
    var Days :Array<NSDate> = [] //NSDate型の日付
    var ShowDays :Array<String> = [] //ユーザーに見せる日付
    var footers :Array<UILabel> = []
    let dateFormatter = NSDateFormatter()
    var texts :Array<String>!
    var header :UILabel!
    
    override func viewDidLoad() {
        //日付のやつ
        dateFormatter.locale = NSLocale(localeIdentifier: "ja_JP")  // JPロケール
        dateFormatter.dateFormat = "MM/dd"         // フォーマットの指定
        for i in 0...6 {
            if i == 0{
                Days.append(NSDate())
            }else{
            Days.append( NSDate(timeInterval: -60*60*24*NSTimeInterval(i) ,sinceDate: Days[0]) )
            }
            
            ShowDays.append(dateFormatter.stringFromDate(Days[i]))
        }
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        //背景の色
        view.backgroundColor = UIColor(red: 255.0/255, green: 230.0/255, blue: 210.0/255, alpha: 1.0)
        
        // bar chart setup
        barChart.backgroundColor = UIColor(red: 255.0/255, green: 241.0/255, blue: 210.0/255, alpha: 1.0)
        barChart.delegate = self
        barChart.dataSource = self
        barChart.minimumValue = 0
        
        var max :Int = PresetData[0]
        
        for i in 1...6{
            if max < PresetData[i]{
                max = PresetData[i]
            }
        }
        barChart.maximumValue = CGFloat(max)
    
        barChart.reloadData()
        
        barChart.setState(.Collapsed, animated: false)
        
        for Data in chartData{
            total += Data
        }
        maketext(3)
        for i in 0...3{
            var y = CGFloat(i*30)
            data.append(UILabel(frame: CGRectMake(barChart.frame.origin.x, self.view.frame.height*0.6+y, barChart.frame.width, 30)))
            data[i].font = UIFont(name: "HiraKakuProN-W3", size: 13)
            data[i].text = texts[i]
            data[i].textAlignment = NSTextAlignment.Left
            self.view.addSubview(data[i])
        }
        
        makeButtons()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        var footerView = UIView(frame: CGRectMake(0, 0, barChart.frame.width, 16))
        
        //グラフの横幅を表示
        println("viewDidLoad: \(barChart.frame.width)")
        
        //グラフの横軸の値左
        for i in 0...6 {
            var x = barChart.frame.width/9 * CGFloat(i)
            footers.append(UILabel(frame: CGRectMake(x , 0, barChart.frame.width/2 - 8, 16)))
            footers[i].textColor = UIColor(red: 244.0/255, green: 205.0/255, blue: 119.0/255, alpha: 1.0)
            footers[i].font = UIFont(name: "HiraKakuProN-W3", size: 10)
            footers[i].text = ShowDays[6-i]
            footers[i].textAlignment = NSTextAlignment.Left
            footerView.addSubview(footers[i])
        }
        header = UILabel(frame: CGRectMake(0, 0, barChart.frame.width, 50))
        header.textColor = UIColor(red: 244.0/255, green: 205.0/255, blue: 119.0/255, alpha: 1.0)
        header.font = UIFont(name: "HiraKakuProN-W3", size: 24)
        header.text = "日毎の記録"
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
        
        var onclick :Array<String> = []
        for i in 0...6 {
            onclick.append(ShowDays[6-i])
        }
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
    
    func makeButtons(){
        day = UIButton(frame: CGRectMake(self.view.frame.width*0.1, 20, 100, 30))
        day.setTitle("day", forState: .Normal)
        day.setTitleColor(UIColor.cyanColor(), forState: .Normal)
        day.setTitleColor(UIColor.blackColor(), forState: .Highlighted)
        day.backgroundColor = UIColor.whiteColor()
        day.addTarget(self, action: "Change:", forControlEvents: .TouchUpInside)
        day.layer.masksToBounds = true
        day.layer.cornerRadius = 20
        day.tag = 1
        
        month = UIButton(frame: CGRectMake(self.view.frame.width*0.5, 20, 100, 30))
        month.setTitle("month", forState: .Normal)
        month.setTitleColor(UIColor.cyanColor(), forState: .Normal)
        month.setTitleColor(UIColor.blackColor(), forState: .Highlighted)
        month.backgroundColor = UIColor.whiteColor()
        month.addTarget(self, action: "Change:", forControlEvents: .TouchUpInside)
        month.layer.masksToBounds = true
        month.layer.cornerRadius = 20
        month.tag = 2
        
        self.view.addSubview(day)
        self.view.addSubview(month)
    }
    
    func Change(sender: UIButton){
        for i in 0...6 {
            if sender.tag == 1 {
                Days[i] = NSDate(timeInterval: -60*60*24*NSTimeInterval(i) ,sinceDate: Days[0])
                chartData[i] = PresetData[i]
            }else{
                Days[i] = NSDate(timeInterval: -60*60*24*NSTimeInterval(i*7) ,sinceDate: Days[0])
                chartData[i] = monthData[i]
            }
            ShowDays[i] = dateFormatter.stringFromDate(Days[i])
            footers[6-i].text = ShowDays[i]
        }
        
        var max = 0
        total = 0
        for data in chartData{
            total += data
            if max < data{
                max = data
            }
        }
        maketext(sender.tag)
        
        for i in 0...3{
            data[i].text = texts[i]
        }
        
        self.viewDidDisappear(true)
        barChart.maximumValue = CGFloat(max)
        self.viewDidAppear(true)
    }
    
    func maketext(which: Int){
        if which == 1{
            header.text =  "日毎の記録"
            texts = ["今日の消費カロリー：\(chartData[6]/55)カロリー","今日の歩数：\(chartData[6])歩","\(ShowDays[6])〜\(ShowDays[0])の平均：\(total/7)歩","\(ShowDays[6])〜\(ShowDays[0])の燃焼カロリー：\(total/55)kcal"]
        }else if which == 2 {
            header.text =  "週毎の記録"
            texts = ["今週の消費カロリー：\(chartData[6]/55)カロリー","今週の歩数：\(chartData[6])歩","\(ShowDays[6])〜\(ShowDays[0])の平均：\(total/7)歩","\(ShowDays[6])〜\(ShowDays[0])の燃焼カロリー：\(total/55)kcal"]
        }else{
            texts = ["今日の消費カロリー：\(chartData[6]/55)カロリー","今日の歩数：\(chartData[6])歩","\(ShowDays[6])〜\(ShowDays[0])の平均：\(total/7)歩","\(ShowDays[6])〜\(ShowDays[0])の燃焼カロリー：\(total/55)kcal"]
        }
    }
}

