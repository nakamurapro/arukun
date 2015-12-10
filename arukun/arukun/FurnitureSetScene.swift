import Foundation
import UIKit
import SpriteKit
import CoreData

class FurnitureSetScene: SKScene {
  var Scroll: UIScrollView!
  var phoneSize :CGSize = UIScreen.mainScreen().bounds.size //画面サイズ
  private var TextFurniture :UITextView! //テキスト
  private var WindowText :UITextView!
  private var myTextView :UITextView! //家具の名前
  private var imageViews :Array<UIImageView> = [] //これは商品一覧
  var RoomFurniture :Array<UIImageView> = [] //これは置いてある家具
  var SetButtons :Array<UIButton> = []
  var backSetButton :UIButton! //戻るボタン
  var removeButton :UIButton! //家具取り除く！
  var cancelButton :UIButton! //やっぱり取り除かない。
  var Backgroundcancel :UIButton!
  var backButton :UIButton!
  var ShowRoomButton :UIButton!
  var BackgroundSet :UIButton! //背景を設定します１
  var backView :UIImageView! //背景
  var Images :Array<UIImage> = []
  var dammy :UIImage! //何も置いてない時
  
  var places = ["左上","右上","左下","右下"]
  var OnePlace :Int!  //場所を1つ。家具をどかす時に使う。
  var SetFlug :Bool = false //家具置いてるところかどうか
  private var myWindow = UIWindow(frame: CGRectMake(0, 0, 300, 400))
  var Furnitures :NSArray! //家具一覧
  //場所
  //最後にメニューに戻るボタン
  var backtomenu :UIButton!
  
  var imageName :String!
  var Furniturename :String!
  var kind :Int!
  var haved :Bool!
  var id :Int!
  
  var PlayerRoom :NSArray! //Room
  var ids :Array<Int> = [-1,-1,-1,-1]
  var back :Int! //背景何？
  
  var fontcolor = UIColor(red: 102.0/255.0, green: 53.0/255.0, blue: 19.0/255, alpha: 1.0)
  
  //ここから効果音
  var decide = SKAction.playSoundFileNamed("decide.mp3", waitForCompletion: true)
  var choose = SKAction.playSoundFileNamed("choose.mp3", waitForCompletion: true)
  var click = SKAction.playSoundFileNamed("click.mp3", waitForCompletion: true)
  
