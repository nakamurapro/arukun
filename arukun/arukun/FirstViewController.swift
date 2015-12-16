import UIKit
import JBChart
import CoreData
import Foundation
import AVFoundation

class FirstViewController: UIViewController, JBBarChartViewDelegate, JBBarChartViewDataSource {
  
  @IBOutlet weak var barChart: JBBarChartView!
  var informationLabel: UILabel!
  var data:UITextView!
  var day: UIButton!
  var previousDay :UIButton!
  var nextDay :UIButton!
  
  var week: UIButton!
  var previousWeek :UIButton!
  var nextWeek :UIButton!
  
  var total :Int = 0
  var max :Int = 0
  var nowViewing :NSTimeInterval = 0 //何周目を見てる？　例)7：一週間前　14：二週間前
  var mainColor = UIColor(red: 100/255, green: 50/255, blue: 0, alpha: 1.0)
  
  //値
  var chartData = [0,0,0,0,0,0,0]  //ユーザに見せるのはコレ
  var SetData = [1002, 2031, 643, 620, 1075, 1059, 1243, 812, 716, 1259] //データベース登録用
  
  var Days :Array<NSDate> = [] //NSDate型の日付
  var ShowDays :Array<String> = [] //ユーザーに見せる日付
  var footers :Array<UILabel> = []
  let dateFormatter = NSDateFormatter() //Date型用。
  let ShowdayFormat = NSDateFormatter() //ユーザに見せる用。
  var text :String!
  var header :UILabel!
  var results :NSArray!
  var today :NSDate! //今日の日付
  var limit :NSDate! //ここから先の日付はいりませーん！
  var playerHeight = 165.1
  var playerWeight = 58.2
  var whichViewing = false //falseなら日付毎、trueなら週毎
  var audioPlayer :AVAudioPlayer?
  
  override func viewDidLoad() {
    //日付のやつ
    //今日の日付の0時を返すには
    header = UILabel(frame: CGRectMake(0, 0, barChart.frame.width, 50))
    header.layer.position = CGPoint(x: self.view.center.x, y: self.view.frame.height*0.3)
    self.view.addSubview(header)
    
    data = UITextView(frame: CGRectMake(0, 0, barChart.frame.width-100, 80))
    data.layer.position = CGPointMake(self.view.frame.width*0.5, self.view.frame.height*0.85)
    data.backgroundColor = UIColor(red: 1, green: 227/255, blue: 178/255, alpha: 1.0)
    data.textColor = UIColor(red: 120/255, green: 97/255, blue: 56/255, alpha: 1.0)
    data.layer.cornerRadius = 20
    data.editable = false
    self.view!.addSubview(data)
    
    let calendar :NSCalendar! = NSCalendar(identifier: NSCalendarIdentifierGregorian)
    today = NSDate()
    dateFormatter.calendar = calendar
    dateFormatter.dateFormat = "yyyy-MM-dd"
    var String = dateFormatter.stringFromDate(today)
    dateFormatter.dateFormat = "yyyy-MM-dd hh:mm:ss"
    today = dateFormatter.dateFromString("\(String) 00:00:00")!
    println(today)
    limit = NSDate(timeInterval: 60*60*24, sinceDate: today)
        
    ShowdayFormat.calendar = calendar
    ShowdayFormat.dateFormat = "MM/dd"
    
    Days.append(today)
    ShowDays.append(ShowdayFormat.stringFromDate(today))
    for i in 1...6 {
      Days.append(NSDate(timeInterval: -60*60*24*NSTimeInterval(i), sinceDate: today))
      ShowDays.append(ShowdayFormat.stringFromDate(Days[i]))
    }
    super.viewDidLoad()
    
    results = readData()
    if (results.count == 0){
      initMasters()
      results = readData()
    }
    
    
    // Do any additional setup after loading the view, typically from a nib.
    
    //背景の色
    var kanbanImage = UIImage(named: "kanban1")
    var kanban = UIImageView(frame: CGRect(x: 0, y: 0, width: kanbanImage!.size.width*0.6, height: kanbanImage!.size.height*0.6))
    kanban.image = kanbanImage
    kanban.layer.position = CGPoint(x: self.view.frame.width*0.5, y: kanbanImage!.size.height*0.3)
    self.view.addSubview(kanban)
    
    
    var fontcolor = UIColor(red: 102.0/255.0, green: 53.0/255.0, blue: 19.0/255, alpha: 1.0)
    
    // bar chart setup
    barChart.backgroundColor = UIColor.clearColor()
    barChart.delegate = self
    barChart.dataSource = self
    barChart.minimumValue = 0
    
    Aggregate() //集計しまーす！
    
    barChart.reloadData()
    
    barChart.setState(.Collapsed, animated: false)
    
    for Data in chartData{
      total += Data
    }
    header.text =  "日毎の記録"
    
    data.font = UIFont(name: "HiraKakuProN-W3", size: 15)
    data.text = text
    data.textAlignment = NSTextAlignment.Left
    
    makeButtons()
    informationLabel = UILabel(frame: CGRect(x: 0, y: 0, width: self.view.frame.width*0.8, height: 60))
    informationLabel.center = CGPointMake(self.view.frame.width*0.5, self.view.frame.height*0.75)
    informationLabel.textAlignment = NSTextAlignment.Center
    self.view.addSubview(informationLabel)
  }
  
