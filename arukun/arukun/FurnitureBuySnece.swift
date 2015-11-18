import Foundation
import UIKit
import SpriteKit
import CoreData

class FurnitureBuyScene: SKScene {
  var Scroll :UIScrollView! //0は家具購入、1は家具配置に使います
  //まず家具購入に必要な物
  var phoneSize :CGSize = UIScreen.mainScreen().bounds.size //画面サイズ
  private var myWindow = UIWindow(frame: CGRectMake(0, 0, 300, 300))
  var BuyButton :UIButton!
  var backButton :UIButton! //戻るボタン
  var cancelButton :UIButton! //キャンセルボタン
  private var myTextView :UITextView! //家具の名前
  private var Text :UITextView! //テキスト
  private var PointView :UITextView! //所持ポイント表示
  private var price :UITextView! //値段
  var imageView :UIImageView! //これは商品
  var boughtImage = UIImage(named: "bought") //購入済み
  var PlayerPoint :Int!   //お金
  var BuyFurniture :Dictionary<String,String>! //何を買おうとしてるのか
  var selected: AnyObject!  //選んだ商品
  var selectedNumber: Int!
  var bought :Array<UIImageView> = [] //買ったのどうなの
  var results :NSArray!
  //最後にメニューに戻るボタン
  var backtomenu :UIButton!
  var Flg = false
  
  var imageName :String!
  var Furniturename :String!
  var point :Int!
  var haved :Bool!
  
  
  override func didMoveToView(view: SKView) {
    results = readData()
    readPoint()
    var heightScroll = ceil(Double(results.count) / 2.0)
    Scroll = UIScrollView(frame: CGRect(x: 0, y: 0, width: 300, height: 500))
    Scroll.scrollEnabled = true
    Scroll.contentSize = CGSize(width:0 , height: 180*heightScroll)
    Scroll.indicatorStyle = UIScrollViewIndicatorStyle.Black
    Scroll.center = CGPoint(x: phoneSize.width*0.5, y: phoneSize.height*0.4)
    Scroll.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.5)
    self.view!.addSubview(Scroll)
    
    //メニューに戻るボタン
    backtomenu = UIButton(frame: CGRectMake(0, 0, 100, 50))
    backtomenu.backgroundColor = UIColor.blueColor()
    backtomenu.addTarget(self, action: "backtomenu:", forControlEvents: .TouchUpInside)
    backtomenu.setTitle("戻る", forState: .Normal)
    backtomenu.setTitleColor(UIColor.whiteColor(), forState: .Normal)
    backtomenu.setTitle("戻る", forState: .Highlighted)
    backtomenu.setTitleColor(UIColor.blackColor(), forState: .Highlighted)
    backtomenu.layer.position = CGPoint(x: 60, y: phoneSize.height*0.9-10)
    self.view!.addSubview(backtomenu)
    
    
    override func didMoveToView(view: SKView) {
        results = readData()
        readPoint()
        var heightScroll = ceil(Double(results.count) / 2.0)
        Scroll = UIScrollView(frame: CGRect(x: 0, y: 0, width: 300, height: 500))
        Scroll.scrollEnabled = true
        Scroll.contentSize = CGSize(width:0 , height: 180*heightScroll)
        Scroll.indicatorStyle = UIScrollViewIndicatorStyle.Black
        Scroll.center = CGPoint(x: phoneSize.width*0.5, y: phoneSize.height*0.4)
        Scroll.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.5)
        self.view!.addSubview(Scroll)
        
        //メニューに戻るボタン
        backtomenu = UIButton(frame: CGRectMake(0, 0, 100, 50))
        backtomenu.backgroundColor = UIColor.blueColor()
        backtomenu.addTarget(self, action: "backtomenu:", forControlEvents: .TouchUpInside)
        backtomenu.setTitle("戻る", forState: .Normal)
        backtomenu.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        backtomenu.setTitle("戻る", forState: .Highlighted)
        backtomenu.setTitleColor(UIColor.blackColor(), forState: .Highlighted)
        backtomenu.layer.position = CGPoint(x: 60, y: phoneSize.height*0.9-10)
        self.view!.addSubview(backtomenu)
        
        
        //購入ボタン作成
        BuyButton = UIButton(frame: CGRectMake(0, 0, 100, 50))
        BuyButton.backgroundColor = UIColor.redColor()
        BuyButton.addTarget(self, action: "BuyFurniture:", forControlEvents: .TouchUpInside)
        BuyButton.setTitle("購入", forState: .Normal)
        BuyButton.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        BuyButton.setTitle("購入", forState: .Highlighted)
        BuyButton.setTitleColor(UIColor.blackColor(), forState: .Highlighted)
        BuyButton.layer.position = CGPoint(x: 150, y: 200)
        
