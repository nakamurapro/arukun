import UIKit
import JBChart
import CoreData
import Foundation

class FirstViewController: UIViewController, JBBarChartViewDelegate, JBBarChartViewDataSource {
  
  @IBOutlet weak var barChart: JBBarChartView!
  var informationLabel: UILabel!
  var data: Array<UILabel> = []
  var day: UIButton!
  var previousDay :UIButton!
  var nextDay :UIButton!
  
  var week: UIButton!
  var previousWeek :UIButton!
  var nextWeek :UIButton!
  
  var total :Int = 0
  var max :Int = 0
  var nowViewing :NSTimeInterval = 0 //何周目を見てる？　例)7：一週間前　14：二週間前
  
  //値
  var chartData = [0,0,0,0,0,0,0]  //ユーザに見せるのはコレ
  var SetData = [1002, 2031, 643, 620, 1075, 1059, 1243, 812, 716, 1259] //データベース登録用
  
  var Days :Array<NSDate> = [] //NSDate型の日付
  var ShowDays :Array<String> = [] //ユーザーに見せる日付
  var footers :Array<UILabel> = []
  let dateFormatter = NSDateFormatter() //Date型用。
  let ShowdayFormat = NSDateFormatter() //ユーザに見せる用。
  var texts :Array<String>!
  var header :UILabel!
  var results :NSArray!
  var today :NSDate! //今日の日付
  var limit :NSDate! //ここから先の日付はいりませーん！
  
  override func viewDidLoad() {
    //日付のやつ
    //今日の日付の0時を返すには…？

    let calendar :NSCalendar! = NSCalendar(identifier: NSCalendarIdentifierGregorian)
    today = NSDate()
    dateFormatter.calendar = calendar
    dateFormatter.dateFormat = "yyyy-MM-dd"
    var String = dateFormatter.stringFromDate(today)
    dateFormatter.dateFormat = "yyyy-MM-dd hh:mm:ss"
    today = dateFormatter.dateFromString("\(String) 09:00:00")!
    limit = NSDate(timeInterval: 60*60*24, sinceDate: today)
    
    //返し終わり。でも現段階だと今日の15:00が返ってくるのであとで修正…
    
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
    view.backgroundColor = UIColor(red: 255.0/255, green: 230.0/255, blue: 210.0/255, alpha: 1.0)
    
    // bar chart setup
    barChart.backgroundColor = UIColor(red: 255.0/255, green: 241.0/255, blue: 210.0/255, alpha: 1.0)
    barChart.delegate = self
    barChart.dataSource = self
    barChart.minimumValue = 0
    
    Aggregate() //集計しまーす！
    
    barChart.reloadData()
    
    barChart.setState(.Collapsed, animated: false)
    
    for Data in chartData{
      total += Data
    }
    header = UILabel(frame: CGRectMake(0, 0, barChart.frame.width, 50))
    maketext(1)
    for i in 0...3{
      var y = CGFloat(i*40)
      data.append(UILabel(frame: CGRectMake(barChart.frame.origin.x, self.view.frame.height*0.7+y, barChart.frame.width, 30)))
      data[i].font = UIFont(name: "HiraKakuProN-W3", size: 15)
      data[i].text = texts[i]
      data[i].textAlignment = NSTextAlignment.Left
      self.view.addSubview(data[i])
    }
    
    makeButtons()
    informationLabel = UILabel(frame: CGRect(x: 0, y: 0, width: self.view.frame.width*0.8, height: 60))
    informationLabel.center = CGPointMake(self.view.frame.width*0.5, self.view.frame.height*0.65)
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
      footers[i].textColor = UIColor(red: 190.0/255, green: 160.0/255, blue: 70.0/255, alpha: 1.0)
      footers[i].font = UIFont(name: "HiraKakuProN-W3", size: 10)
      footers[i].text = ShowDays[6-i]
      footers[i].textAlignment = NSTextAlignment.Left
      footerView.addSubview(footers[i])
    }
    //headerは1つ上で定義しています
    header.textColor = UIColor(red: 244.0/255, green: 205.0/255, blue: 119.0/255, alpha: 1.0)
    header.font = UIFont(name: "HiraKakuProN-W3", size: 24)
    header.textAlignment = NSTextAlignment.Center
    