  override func viewWillAppear(animated: Bool) {
    super.viewWillAppear(animated)
    var footerView = UIView(frame: CGRectMake(0, 0, barChart.frame.width, 16))
    
    //グラフの横幅を表示
    println("viewDidLoad: \(barChart.frame.width)")
    
    //グラフの横軸の値左
    for i in 0...6 {
      var x = barChart.frame.width/7 * CGFloat(i)
      footers.append(UILabel(frame: CGRectMake(x , 0, barChart.frame.width/2 - 8, 16)))
      footers[i].textColor = UIColor(red: 120.0/255, green: 97.0/255, blue: 56.0/255, alpha: 1.0)
      footers[i].font = UIFont(name: "HiraKakuProN-W3", size: 10)
      footers[i].text = ShowDays[6-i]
      footers[i].textAlignment = NSTextAlignment.Left
      footerView.addSubview(footers[i])
    }
    //headerは1つ上で定義しています
    header.textColor = UIColor(red: 120.0/255, green: 97.0/255, blue: 56.0/255, alpha: 1.0)
    header.font = UIFont(name: "HiraKakuProN-W3", size: 24)
    header.textAlignment = NSTextAlignment.Center
    
    barChart.footerView = footerView
  }
  //ここからほとんどデータベース関連
  func readData() -> NSArray{
    println("readData ------------")
    let app: AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    let categoryContext: NSManagedObjectContext = app.managedObjectContext!
    let categoryRequest: NSFetchRequest = NSFetchRequest(entityName: "Pedometer")
    var results: NSArray! = categoryContext.executeFetchRequest(categoryRequest, error: nil)
    return results
  }
  
  func initMasters() {
    println("initMasters ------------")
    let app: AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    let categoryContext: NSManagedObjectContext = app.managedObjectContext!
    
    for(var i = 0; i<=200; i++) {
      var day :NSDate = NSDate(timeInterval: -60*60*3*NSTimeInterval(i), sinceDate: Days[0])
      let categoryEntity: NSEntityDescription! = NSEntityDescription.entityForName(
        "Pedometer", inManagedObjectContext: categoryContext)
      var new_data  = NSManagedObject(entity: categoryEntity, insertIntoManagedObjectContext: categoryContext)
      new_data.setValue(day, forKey: "date")
      new_data.setValue(SetData[i%(SetData.count)], forKey: "step")
      
      var error: NSError?
      categoryContext.save(&error)
    }
    
    
    println("InitMasters OK!")
  }
  