        //キャンセルボタン作成
        cancelButton = UIButton(frame: CGRectMake(0, 0, 100, 50))
        cancelButton.backgroundColor = UIColor.blueColor()
        cancelButton.addTarget(self, action: "Goback:", forControlEvents: .TouchUpInside)
        cancelButton.setTitle("キャンセル", forState: .Normal)
        cancelButton.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        cancelButton.setTitle("キャンセル", forState: .Highlighted)
        cancelButton.setTitleColor(UIColor.blackColor(), forState: .Highlighted)
        cancelButton.layer.position = CGPoint(x: 150, y: 250)
        
        //戻るボタン作成
        backButton = UIButton(frame: CGRectMake(0, 0, 100, 50))
        backButton.backgroundColor = UIColor.blueColor()
        backButton.addTarget(self, action: "Goback:", forControlEvents: .TouchUpInside)
        backButton.setTitle("戻る", forState: .Normal)
        backButton.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        backButton.setTitle("戻る", forState: .Highlighted)
        backButton.setTitleColor(UIColor.blackColor(), forState: .Highlighted)
        backButton.layer.position = CGPoint(x: 150, y: 250)
        
        
        //これはテキスト
        Text = UITextView(frame: CGRectMake(0, 0, 300, 100))
        Text.userInteractionEnabled = true
//        Text.backgroundColor = UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.0)
        Text.text = ""
        Text.font = UIFont.systemFontOfSize(CGFloat(20))
        Text.textColor = UIColor.blackColor()
        Text.textAlignment = NSTextAlignment.Left
        Text.editable = false
        Text.center = CGPointMake(self.view!.frame.width/2,100)
        
        PointView = UITextView(frame: CGRectMake(0, 0, 200, 100))
        PointView.userInteractionEnabled = true
//        PointView.backgroundColor = UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.0)
        PointView.backgroundColor = UIColor(red: 255.0, green: 255.0, blue: 0.0, alpha: 1)
        PointView.text = "所持ポイント：\(toString(PlayerPoint))P"
        PointView.font = UIFont.systemFontOfSize(CGFloat(20))
        PointView.textColor = UIColor.blackColor()
        PointView.textAlignment = NSTextAlignment.Right
        PointView.editable = false
        PointView.center = CGPointMake(self.view!.frame.width*0.7,self.view!.frame.height*0.9)
        self.view!.addSubview(PointView)
        