    barChart.footerView = footerView
    barChart.headerView = header
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
    return (index % 2 == 0) ? UIColor(red: 244.0/255, green: 205.0/255, blue: 119.0/255, alpha: 1.0) : UIColor(red: 244.0/255, green: 205.0/255, blue: 146.0/255, alpha: 1.0)
  }
  
  func barChartView(barChartView: JBBarChartView!, didSelectBarAtIndex index: UInt) {
    
    var onclick :Array<String> = []
    for i in 0...6 {
      onclick.append(ShowDays[6-i])
    }
    // let data = chartData[Int(index)]　わざとやります
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
  
  //その他オリジナルメソッド
  func makeButtons(){
    day = UIButton(frame: CGRectMake(self.view.frame.width*0.1, 30, 100, 30))
    day.setTitle("day", forState: .Normal)
    day.setTitleColor(UIColor.cyanColor(), forState: .Normal)
    day.setTitleColor(UIColor.blackColor(), forState: .Highlighted)
    day.backgroundColor = UIColor.whiteColor()
    day.addTarget(self, action: "DayButton:", forControlEvents: .TouchUpInside)
    day.layer.masksToBounds = true
    day.layer.cornerRadius = 20
    
    previousDay = UIButton(frame: CGRectMake(self.view.frame.width*0.05, self.view.frame.height*0.6, 50, 50))
    previousDay.setTitle("Previous", forState: .Normal)
    previousDay.setTitleColor(UIColor(red: 100/255, green: 50/255, blue: 0, alpha: 1.0), forState: .Normal)
    previousDay.setTitleColor(UIColor.orangeColor(), forState: .Highlighted)
    previousDay.backgroundColor = UIColor.clearColor()
    previousDay.addTarget(self, action: "previousDay:", forControlEvents: .TouchUpInside)
    previousDay.layer.masksToBounds = true
    previousDay.sizeToFit()
    self.view.addSubview(previousDay)
    
    nextDay = UIButton(frame: CGRectMake(self.view.frame.width*0.75, self.view.frame.height*0.6, 50, 30))
    nextDay.setTitle("Next", forState: .Normal)
    nextDay.setTitleColor(UIColor(red: 100/255, green: 50/255, blue: 0, alpha: 1.0), forState: .Normal)
    nextDay.setTitleColor(UIColor.orangeColor(), forState: .Highlighted)
    nextDay.backgroundColor = UIColor.clearColor()
    nextDay.addTarget(self, action: "nextDay:", forControlEvents: .TouchUpInside)
    nextDay.layer.masksToBounds = true
    nextDay.sizeToFit()
    nextDay.hidden = true
    self.view.addSubview(nextDay)
    
    previousWeek = UIButton(frame: CGRectMake(self.view.frame.width*0.05, self.view.frame.height*0.6, 50, 50))
    previousWeek.setTitle("Previous", forState: .Normal)
    previousWeek.setTitleColor(UIColor(red: 100/255, green: 50/255, blue: 0, alpha: 1.0), forState: .Normal)
    previousWeek.setTitleColor(UIColor.orangeColor(), forState: .Highlighted)
    previousWeek.backgroundColor = UIColor.clearColor()
    previousWeek.addTarget(self, action: "previousWeek:", forControlEvents: .TouchUpInside)
    previousWeek.layer.masksToBounds = true
    previousWeek.sizeToFit()
    previousWeek.hidden = true
    self.view.addSubview(previousWeek)
    
    nextWeek = UIButton(frame: CGRectMake(self.view.frame.width*0.75, self.view.frame.height*0.6, 50, 30))
    nextWeek.setTitle("Next", forState: .Normal)
    nextWeek.setTitleColor(UIColor(red: 100/255, green: 50/255, blue: 0, alpha: 1.0), forState: .Normal)
    nextWeek.setTitleColor(UIColor.orangeColor(), forState: .Highlighted)
    nextWeek.backgroundColor = UIColor.clearColor()
    nextWeek.addTarget(self, action: "nextWeek:", forControlEvents: .TouchUpInside)
    nextWeek.layer.masksToBounds = true
    nextWeek.sizeToFit()
    nextWeek.hidden = true
    self.view.addSubview(nextWeek)
    
    
    week = UIButton(frame: CGRectMake(self.view.frame.width*0.5, 30, 100, 30))
    week.setTitle("week", forState: .Normal)
    week.setTitleColor(UIColor.cyanColor(), forState: .Normal)
    week.setTitleColor(UIColor.blackColor(), forState: .Highlighted)
    week.backgroundColor = UIColor.whiteColor()
    week.addTarget(self, action: "weekButton:", forControlEvents: .TouchUpInside)
    week.layer.masksToBounds = true
    week.layer.cornerRadius = 20
    week.tag = 2
    
    self.view.addSubview(day)
    self.view.addSubview(week)
  }
  
  func maketext(which: Int){
    if which == 1{
      header.text =  "日毎の記録"
      texts = ["今日の消費カロリー：\(chartData[6]/55)カロリー","今日の歩数：\(chartData[6])歩","\(ShowDays[6])〜\(ShowDays[0])の平均：\(total/7)歩","\(ShowDays[6])〜\(ShowDays[0])の燃焼カロリー：\(total/55)kcal"]
    }else if which == 2 {
      var textLimit = NSDate(timeInterval: -60*60*24, sinceDate: limit)
      var text = ShowdayFormat.stringFromDate(textLimit)
      header.text =  "週毎の記録"
      texts = ["今週の消費カロリー：\(chartData[6]/55)カロリー","今週の歩数：\(chartData[6])歩","\(ShowDays[6])〜\(text)の平均：\(total/7)歩","\(ShowDays[6])〜\(text)の燃焼カロリー：\(total/55)kcal"]
    }
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
    nextWeek.hidden = true
    previousWeek.hidden = true
    previousDay.hidden = false
    nowViewing = 0
    resetDay()
  }
  
  func weekButton(sender: UIButton){
    previousDay.hidden = true
    nextDay.hidden = true
    previousWeek.hidden = false
    nowViewing = 0
    resetWeek()
  }
  
  func previousDay(sender: UIButton){
    nowViewing += 1
    resetDay()
  }
  
  func nextDay(sender: UIButton){
    nowViewing += -1
    resetDay()
  }
  
  func previousWeek(sender: UIButton){
    nowViewing += 1
    resetWeek()
  }
  
  func nextWeek(sender: UIButton){
    nowViewing += -1
    resetWeek()
  }
  
  
  func resetDay(){  //日付でやります
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
    maketext(1)
    
    for i in 0...3{
      data[i].text = texts[i]
    }
    
    self.viewDidDisappear(true)
    self.viewDidAppear(true)
  }
  
  func resetWeek(){  //今度は週毎！
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
    maketext(2)
    
    for i in 0...3{
      data[i].text = texts[i]
    }
    
    self.viewDidDisappear(true)
    self.viewDidAppear(true)
  }
  
  override func viewWillDisappear(animated: Bool) {
    results = readData()
    nowViewing = 0
    resetDay()
    maketext(1)
  }

}