  override func didMoveToView(view: SKView) {
    self.runAction(click)
    var background = SKSpriteNode(imageNamed: "con.jpg")
    background.xScale = 1.5
    background.yScale = 1.5
    background.position = CGPoint(x: self.size.width*0.5, y: self.size.height*0.5)
    self.addChild(background)
    Furnitures = readData()   //家具情報読み込み
    
    var count = 0
    for data in Furnitures{   //持ってるやつはどれ？
    println("@@@@@@@@@@@@@@@@@@@@@@@@@")
    println(data)
      setData(data)
      if (haved == true){
        count++
      }
    }
    var PlayerRoom = readRoom()   //部屋情報読み込み
    
    if (PlayerRoom.count == 0){
      makeRoom()
      PlayerRoom = readRoom()
    }
    
    for data in PlayerRoom{
      
      back = data.valueForKey("background") as! Int
      for i in 1...4 {
        var a = "fur\(i)"
        ids[i-1] = data.valueForKey(a) as! Int
      }
    }
    
    var kanban = SKSpriteNode(imageNamed:"kanban5")
    kanban.xScale = 0.6
    kanban.yScale = 0.6
    var height = kanban.frame.height*0.5
    kanban.position = CGPoint(x: self.size.width*0.5, y: self.size.height-height)
    self.addChild(kanban)
    
    var heightScroll = ceil(Double(count) / 2.0)
    Scroll = UIScrollView(frame: CGRect(x: 0, y: 0, width: 300, height: 350))
    Scroll.scrollEnabled = true
    Scroll.contentSize = CGSize(width:0 , height: 180*heightScroll)
    Scroll.indicatorStyle = UIScrollViewIndicatorStyle.Black
    Scroll.center = CGPoint(x: phoneSize.width*0.5, y: phoneSize.height*0.5)
    Scroll.backgroundColor = UIColor(red: 1, green: 1, blue: 1, alpha: 0.5)
    self.view!.addSubview(Scroll)
    
    //お部屋を見る
    ShowRoomButton = UIButton(frame: CGRectMake(0, 0, 100, 50))
    ShowRoomButton.backgroundColor = UIColor.orangeColor()
    ShowRoomButton.addTarget(self, action: "showRoom:", forControlEvents: .TouchUpInside)
    ShowRoomButton.setTitle("部屋を見る", forState: .Normal)
    ShowRoomButton.setTitleColor(UIColor.whiteColor(), forState: .Normal)
    ShowRoomButton.setTitle("部屋を見る", forState: .Highlighted)
    ShowRoomButton.setTitleColor(UIColor.blackColor(), forState: .Highlighted)
    ShowRoomButton.layer.position = CGPoint(x: phoneSize.width*0.7, y: phoneSize.height*0.9-20)
    ShowRoomButton.layer.cornerRadius = 20

    self.view!.addSubview(ShowRoomButton)
    
    //メニューに戻るボタン
    backtomenu = UIButton(frame: CGRectMake(0, 0, 100, 40))
    backtomenu.backgroundColor = UIColor(red: 180/255, green: 1, blue: 127/255, alpha: 1)
    backtomenu.addTarget(self, action: "backtomenu:", forControlEvents: .TouchUpInside)
    backtomenu.setTitle("もどる", forState: .Normal)
    backtomenu.setTitleColor(UIColor(red: 110/255, green: 132/255, blue: 94/255, alpha: 1), forState: .Normal)
    backtomenu.setTitle("もどる", forState: .Highlighted)
    backtomenu.setTitleColor(UIColor.blackColor(), forState: .Highlighted)
    backtomenu.layer.position = CGPoint(x: 60, y: phoneSize.height*0.9-20)
    backtomenu.layer.cornerRadius = 20

    self.view!.addSubview(backtomenu)
    
    //これはダミー用
    dammy = UIImage(named: "nothing")
    
    //戻るボタン作成
    backSetButton = UIButton(frame: CGRectMake(0, 0, 80, 80))
    backSetButton.backgroundColor = UIColor(red: 180/255, green: 1, blue: 127/255, alpha: 1)
    backSetButton.addTarget(self, action: "GobackList:", forControlEvents: .TouchUpInside)
    backSetButton.setTitle("もどる", forState: .Normal)
    backSetButton.setTitleColor(UIColor(red: 110/255, green: 132/255, blue: 94/255, alpha: 1), forState: .Normal)
    backSetButton.setTitle("もどる", forState: .Highlighted)
    backSetButton.setTitleColor(UIColor.blackColor(), forState: .Highlighted)
    backSetButton.layer.cornerRadius = 40
    backSetButton.layer.position = CGPoint(x: phoneSize.width*0.5, y: phoneSize.height*0.85)
    
    BackgroundSet = UIButton(frame: CGRectMake(0, 0, 100, 100))
    BackgroundSet.backgroundColor = UIColor(red: 1, green: 145/255, blue: 158/255, alpha: 1.0)
    BackgroundSet.addTarget(self, action: "SetBackground:", forControlEvents: .TouchUpInside)
    BackgroundSet.setTitle("はい", forState: .Normal)
    BackgroundSet.setTitleColor(UIColor(red: 141/255, green: 47/255, blue: 58/255, alpha: 1.0), forState: .Normal)
    BackgroundSet.setTitle("はい", forState: .Highlighted)
    BackgroundSet.setTitleColor(UIColor.whiteColor(), forState: .Highlighted)
    BackgroundSet.layer.cornerRadius = 50
    BackgroundSet.layer.position = CGPoint(x: phoneSize.width*0.3, y: phoneSize.height*0.8)
    
    Backgroundcancel = UIButton(frame: CGRectMake(0, 0, 100, 100))
    Backgroundcancel.backgroundColor = UIColor(red: 157/255, green: 180/255, blue: 213/255, alpha: 1)
    Backgroundcancel.addTarget(self, action: "GobackList:", forControlEvents: .TouchUpInside)
    Backgroundcancel.setTitle("いいえ", forState: .Normal)
    Backgroundcancel.setTitleColor(UIColor(red: 64/255, green: 79/255, blue: 102/255, alpha: 1), forState: .Normal)
    Backgroundcancel.setTitle("いいえ", forState: .Highlighted)
    Backgroundcancel.setTitleColor(UIColor.whiteColor(), forState: .Highlighted)
    Backgroundcancel.layer.cornerRadius = 50
    Backgroundcancel.layer.position = CGPoint(x: phoneSize.width*0.7, y: phoneSize.height*0.8)

    
    
    
    
    //家具配置時のテキスト作成
    TextFurniture = UITextView(frame: CGRectMake(0, 0, phoneSize.width, 100))
    TextFurniture.userInteractionEnabled = true
    TextFurniture.backgroundColor = UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.0)
    TextFurniture.text = ""
    TextFurniture.font = UIFont.systemFontOfSize(CGFloat(20))
    TextFurniture.textColor = UIColor.blackColor()
    TextFurniture.textAlignment = NSTextAlignment.Center
    TextFurniture.editable = false
    TextFurniture.center = CGPointMake(phoneSize.width*0.5,100)
    