  //ここからほとんどグラフ関連
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
    return (index % 2 == 0) ? UIColor(red: 186/255, green: 160.0/255, blue: 113.0/255, alpha: 1.0) : UIColor(red: 159.0/255, green: 137.0/255, blue: 97.0/255, alpha: 1.0)
  }
  
  func barChartView(barChartView: JBBarChartView!, didSelectBarAtIndex index: UInt) {
    
    var onclick :Array<String> = []
    for i in 0...6 {
      onclick.append(ShowDays[6-i])
    }
    // let data = chartData[Int(index)]　わざとやります
    let data = chartData[Int(index)]
    let key = onclick[Int(index)]
    
    informationLabel.textColor = UIColor(red: 66/255, green: 32/255, blue: 16/255, alpha: 1.0)
    informationLabel.font = UIFont.systemFontOfSize(24)
    informationLabel.font = UIFont(name: "HiraKakuProN-W3", size: 24)
    var kcal = ( (playerHeight*0.40*Double(data))/100000.0 * playerWeight * 1.05)
    kcal = Double(Int(kcal * 100.0)) / 100.0
    
    playGraph()
    
    if(whichViewing == false){
      informationLabel.text = "\(key) \(data)歩"
      self.data.text =  "\(key)の消費カロリー：\(kcal)kcal\n\(key)の歩数：\(data)歩"
    }else{
      informationLabel.text = "\(key)~ \(data)歩"
      self.data.text =  "\(key)から1週間の消費カロリー：\(kcal)kcal\n\(key)から1週間の歩数：\(data)歩"
    }
  }
  
  /*func didDeselectBarChartView(barChartView: JBBarChartView!) {
  }*/
  
  //その他オリジナルメソッド
  func makeButtons(){
    
    var viewFrame = CGPoint(x: self.view.frame.width, y: self.view.frame.height)
    day = UIButton(frame: CGRectMake(0,0, 100, 30))
    day.setTitle("day", forState: .Normal)
    day.setTitleColor(mainColor, forState: .Normal)
    day.setTitleColor(UIColor.whiteColor(), forState: .Highlighted)
    day.backgroundColor = UIColor.whiteColor()
    day.addTarget(self, action: "DayButton:", forControlEvents: .TouchUpInside)
    day.layer.position = CGPoint(x: viewFrame.x*0.3, y: 130)
    day.layer.masksToBounds = true
    day.layer.cornerRadius = 20
    day.enabled = false
    
    
    previousDay = UIButton(frame: CGRectMake(0, 0, 50, 40))
    previousDay.layer.position = CGPoint(x: viewFrame.x*0.15, y: viewFrame.y*0.75)
    previousDay.backgroundColor = UIColor.whiteColor()
    previousDay.setTitle("Prev", forState: .Normal)
    previousDay.setTitleColor(mainColor, forState: .Normal)
    previousDay.setTitleColor(UIColor.orangeColor(), forState: .Highlighted)
    previousDay.addTarget(self, action: "previousDay:", forControlEvents: .TouchUpInside)
    previousDay.layer.masksToBounds = true
    previousDay.layer.cornerRadius = 20
    previousDay.contentHorizontalAlignment = .Center
    
    self.view.addSubview(previousDay)
    
    nextDay = UIButton(frame: CGRectMake(0, 0, 50, 40))
    nextDay.layer.position = CGPoint(x: viewFrame.x*0.85, y: viewFrame.y*0.75)
    nextDay.backgroundColor = UIColor.whiteColor()
    nextDay.setTitle("Next", forState: .Normal)
    nextDay.setTitleColor(mainColor, forState: .Normal)
    nextDay.setTitleColor(UIColor.orangeColor(), forState: .Highlighted)
    nextDay.addTarget(self, action: "nextDay:", forControlEvents: .TouchUpInside)
    nextDay.layer.masksToBounds = true
    nextDay.layer.cornerRadius = 20
    nextDay.hidden = true
    self.view.addSubview(nextDay)
    
    previousWeek = UIButton(frame: CGRectMake(0, 0, 50, 40))
    previousWeek.layer.position = CGPoint(x: viewFrame.x*0.15, y: viewFrame.y*0.75)
    previousWeek.backgroundColor = UIColor.whiteColor()
    previousWeek.setTitle("Prev", forState: .Normal)
    previousWeek.setTitleColor(mainColor, forState: .Normal)
    previousWeek.setTitleColor(UIColor.orangeColor(), forState: .Highlighted)
    previousWeek.addTarget(self, action: "previousWeek:", forControlEvents: .TouchUpInside)
    previousWeek.layer.masksToBounds = true
    previousWeek.layer.cornerRadius = 20
    previousWeek.hidden = true
    self.view.addSubview(previousWeek)
    
    nextWeek = UIButton(frame: CGRectMake(0, 0, 50, 40))
    nextWeek.layer.position = CGPoint(x: viewFrame.x*0.85, y: viewFrame.y*0.75)
    nextWeek.backgroundColor = UIColor.whiteColor()
    nextWeek.setTitle("Next", forState: .Normal)
    nextWeek.setTitleColor(mainColor, forState: .Normal)
    nextWeek.setTitleColor(UIColor.orangeColor(), forState: .Highlighted)
    nextWeek.addTarget(self, action: "nextWeek:", forControlEvents: .TouchUpInside)
    nextWeek.layer.masksToBounds = true
    nextWeek.layer.cornerRadius = 20
    nextWeek.hidden = true
    self.view.addSubview(nextWeek)
    
    
    week = UIButton(frame: CGRectMake(0,0, 100, 30))
    week.setTitle("week", forState: .Normal)
    week.setTitleColor(mainColor, forState: .Normal)
    week.setTitleColor(UIColor.whiteColor(), forState: .Highlighted)
    week.backgroundColor = UIColor.grayColor()
    week.addTarget(self, action: "weekButton:", forControlEvents: .TouchUpInside)
    week.layer.position = CGPoint(x: self.view.frame.width*0.7, y: 130)
    week.layer.masksToBounds = true
    week.layer.cornerRadius = 20
    week.tag = 2
    
    self.view.addSubview(day)
    self.view.addSubview(week)
  }
  
  
  //共通
  
  func Aggregate(){
    for result in results{
      var dataDay = result.valueForKey("date") as! NSDate
      var dataStep = result.valueForKey("step") as! Int
      for i in 0...6 {
        if (checkDay(limit,Day2: dataDay)){
          continue
        }
        if (checkDay(Days[i],Day2: dataDay)){
          chartData[i] += dataStep
          break
        }
      }
    }
    
    max = 0
    total = 0
    for data in chartData{
      total += data
      if max < data{
        max = data
      }
    }
    
    max = Int(Double(max)*1.5)
    barChart.maximumValue = CGFloat(max)
    chartData = chartData.reverse()
  }
  
  func checkDay(Day1 :NSDate,Day2 :NSDate) -> Bool{
    if (Day1.compare(Day2) == NSComparisonResult.OrderedAscending ||
      Day1.compare(Day2) == NSComparisonResult.OrderedSame){
        return true
    }else{
      return false
    }
  }
  
  //日付関係
  func DayButton(sender: UIButton){
    playChoose()
    day.backgroundColor = UIColor.whiteColor()
    day.enabled = false
    week.backgroundColor = UIColor.grayColor()
    week.enabled = true
    nextWeek.hidden = true
    previousWeek.hidden = true
    previousDay.hidden = false
    whichViewing = false
    nowViewing = 0
    resetDay()
  }
  
  func weekButton(sender: UIButton){
    playChoose()
    day.backgroundColor = UIColor.grayColor()
    day.enabled = true
    week.backgroundColor = UIColor.whiteColor()
    week.enabled = false
    previousDay.hidden = true
    nextDay.hidden = true
    previousWeek.hidden = false
    whichViewing = true
    nowViewing = 0
    resetWeek()
  }
  
  func previousDay(sender: UIButton){
    playClick()
    nowViewing += 1
    resetDay()
  }
  
  func nextDay(sender: UIButton){
    playClick()
    nowViewing += -1
    resetDay()
  }
  
  func previousWeek(sender: UIButton){
    playClick()
    nowViewing += 1
    resetWeek()
  }
  
  func nextWeek(sender: UIButton){
    playClick()
    nowViewing += -1
    resetWeek()
  }
  
  
  func resetDay(){  //日付でやります
    resetText()
    if (nowViewing != 0) {
      nextDay.hidden = false
    }else{
      nextDay.hidden = true
    }
    
    if (nowViewing == 5) {
      previousDay.hidden = true
    }else{
      previousDay.hidden = false
    }
    
    chartData = [0,0,0,0,0,0,0]
    Days.removeAll()
    ShowDays.removeAll()
    for i in 0...6 {
      Days.append(NSDate(timeInterval: -60*60*24*(NSTimeInterval(i)+nowViewing*7), sinceDate: today))
      ShowDays.append(ShowdayFormat.stringFromDate(Days[i]))
      footers[6-i].text = ShowDays[i]
    }
    
    limit = NSDate(timeInterval: 60*60*24, sinceDate: Days[0]) //これより新しいデータはいらない！！
    Aggregate()
    header.text =  "日毎の記録"
    self.viewDidDisappear(true)
    self.viewDidAppear(true)
  }
  
  func resetWeek(){  //今度は週毎！
    resetText()
    if (nowViewing != 0) {
      nextWeek.hidden = false
    }else{
      nextWeek.hidden = true
    }
    
    if (nowViewing == 2) {
      previousWeek.hidden = true
    }else{
      previousWeek.hidden = false
    }
    
    chartData = [0,0,0,0,0,0,0]
    Days.removeAll()
    ShowDays.removeAll()
    limit = NSDate(timeInterval: 60*60*24*(1-(7*7*nowViewing)), sinceDate: today) //これより新しいデータはいらない！！
    for i in 0...6 {
      Days.append(NSDate(timeInterval: -60*60*24*NSTimeInterval(7*(i+1)), sinceDate: limit))
      ShowDays.append(ShowdayFormat.stringFromDate(Days[i]))
      footers[6-i].text = "\(ShowDays[i])~"
    }
    
    Aggregate()
    header.text =  "週毎の記録"
    
    self.viewDidDisappear(true)
    self.viewDidAppear(true)
  }
  
  func resetText(){
    self.data.text = ""
    informationLabel.text = ""
  }
  
  override func viewWillDisappear(animated: Bool) {
    playClick()
    day.backgroundColor = UIColor.whiteColor()
    day.enabled = false
    week.backgroundColor = UIColor.grayColor()
    week.enabled = true
    results = readData()
    nowViewing = 0
    whichViewing = false
    resetDay()
    header.text =  "日毎の記録"
  }
  
  func playClick(){
    if let path = NSBundle.mainBundle().pathForResource("click", ofType: "mp3") {
      audioPlayer = AVAudioPlayer(contentsOfURL: NSURL(fileURLWithPath: path), fileTypeHint: "mp3", error: nil)
      if let sound = audioPlayer {
        sound.prepareToPlay()
        sound.play()
      }
    }
  }
  
  func playChoose(){
    if let path = NSBundle.mainBundle().pathForResource("choose", ofType: "mp3") {
      audioPlayer = AVAudioPlayer(contentsOfURL: NSURL(fileURLWithPath: path), fileTypeHint: "mp3", error: nil)
      if let sound = audioPlayer {
        sound.prepareToPlay()
        sound.play()
      }
    }
  }
  
  func playGraph(){
    if let path = NSBundle.mainBundle().pathForResource("graph", ofType: "mp3") {
      audioPlayer = AVAudioPlayer(contentsOfURL: NSURL(fileURLWithPath: path), fileTypeHint: "mp3", error: nil)
      if let sound = audioPlayer {
        sound.prepareToPlay()
        sound.play()
      }
    }
  }
  
  
}
