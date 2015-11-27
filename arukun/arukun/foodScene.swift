//
//  food.swift
//  chara_screen
//
//  Created by chikaratada on H27/10/05.
//  Copyright (c) 平成27年 SenshuUNIV. All rights reserved.
//

import SpriteKit
import Foundation
import CoreData

class foodScene: SKScene {
  var app:AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
  var Scroll = UIScrollView(frame: CGRect(x: 0, y: 0, width: 350, height: 300))

  var PlayerPoint :Int!
  var selected :Int!
  var phoneSize :CGSize = UIScreen.mainScreen().bounds.size //画面サイズ
  private var PointView :UITextView! //所持ポイント表示
  var scoreSprite = SKSpriteNode(imageNamed: "score")
  var Label = SKLabelNode(fontNamed:"Hiragino Kaku Gothic ProN")
  var PlayerLabel = SKLabelNode(fontNamed:"Hiragino Kaku Gothic ProN")
  
  var myWindow = UIWindow(frame: CGRectMake(0, 0, 300, 300))
  var BuyButton :UIButton!
  var cancelButton :UIButton!
  var backButton :UIButton!
  var Text :UITextView!
  var backtomenu  :UIButton!
  
  var Counter :Int = 0
  
  var Flg :Bool = false
  var Furniture :Array<SKSpriteNode> = []
  
  var foodData = [[50,30,0,0],[50,0,30,0],[70,0,10,40]] //まだ準備段階
  var fontcolor = UIColor(red: 102.0/255.0, green: 53.0/255.0, blue: 19.0/255, alpha: 1.0)

  override func didMoveToView(view: SKView) {
    //        /* Setup your scene here */
    readPoint()
    layoutObject()
    makeScroll()
    makeButtons()
    //        self.physicsWorld.contactDelegate = self
    self.physicsWorld.gravity = CGVector(dx: 0, dy: 0)
    self.physicsBody = SKPhysicsBody(edgeLoopFromRect: self.frame)
    backtomenu = UIButton(frame: CGRectMake(0, 0, 100, 50))
    backtomenu.backgroundColor = UIColor(red: 180/255, green: 1, blue: 127/255, alpha: 1)
    backtomenu.addTarget(self, action: "backtomenu:", forControlEvents: .TouchUpInside)
    backtomenu.setTitle("もどる", forState: .Normal)
    backtomenu.setTitleColor(UIColor(red: 110/255, green: 132/255, blue: 94/255, alpha: 1), forState: .Normal)
    backtomenu.setTitle("もどる", forState: .Highlighted)
    backtomenu.setTitleColor(UIColor.blackColor(), forState: .Highlighted)
    backtomenu.layer.position = CGPoint(x: 60, y: phoneSize.height*0.9-10)
    backtomenu.layer.cornerRadius = 20
    self.view!.addSubview(backtomenu)

    self.addChild(Label)
  }
  