    //Window作成
    myWindow.backgroundColor = UIColor(red: 1, green: 1, blue: 1, alpha: 0.5)
    myWindow.layer.position = CGPointMake(self.view!.frame.width/2, self.view!.frame.height/2+50)
    myWindow.layer.cornerRadius = 30         // myWindowをkeyWindowにする.
    myWindow.makeKeyWindow()
    
    //Windowでのテキスト作成
    WindowText = UITextView(frame: CGRectMake(0, 0, 300, 100))
    WindowText.userInteractionEnabled = true
    WindowText.backgroundColor = UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.0)
    WindowText.text = ""
    WindowText.font = UIFont.systemFontOfSize(CGFloat(20))
    WindowText.textColor = UIColor.blackColor()
    WindowText.textAlignment = NSTextAlignment.Left
    WindowText.editable = false
    WindowText.center = CGPointMake(self.view!.frame.width/2,100)
    
    for i in 0...3 { //配置ボタンの用意
      SetButtons.append(UIButton(frame: CGRectMake(0,0,100,100)))
      SetButtons[i].backgroundColor = UIColor(red: 1.0, green: 0.5, blue: 0, alpha: 0.5)
      SetButtons[i].layer.masksToBounds = true
      SetButtons[i].layer.cornerRadius = 50.0
      SetButtons[i].addTarget(self, action: "SetFurniture:", forControlEvents: .TouchUpInside)
      SetButtons[i].setTitle(places[i], forState: .Normal)
      SetButtons[i].setTitleColor(UIColor.whiteColor(), forState: .Normal)
      SetButtons[i].setTitle(places[i], forState: .Highlighted)
      SetButtons[i].setTitleColor(UIColor.blackColor(), forState: .Highlighted)
      SetButtons[i].tag = i
      var x :Array<CGFloat> = [0.30,0.70]
      var y :Array<CGFloat> = [0.30,0.60]
      var whichy = Int(floor(CGFloat(i/2)))
      var WhereX :CGFloat = phoneSize.width * x[i%2]
      var WhereY :CGFloat = phoneSize.height * (y[whichy] + 0.1)//高さの間隔
      SetButtons[i].layer.position = CGPoint(x: WhereX,y: WhereY)
      
      //さて既に何か置いているだろうか？
      if(ids[i] == -1){ //何もおいてない！！
        RoomFurniture.append(UIImageView(image: dammy))
      }else{ //置いてた！
        var imageName = Furnitures[ids[i]].valueForKey("image") as! String
        var imageData = UIImage(named: imageName)
        RoomFurniture.append(UIImageView(image: imageData))
      }
      RoomFurniture[i].frame = CGRectMake(0, 0, 150, 150)
      RoomFurniture[i].center = CGPointMake(WhereX, WhereY)
      
    }
    
    var i = 0 //これはViewが何番目
    var k = 0 //これは家具が何番目
    for data in Furnitures {
      setData(data)
      if (haved == false){
        k++
        continue
      }
      var imagename = data.valueForKey("image")! as! String
      var name = data.valueForKey("name")! as! String
      
      //コイツが1単位
      var View = UIView()
      View.userInteractionEnabled = true
      var HGH :CGFloat = 180  //高さの間隔
      var WhereY = floor(CGFloat(i/2)) //何行目？
      var which :CGFloat = CGFloat(i%2)
      View.frame = CGRectMake(150*which, HGH*WhereY, 150, 150)
      
      var husen = UIImageView(frame: CGRect(x: 0, y: 0, width: 150, height: 150))
      husen.image  = UIImage(named: "husen")
      View.addSubview(husen)

      //画像の用意
      Images.append(UIImage(named: imagename)!)
      imageViews.append(UIImageView(image: Images[i]))
      imageViews[i].frame = CGRectMake(0, 0, 120, 120)
      imageViews[i].center = CGPointMake(75,90)
      imageViews[i].tag = k
      imageViews[i].userInteractionEnabled = true
      
      //画像にアクション適用、表示
      let action = UITapGestureRecognizer(target:self, action: "TouchImage:")
      imageViews[i].addGestureRecognizer(action)
      View.addSubview(imageViews[i])
      
      //商品名
      var furnitureColor = UIColor(red: 120/255, green: 97/255, blue: 56/255, alpha: 1.0)
      myTextView = UITextView(frame: CGRectMake(0, 0, 130, 30))
      myTextView.userInteractionEnabled = false
      myTextView.text = Furniturename
      myTextView.font = UIFont.systemFontOfSize(CGFloat(15))
      myTextView.textColor = furnitureColor
      myTextView.textAlignment = NSTextAlignment.Center
      myTextView.editable = false
      myTextView.center = CGPointMake(75,15)
      myTextView.backgroundColor = UIColor.clearColor()
      View.addSubview(myTextView)

      
      Scroll.addSubview(View)
      k++
      i++
    }
    
    
    removeButton = UIButton(frame: CGRectMake(0, 0, 80, 80))
    removeButton.backgroundColor = UIColor(red: 1, green: 145/255, blue: 158/255, alpha: 1.0)
    removeButton.addTarget(self, action: "removeFurniture:", forControlEvents: .TouchUpInside)
    removeButton.setTitle("はい", forState: .Normal)
    removeButton.setTitleColor(UIColor(red: 141/255, green: 47/255, blue: 58/255, alpha: 1.0), forState: .Normal)
    removeButton.setTitle("はい", forState: .Highlighted)
    removeButton.setTitleColor(UIColor.whiteColor(), forState: .Highlighted)
    removeButton.layer.cornerRadius = 40
    removeButton.layer.position = CGPoint(x: 100, y: 250)
    
    //キャンセルボタン作成
    cancelButton = UIButton(frame: CGRectMake(0, 0, 80, 80))
    cancelButton.backgroundColor = UIColor(red: 157/255, green: 180/255, blue: 213/255, alpha: 1)
    cancelButton.addTarget(self, action: "Goback:", forControlEvents: .TouchUpInside)
    cancelButton.setTitle("いいえ", forState: .Normal)
    cancelButton.setTitleColor(UIColor(red: 64/255, green: 79/255, blue: 102/255, alpha: 1), forState: .Normal)
    cancelButton.setTitle("いいえ", forState: .Highlighted)
    cancelButton.setTitleColor(UIColor.whiteColor(), forState: .Highlighted)
    cancelButton.layer.cornerRadius = 40
    cancelButton.layer.position = CGPoint(x: 200, y: 250)
    
    backButton = UIButton(frame: CGRectMake(0, 0, 80, 80))
    backButton.backgroundColor = UIColor(red: 180/255, green: 1, blue: 127/255, alpha: 1)
    backButton.addTarget(self, action: "Goback:", forControlEvents: .TouchUpInside)
    backButton.setTitle("もどる", forState: .Normal)
    backButton.setTitleColor(UIColor(red: 110/255, green: 132/255, blue: 94/255, alpha: 1), forState: .Normal)
    backButton.setTitle("もどる", forState: .Highlighted)
    backButton.setTitleColor(UIColor.blackColor(), forState: .Highlighted)
    backButton.layer.cornerRadius = 40
    backButton.layer.position = CGPoint(x: 150, y: 250)
    
    
  }
  
  func TouchImage(recognizer: UIGestureRecognizer) {
    if let imageView = recognizer.view as? UIImageView {
      if(SetFlug == false){
        setData(Furnitures[imageView.tag])
        id = imageView.tag
        //そもそもまず家具？背景？
        //家具だった場合
        if(kind == 1){
          //まず最初に置いてあるかどうかを確認しないといけないんですよね…
          var i = 0
          for data in ids{
            if(id == data){
              OnePlace = i
              SetFlug = true
              MakeWindow()
              break
            }
            i++
          }
          if(imageView.tag != 10000 && SetFlug == false){  //さあ家具を置こう
            self.runAction(choose)
            //背景表示
            var backData = Furnitures[back].valueForKey("image") as! String
            var backImage = UIImage(named: backData)
            backView = UIImageView(frame: CGRectMake(0, 0, phoneSize.width, phoneSize.height))
            backView.image = backImage
            self.view!.addSubview(backView)
            
            //テキスト表示
            TextFurniture.text = "どこに\(Furniturename)を配置しますか？"
            TextFurniture.textColor = fontcolor
            self.view!.addSubview(TextFurniture)
            //戻るボタン配置
            backSetButton.hidden = false
            for (var i=0; i<4; i++){ //今置いてる家具と4つのボタンを表示
              self.view!.addSubview(RoomFurniture[i])
              self.view!.addSubview(SetButtons[i])
              SetButtons[i].hidden = false
            }
            
            //家具をおくところというフラグをたてておく
            SetFlug = true
            self.view!.addSubview(backSetButton)
            backSetButton.hidden = false
          }
        }else if(kind == 2){ //背景だった場合
          self.runAction(choose)
          if(back != id){//これは違う壁紙ですね……
            showRoom()
            SetFlug = true
          }else{
            backtomenu.hidden = true
            ShowRoomButton.hidden = true
            self.view!.addSubview(myWindow)
            self.myWindow.makeKeyAndVisible()
            
            WindowText.text = "\(Furniturename)は今の壁紙です。"
            Scroll.hidden = true
            myWindow.addSubview(WindowText)
            myWindow.addSubview(backButton)
            SetFlug = true
          }
        } //kind == 2
      } // setflug == false
    }
  } //func touchimage
  
  internal func SetFurniture(sender: UIButton){ //家具を置く
    self.runAction(decide)
    //sender.tag0,1,2,3 = "左上","右上","左下","右下"
    //idにはもう家具のID入ってます
    //じゃあまず表面上だけ変えよう
    OnePlace = sender.tag //これが場所
    ids[OnePlace] = id
    var SetPoint = CGPoint(x: sender.layer.position.x, y: sender.layer.position.y )
    RoomFurniture[OnePlace].image = UIImage(named: imageName)
    RoomFurniture[OnePlace].center = SetPoint
    self.view!.addSubview(RoomFurniture[OnePlace])
    TextFurniture.textColor = UIColor(red: 185/255, green: 23/255, blue: 44/255, alpha: 1.0)
    TextFurniture.text = "配置しました！"
    
    
    //そしてデータベースを書き換えるんだ
    var fur = "fur\(OnePlace+1)"
    let app = UIApplication.sharedApplication().delegate as! AppDelegate
    let categoryContext: NSManagedObjectContext = app.managedObjectContext!
    let categoryRequest: NSFetchRequest = NSFetchRequest(entityName: "Room")
    var resultPoint = categoryContext.executeFetchRequest(categoryRequest, error: nil)!
    for data in resultPoint{
      data.setValue(id, forKey: fur)
      var error: NSError?
      categoryContext.save(&error)
    }
    
    for (var i=0; i<4; i++){
      SetButtons[i].hidden = true
    }
  }
  
  internal func GobackList(sender: UIButton){ //配置画面から家具一覧に戻る
    self.runAction(click)
    for (var i=0; i<4; i++){
      SetButtons[i].removeFromSuperview()
      RoomFurniture[i].removeFromSuperview()
    }
    backView.removeFromSuperview()
    TextFurniture.removeFromSuperview()
    backSetButton.hidden = true
    backtomenu.hidden = false
    ShowRoomButton.hidden = false
    SetFlug = false
    BackgroundSet.removeFromSuperview()
    Backgroundcancel.removeFromSuperview()
  }
  
  func backtomenu(sender: UIButton){
    self.runAction(click)
    allHidden()
    let tr = SKTransition.fadeWithColor(UIColor.whiteColor(), duration: 0.0)
    let newScene = FurnitureScene(size: self.scene!.size)
    newScene.scaleMode = SKSceneScaleMode.AspectFill
    self.scene!.view!.presentScene(newScene, transition: tr)
  }
  
  func allHidden(){
    Scroll.hidden = true
    backtomenu.hidden = true
    ShowRoomButton.hidden = true
  }
  
  func readData() -> NSArray{
    let app: AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    let categoryContext: NSManagedObjectContext = app.managedObjectContext!
    let categoryRequest: NSFetchRequest = NSFetchRequest(entityName: "Furniture")
    var error: NSError? = nil;
    var results: NSArray! = categoryContext.executeFetchRequest(categoryRequest, error: nil)
    return results!
  }
  
  func setData(data: AnyObject){
    imageName = data.valueForKey("image")! as! String
    Furniturename = data.valueForKey("name")! as! String
    kind = data.valueForKey("kind")! as! Int
    haved = data.valueForKey("haved") as! Bool
  }
  
  func readRoom() -> NSArray{
    let app: AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    let categoryContext: NSManagedObjectContext = app.managedObjectContext!
    let categoryRequest: NSFetchRequest = NSFetchRequest(entityName: "Room")
    var error: NSError? = nil;
    var results: NSArray! = categoryContext.executeFetchRequest(categoryRequest, error: nil)
    return results!
  }
  
  func makeRoom() {
    //plist読み込み
    let app: AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    let categoryContext: NSManagedObjectContext = app.managedObjectContext!
    
    let categoryEntity: NSEntityDescription! = NSEntityDescription.entityForName(
      "Room", inManagedObjectContext: categoryContext)
    var new_data  = NSManagedObject(entity: categoryEntity, insertIntoManagedObjectContext: categoryContext)
    new_data.setValue(4, forKey: "background")
    new_data.setValue(-1, forKey: "fur1")
    new_data.setValue(-1, forKey: "fur2")
    new_data.setValue(-1, forKey: "fur3")
    new_data.setValue(-1, forKey: "fur4")
    
    var error: NSError?
    categoryContext.save(&error)
    
    println("InitMasters OK!")
  }
  
  func MakeWindow(){
    self.runAction(choose)
    Scroll.hidden = true
    backtomenu.hidden = true
    ShowRoomButton.hidden = true
    // myWindowをkeyWindowにする.
    myWindow.makeKeyWindow()
    self.view!.addSubview(myWindow)
    self.myWindow.makeKeyAndVisible()
    
    WindowText.text = "\(Furniturename)は\(places[OnePlace])に\nもう置いています。\n取り除きますか？"
    myWindow.addSubview(WindowText)
    myWindow.addSubview(removeButton)
    myWindow.addSubview(cancelButton)
  }
  
  func removeFurniture(sender: UIButton){ //家具を置く
    //データベースを書き換えるんだ
    self.runAction(decide)
    removeButton.removeFromSuperview()
    cancelButton.removeFromSuperview()
    myWindow.addSubview(backButton)
    WindowText.text = "\(Furniturename)を取り除きました！"
    RoomFurniture[OnePlace].image = dammy
    ids[OnePlace] = -1
    
    var fur = "fur\(OnePlace+1)"
    let app = UIApplication.sharedApplication().delegate as! AppDelegate
    let categoryContext: NSManagedObjectContext = app.managedObjectContext!
    let categoryRequest: NSFetchRequest = NSFetchRequest(entityName: "Room")
    var resultPoint = categoryContext.executeFetchRequest(categoryRequest, error: nil)!
    for data in resultPoint{
      data.setValue(-1, forKey: fur)
      var error: NSError?
      categoryContext.save(&error)
    }
    
  }
  
  func Goback(sender: UIButton){
    self.runAction(click)
    myWindow.hidden = true
    backtomenu.hidden = false
    ShowRoomButton.hidden = false
    SetFlug = false
    Scroll.hidden = false
    backButton.removeFromSuperview()
    removeButton.removeFromSuperview()
    cancelButton.removeFromSuperview()
  }
  
  func showRoom(sender: UIButton){ //ボタンでただ単純に部屋だけ見せる時
    self.runAction(click)
    var backData = Furnitures[back].valueForKey("image") as! String
    var backImage = UIImage(named: backData)
    backView = UIImageView(frame: CGRectMake(0, 0, phoneSize.width, phoneSize.height))
    backView.image = backImage
    self.view!.addSubview(backView)
    
    backSetButton.hidden = false
    for (var i=0; i<4; i++){ //今置いてる家具を表示
      self.view!.addSubview(RoomFurniture[i])
      
    }
    self.view!.addSubview(backSetButton)
  }
  
  func showRoom(){ //こうなります、みたいに部屋を見せる時
    self.runAction(choose)
    var backData = Furnitures[id].valueForKey("image") as! String
    var backImage = UIImage(named: backData)
    backView = UIImageView(frame: CGRectMake(0, 0, phoneSize.width, phoneSize.height))
    backView.image = backImage
    self.view!.addSubview(backView)
    
    backSetButton.hidden = false
    for (var i=0; i<4; i++){ //今置いてる家具を表示
      self.view!.addSubview(RoomFurniture[i])
    }
    TextFurniture.textColor = fontcolor
    TextFurniture.text = "\(Furniturename)にすると\nお部屋はこうなります。変更しますか？"
    self.view!.addSubview(TextFurniture)
    self.view!.addSubview(BackgroundSet)
    self.view!.addSubview(Backgroundcancel)
    
  }
  
  func SetBackground(sender: UIButton){
    self.runAction(decide)
    TextFurniture.textColor = UIColor(red: 185/255, green: 23/255, blue: 44/255, alpha: 1.0)
    TextFurniture.text = "壁紙を張り替えました！"
    let app = UIApplication.sharedApplication().delegate as! AppDelegate
    let categoryContext: NSManagedObjectContext = app.managedObjectContext!
    let categoryRequest: NSFetchRequest = NSFetchRequest(entityName: "Room")
    var resultPoint = categoryContext.executeFetchRequest(categoryRequest, error: nil)!
    for data in resultPoint{
      data.setValue(id, forKey: "background")
      var error: NSError?
      categoryContext.save(&error)
    }
    back = id
    BackgroundSet.removeFromSuperview()
    Backgroundcancel.removeFromSuperview()
    self.view!.addSubview(backSetButton)
  }
  

  
}