        var i = 0
        for data in results { //メイン画面の用意
            setData(data)
            //var imageName = data.valueForKey("image")! as! String
            //var name = data.valueForKey("name")! as! String
            //var point = data.valueForKey("point")! as! Int
            //var haved = data.valueForKey("haved") as! Bool
            
            var View = UIView()
            View.userInteractionEnabled = true
            var HGH :CGFloat = 180  //高さの間隔
            var WhereY = floor(CGFloat(i/2)) //何行目？
            var which :CGFloat = CGFloat(i%2)
            View.frame = CGRectMake(150*which, HGH*WhereY, 150, 150)
            
            //画像の用意
            var Image = UIImage(named: imageName)
            imageView = UIImageView(image: Image)
            imageView.frame = CGRectMake(0, 0, 120, 120)
            imageView.center = CGPointMake(75,90)
            imageView.tag = i
            imageView.userInteractionEnabled = true
            
            //画像にアクション適用、表示
            let action = UITapGestureRecognizer(target:self, action: "makeWindow:")
            imageView.addGestureRecognizer(action)
            View.addSubview(imageView)
            
            //商品名
            myTextView = UITextView(frame: CGRectMake(0, 0, 130, 30))
            myTextView.userInteractionEnabled = false
            myTextView.backgroundColor = UIColor(red: 0.0, green: 0.8, blue: 0.8, alpha: 1.0)
            myTextView.text = Furniturename
            myTextView.font = UIFont.systemFontOfSize(CGFloat(15))
            myTextView.textColor = UIColor.whiteColor()
            myTextView.textAlignment = NSTextAlignment.Center
            myTextView.editable = false
            myTextView.center = CGPointMake(75,15)
            View.addSubview(myTextView)
            
            //値段を入れる
            price = UITextView(frame: CGRectMake(0, 0, 50, 30))
            price.userInteractionEnabled = false
            price.editable = false
            price.text = "\(point)"
            price.textColor = UIColor(red: 120.0, green: 97.0, blue: 56.0, alpha: 1.0)
            price.backgroundColor = UIColor.yellowColor()
            price.font = UIFont.systemFontOfSize(CGFloat(15))
            price.textColor = UIColor.whiteColor()
            price.textAlignment = NSTextAlignment.Left
            price.center = CGPointMake(125,135)
            View.addSubview(price)
            
            bought.append(UIImageView(image: boughtImage))
            bought[i].frame = CGRectMake(0, 0, 50, 50)
            bought[i].center = CGPointMake(75, 75)
            View.addSubview(bought[i])
            bought[i].tag = i
            if(!(haved)){
                bought[i].hidden = true
            }
            
            Scroll.addSubview(View)
            
            i++
        }
        
    }//完成です
    
    
    //これはテキスト
    Text = UITextView(frame: CGRectMake(0, 0, 300, 100))
    Text.userInteractionEnabled = true
    Text.backgroundColor = UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.0)
    Text.text = ""
    Text.font = UIFont.systemFontOfSize(CGFloat(20))
    Text.textColor = UIColor.blackColor()
    Text.textAlignment = NSTextAlignment.Left
    Text.editable = false
    Text.center = CGPointMake(self.view!.frame.width/2,100)
    
    PointView = UITextView(frame: CGRectMake(0, 0, 200, 100))
    PointView.userInteractionEnabled = true
    PointView.backgroundColor = UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.0)
    PointView.text = "所持ポイント：\(toString(PlayerPoint))P"
    PointView.font = UIFont.systemFontOfSize(CGFloat(20))
    PointView.textColor = UIColor.blackColor()
    PointView.textAlignment = NSTextAlignment.Right
    PointView.editable = false
    PointView.center = CGPointMake(self.view!.frame.width*0.7,self.view!.frame.height*0.9)
    self.view!.addSubview(PointView)
    
    var i = 0
    for data in results { //メイン画面の用意
      setData(data)
      //var imageName = data.valueForKey("image")! as! String
      //var name = data.valueForKey("name")! as! String
      //var point = data.valueForKey("point")! as! Int
      //var haved = data.valueForKey("haved") as! Bool
      
      var View = UIView()
      View.userInteractionEnabled = true
      var HGH :CGFloat = 180  //高さの間隔
      var WhereY = floor(CGFloat(i/2)) //何行目？
      var which :CGFloat = CGFloat(i%2)
      View.frame = CGRectMake(150*which, HGH*WhereY, 150, 150)
      
      //画像の用意
      var Image = UIImage(named: imageName)
      imageView = UIImageView(image: Image)
      imageView.frame = CGRectMake(0, 0, 120, 120)
      imageView.center = CGPointMake(75,90)
      imageView.tag = i
      imageView.userInteractionEnabled = true
      
      //画像にアクション適用、表示
      let action = UITapGestureRecognizer(target:self, action: "makeWindow:")
      imageView.addGestureRecognizer(action)
      View.addSubview(imageView)
      
      //商品名
      myTextView = UITextView(frame: CGRectMake(0, 0, 130, 30))
      myTextView.userInteractionEnabled = false
      myTextView.backgroundColor = UIColor(red: 0.0, green: 0.8, blue: 0.8, alpha: 1.0)
      myTextView.text = Furniturename
      myTextView.font = UIFont.systemFontOfSize(CGFloat(15))
      myTextView.textColor = UIColor.whiteColor()
      myTextView.textAlignment = NSTextAlignment.Center
      myTextView.editable = false
      myTextView.center = CGPointMake(75,15)
      View.addSubview(myTextView)
      
      //値段を入れる
      price = UITextView(frame: CGRectMake(0, 0, 50, 30))
      price.userInteractionEnabled = false
      price.editable = false
      price.text = "\(point)"
      price.backgroundColor = UIColor.orangeColor()
      price.font = UIFont.systemFontOfSize(CGFloat(15))
      price.textColor = UIColor.whiteColor()
      price.textAlignment = NSTextAlignment.Left
      price.center = CGPointMake(125,135)
      View.addSubview(price)
      
      bought.append(UIImageView(image: boughtImage))
      bought[i].frame = CGRectMake(0, 0, 50, 50)
      bought[i].center = CGPointMake(75, 75)
      View.addSubview(bought[i])
      bought[i].tag = i
      if(!(haved)){
        bought[i].hidden = true
      }
      
      Scroll.addSubview(View)
      
      i++
    }
    
  }//完成です
  
  internal func Goback(sender: UIButton){ //戻る
    Flg = false
    myWindow.hidden = true
  }
  
  internal func BuyFurniture(sender: UIButton){ //買う
    PlayerPoint = PlayerPoint - point
    BuyButton.removeFromSuperview()
    myWindow.addSubview(backButton)
    Text.text = "購入しました！"
    setData(results[selectedNumber])
    
    //その１：買ったやつのhavedをYESに
    let app = UIApplication.sharedApplication().delegate as! AppDelegate
    let managedObjectContext = app.managedObjectContext
    var entityDiscription = NSEntityDescription.entityForName("Furniture", inManagedObjectContext: managedObjectContext!)
    let fetchRequest = NSFetchRequest()
    let categoryContext: NSManagedObjectContext = app.managedObjectContext!
    
    fetchRequest.entity = entityDiscription;
    let predicate = NSPredicate(format: "name = %@",Furniturename)
    fetchRequest.predicate = predicate
    
    var error: NSError? = nil;
    var result = managedObjectContext!.executeFetchRequest(fetchRequest, error: &error)!
    for data in result{
      data.setValue(1, forKey: "haved")
      var error: NSError?
      categoryContext.save(&error)
    }
    
    //その２：Userのmoneyを減らす
    let categoryRequest: NSFetchRequest = NSFetchRequest(entityName: "User")
    var resultPoint = categoryContext.executeFetchRequest(categoryRequest, error: nil)!
    for data in resultPoint{
      data.setValue(PlayerPoint, forKey: "money")
      var error: NSError?
      categoryContext.save(&error)
    }
    
    bought[selectedNumber].hidden = false
    PointView.text = "所持ポイント：\(toString(PlayerPoint))P"
    
  }
  
  
  func makeWindow(recognizer: UIGestureRecognizer){ //ウィンドウ作成
    if (Flg == false){
      if let imageView = recognizer.view as? UIImageView {
        Flg = true
        setData(results[imageView.tag])
        selectedNumber = imageView.tag
        if(!(haved)){
          //まずはウィンドウ作ろう
          myWindow = UIWindow(frame: CGRectMake(0, 0, 300, 300))
//          myWindow.backgroundColor = UIColor.whiteColor()
          myWindow.layer.position = CGPointMake(self.view!.frame.width/2, self.view!.frame.height/2)
//          myWindow.alpha = 1.0
          myWindow.backgroundColor = UIColor(red: 185.0, green: 23.0, blue: 44.0, alpha: 1)
          // myWindowをkeyWindowにする.
          myWindow.makeKeyWindow()
          self.view!.addSubview(myWindow)
          self.myWindow.makeKeyAndVisible()
          
          if(PlayerPoint >= point){ //足りる！
            Text.text = "\(Furniturename)を購入しますか？\n必要ポイント：\(point)P\n所持ポイント：\(PlayerPoint)P"
            myWindow.addSubview(Text)
            myWindow.addSubview(BuyButton)
            myWindow.addSubview(cancelButton)
          }else { //足りない！
            Text.text = "ポイントが足りません！\n必要ポイント：\(point)P\n所持ポイント：\(PlayerPoint)P"
            myWindow.addSubview(Text)
            myWindow.addSubview(backButton)
          }
        }
      }
    }
  }
  
  func backtomenu(sender: UIButton){
    allHidden()
    let tr = SKTransition.fadeWithColor(UIColor.whiteColor(), duration: 0.0)
    let newScene = FurnitureScene(size: self.scene!.size)
    newScene.scaleMode = SKSceneScaleMode.AspectFill
    self.scene!.view!.presentScene(newScene, transition: tr)
  }
  
  func allHidden(){
    Scroll.hidden = true
    backtomenu.hidden = true
    PointView.hidden = true
    myWindow.hidden = true
  }
  
  func readData() -> NSArray{
    println("readData ------------")
    let app: AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    let categoryContext: NSManagedObjectContext = app.managedObjectContext!
    let categoryRequest: NSFetchRequest = NSFetchRequest(entityName: "Furniture")
    
    var results: NSArray! = categoryContext.executeFetchRequest(categoryRequest, error: nil)
    return results
  }
  
  func setData(data: AnyObject){
    imageName = data.valueForKey("image")! as! String
    Furniturename = data.valueForKey("name")! as! String
    point = data.valueForKey("point")! as! Int
    haved = data.valueForKey("haved") as! Bool
  }
  
  func readPoint(){
    println("readPoint ------------")
    let app: AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    let categoryContext: NSManagedObjectContext = app.managedObjectContext!
    let categoryRequest: NSFetchRequest = NSFetchRequest(entityName: "User")
    
    var results: NSArray! = categoryContext.executeFetchRequest(categoryRequest, error: nil)
    if(results.count == 0){
      makeUser()
      readPoint()
    }else{
      for data in results{
        PlayerPoint = data.valueForKey("money") as! Int
      }
    }
  }
  
  func makeUser(){
    let app: AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    let categoryContext: NSManagedObjectContext = app.managedObjectContext!
    let categoryEntity: NSEntityDescription! = NSEntityDescription.entityForName(
      "User", inManagedObjectContext: categoryContext)
    var new_data  = NSManagedObject(entity: categoryEntity, insertIntoManagedObjectContext: categoryContext)
    new_data.setValue(300, forKey: "money")
    new_data.setValue(160, forKey: "stature") //身長のこと
    new_data.setValue(0, forKey: "stride")
    
    var error: NSError?
  }

}