  func makeScroll(){
    Scroll.scrollEnabled = true
    Scroll.contentSize = CGSize(width:0 , height: 540)
    Scroll.indicatorStyle = UIScrollViewIndicatorStyle.Black
    Scroll.center = CGPoint(x: phoneSize.width*0.5, y: phoneSize.height*0.5)
    Scroll.backgroundColor = UIColor(red: 1, green: 1, blue: 1, alpha: 0.5)
    self.view!.addSubview(Scroll)
    
    var husenImages = ["rhusen","ghusen","bhusen"]
    for i in 0...8 {
      var View = UIView()
      View.userInteractionEnabled = true
      var HGH :CGFloat = 120  //高さの間隔
      var WhereY = floor(CGFloat(i/3)) //何行目？
      var which :CGFloat = CGFloat(i%3)
      View.frame = CGRectMake(120*which, HGH*WhereY, 120, 120)
      
      //画像の用意
      var husenImage = UIImage(named: husenImages[i%3])
      var husenimageView = UIImageView(image: husenImage)
      husenimageView.frame = CGRectMake(0, 0, 120, 120)
      husenimageView.tag = i
      husenimageView.userInteractionEnabled = true
      View.addSubview(husenimageView)
      
      var Image = UIImage(named: "burgar1")
      var imageView = UIImageView(image: Image)
      imageView.frame = CGRectMake(0, 0, 60, 60)
      imageView.center = CGPointMake(husenimageView.center.x, husenimageView.center.y+10)
      imageView.tag = i
      imageView.userInteractionEnabled = true
      
      //画像にアクション適用、表示
      let action = UITapGestureRecognizer(target:self, action: "makeWindow:")
      imageView.addGestureRecognizer(action)
      View.addSubview(imageView)
      
      //商品名
      var myTextView = UITextView(frame: CGRectMake(0, 0, 110, 30))
      myTextView.userInteractionEnabled = false
      myTextView.backgroundColor = UIColor.clearColor()
      myTextView.text = "ハンバーガー"
      myTextView.font = UIFont.systemFontOfSize(CGFloat(15))
      myTextView.textColor = fontcolor
      myTextView.textAlignment = NSTextAlignment.Center
      myTextView.editable = false
      myTextView.center = CGPointMake(husenimageView.center.x,20)
      View.addSubview(myTextView)
      
      //値段を入れる
      var price = UITextView(frame: CGRectMake(0, 0, 40, 30))
      price.userInteractionEnabled = false
      price.editable = false
      price.text = "\(foodData[i%3][0])"
      price.backgroundColor = UIColor.yellowColor()
      price.font = UIFont.systemFontOfSize(CGFloat(15))
      price.textColor = fontcolor
      price.textAlignment = NSTextAlignment.Left
      price.center = CGPointMake(95,95)
      View.addSubview(price)
      
      Scroll.addSubview(View)
    }
    
  }
  
  func makeButtons(){
    BuyButton = UIButton(frame: CGRectMake(0, 0, 100, 50))
    BuyButton.backgroundColor = UIColor.redColor()
    BuyButton.addTarget(self, action: "Buyfood:", forControlEvents: .TouchUpInside)
    BuyButton.setTitle("購入", forState: .Normal)
    BuyButton.setTitleColor(UIColor.whiteColor(), forState: .Normal)
    BuyButton.setTitle("購入", forState: .Highlighted)
    BuyButton.setTitleColor(UIColor.blackColor(), forState: .Highlighted)
    BuyButton.layer.position = CGPoint(x: 150, y: 200)
    
    cancelButton = UIButton(frame: CGRectMake(0, 0, 100, 50))
    cancelButton.backgroundColor = UIColor.blueColor()
    cancelButton.addTarget(self, action: "Goback:", forControlEvents: .TouchUpInside)
    cancelButton.setTitle("キャンセル", forState: .Normal)
    cancelButton.setTitleColor(UIColor.whiteColor(), forState: .Normal)
    cancelButton.setTitle("キャンセル", forState: .Highlighted)
    cancelButton.setTitleColor(UIColor.blackColor(), forState: .Highlighted)
    cancelButton.layer.position = CGPoint(x: 150, y: 250)
    
    backButton = UIButton(frame: CGRectMake(0, 0, 100, 50))
    backButton.backgroundColor = UIColor.blueColor()
    backButton.addTarget(self, action: "Goback:", forControlEvents: .TouchUpInside)
    backButton.setTitle("戻る", forState: .Normal)
    backButton.setTitleColor(UIColor.whiteColor(), forState: .Normal)
    backButton.setTitle("戻る", forState: .Highlighted)
    backButton.setTitleColor(UIColor.blackColor(), forState: .Highlighted)
    backButton.layer.position = CGPoint(x: 150, y: 250)
    
    Text = UITextView(frame: CGRectMake(0, 0, 300, 100))
    Text.userInteractionEnabled = true
    Text.backgroundColor = UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.0)
    Text.text = ""
    Text.font = UIFont.systemFontOfSize(CGFloat(20))
    Text.textColor = UIColor.blackColor()
    Text.textAlignment = NSTextAlignment.Left
    Text.editable = false
    Text.center = CGPointMake(self.view!.frame.width/2,100)
  }
  
  override func update(currentTime: NSTimeInterval) {
  }
  
  func layoutObject(){

    var backnumber :Int = 0
    var i = 0
    
    let background = SKSpriteNode(imageNamed: "con.jpg")
    background.position = CGPoint(x: self.size.width*0.5, y: self.size.height*0.5)
    background.xScale = 1.5
    background.yScale = 1.5
    self.addChild(background)
    
    var kanban = SKSpriteNode(imageNamed:"kanban8")
    kanban.xScale = 0.6
    kanban.yScale = 0.6
    var height = kanban.frame.height*0.5
    kanban.position = CGPoint(x: self.size.width*0.5, y: self.size.height-height)
    self.addChild(kanban)
    
    PointView = UITextView(frame: CGRect(x: 0, y: 0, width: 250, height: 50))
    PointView.layer.position = CGPoint(x: phoneSize.width*0.5, y: phoneSize.height*0.2)
    PointView.backgroundColor = UIColor.yellowColor()
    PointView.textColor = fontcolor
    PointView.textAlignment = .Center
    PointView.font = UIFont.systemFontOfSize(CGFloat(20))
    PointView.text = "所持ポイント：\(toString(PlayerPoint))"
    PointView.layer.cornerRadius = 20
    PointView.editable = false
    self.view!.addSubview(PointView)
    
  }
  
  override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
  }
  
  func backtomenu(sender: UIButton){
    let tr = SKTransition.crossFadeWithDuration(0.1)
    let newScene = GameScene(size: self.scene!.size)
    newScene.scaleMode = SKSceneScaleMode.AspectFill
    self.scene!.view!.presentScene(newScene, transition: tr)
  }
  
  func makeWindow(recognizer: UIGestureRecognizer){ //ウィンドウ作成
    if (Flg == false){
      if let imageView = recognizer.view as? UIImageView {
        Flg = true
        //まずはウィンドウ作ろう
        selected = imageView.tag%3
        var point = foodData[selected][0]
        myWindow.backgroundColor = UIColor.whiteColor()
        myWindow.layer.position = CGPointMake(self.view!.frame.width/2, self.view!.frame.height/2)
        myWindow.alpha = 1.0
        // myWindowをkeyWindowにする.
        myWindow.makeKeyWindow()
        self.view!.addSubview(myWindow)
        self.myWindow.makeKeyAndVisible()
        
        if(PlayerPoint >= point){ //足りる！
          Text.text = "購入してエサを与えますか？\n必要ポイント：\(point)P\n所持ポイント：\(PlayerPoint)P"
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
  
  internal func Goback(sender: UIButton){ //戻る
    Flg = false
    myWindow.hidden = true
    Scroll.hidden = false
  }
  
  //ここからデータベースに関連するもの
  
  func readPoint(){
    println("readData ------------")
    let app: AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    let categoryContext: NSManagedObjectContext = app.managedObjectContext!
    let categoryRequest: NSFetchRequest = NSFetchRequest(entityName: "User")
    
    var results: NSArray! = categoryContext.executeFetchRequest(categoryRequest, error: nil)
    for data in results{
      PlayerPoint = data.valueForKey("money") as! Int
    }
    
  }
  
  internal func Buyfood(sender: UIButton){ //買う
    app.FoodFlg = true
    PlayerPoint = PlayerPoint - foodData[selected][0]
    
    //Userのmoneyを減らす
    let categoryContext: NSManagedObjectContext = app.managedObjectContext!
    let categoryRequest: NSFetchRequest = NSFetchRequest(entityName: "User")
    var resultPoint = categoryContext.executeFetchRequest(categoryRequest, error: nil)!
    for data in resultPoint{
      data.setValue(PlayerPoint, forKey: "money")
      var error: NSError?
      categoryContext.save(&error)
    }
    
    let tr = SKTransition.crossFadeWithDuration(0.1)
    let newScene = GameScene(size: self.scene!.size)
    newScene.scaleMode = SKSceneScaleMode.AspectFill
    self.scene!.view!.presentScene(newScene, transition: tr)
  }
  
  override func willMoveFromView(view: SKView) {
    Scroll.removeFromSuperview()
    myWindow.hidden = true
    backtomenu.hidden = true
    PointView.hidden = true
  }
  
  
}
