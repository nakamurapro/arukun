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
  var sprite = SKSpriteNode(imageNamed:"0")
  var Scroll = UIScrollView(frame: CGRect(x: 0, y: 0, width: 300, height: 300))

  var PlayerPoint :Int!
  var selected :Int!
  var phoneSize :CGSize = UIScreen.mainScreen().bounds.size //画面サイズ
  var pointLabel = SKLabelNode(fontNamed:"Hiragino Kaku Gothic ProN")
  var scoreSprite = SKSpriteNode(imageNamed: "score")
  var Label = SKLabelNode(fontNamed:"Hiragino Kaku Gothic ProN")
  var PlayerLabel = SKLabelNode(fontNamed:"Hiragino Kaku Gothic ProN")
  
  var myWindow :UIWindow!
  var BuyButton :UIButton!
  var cancelButton :UIButton!
  var backButton :UIButton!
  var Text :UITextView!
  
  var Counter :Int = 0
  
  var Flg :Bool = false
  var Furniture :Array<SKSpriteNode> = []
  
  var foodData = [[50,30,0,0],[50,0,30,0],[70,0,10,40]] //まだ準備段階
  
  override func didMoveToView(view: SKView) {
    //        /* Setup your scene here */
    readPoint()
    
    layoutObject()
    makeScroll()
    makeButtons()
    scoreLayout()
    //        self.physicsWorld.contactDelegate = self
    self.physicsWorld.gravity = CGVector(dx: 0, dy: 0)
    self.physicsBody = SKPhysicsBody(edgeLoopFromRect: self.frame)
    Label.text = "戻る"
    Label.fontSize = 50
    Label.fontColor = UIColor(red:0 , green: 0, blue: 0, alpha: 1)//黒
    Label.position = CGPoint(x: self.size.width*0.4, y: self.size.height*0.1)
    Label.zPosition = 0
    Label.name = "next"
    
    self.addChild(Label)
  }
  
  func scoreLayout(){
    scoreSprite.position = CGPoint(x: self.size.width*0.5, y: self.size.height-100)
    pointLabel.text = "エサ"
    pointLabel.fontSize = 50
    pointLabel.fontColor = UIColor(red:0 , green: 0, blue: 0, alpha: 1)//黒
    pointLabel.position = CGPoint(x:scoreSprite.position.x, y:scoreSprite.position.y-5)
    pointLabel.zPosition = 0
    
    PlayerLabel.text = "所持ポイント：\(PlayerPoint)P"
    PlayerLabel.fontSize = 20
    PlayerLabel.fontColor = UIColor(red:0 , green: 0, blue: 0, alpha: 1)//黒
    PlayerLabel.position = CGPoint(x:self.size.width*0.6, y:self.size.width*0.1)
    PlayerLabel.zPosition = 0
    
    self.addChild(scoreSprite)
    self.addChild(pointLabel)
    self.addChild(PlayerLabel)
    
    
    sprite.xScale = 0.05
    sprite.yScale = 0.05
    sprite.position = CGPoint(x: self.size.width*0.5, y: self.size.height*0.25)
    
    self.addChild(sprite)
    
    //エサを食べるテストです
  }
  
  func makeScroll(){
    var heightScroll = ceil(10.0 / 2.0)
    Scroll.scrollEnabled = true
    Scroll.contentSize = CGSize(width:0 , height: 180*heightScroll)
    Scroll.indicatorStyle = UIScrollViewIndicatorStyle.Black
    Scroll.center = CGPoint(x: phoneSize.width*0.5, y: phoneSize.height*0.4)
    Scroll.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.5)
    self.view!.addSubview(Scroll)
    
    for i in 0...9 {
      var View = UIView()
      View.userInteractionEnabled = true
      var HGH :CGFloat = 180  //高さの間隔
      var WhereY = floor(CGFloat(i/2)) //何行目？
      var which :CGFloat = CGFloat(i%2)
      View.frame = CGRectMake(150*which, HGH*WhereY, 150, 150)
      
      //画像の用意
      var Image = UIImage(named: "burgar1")
      var imageView = UIImageView(image: Image)
      imageView.frame = CGRectMake(0, 0, 120, 120)
      imageView.center = CGPointMake(75,90)
      imageView.tag = i
      imageView.userInteractionEnabled = true
      
      //画像にアクション適用、表示
      let action = UITapGestureRecognizer(target:self, action: "makeWindow:")
      imageView.addGestureRecognizer(action)
      View.addSubview(imageView)
      
      //商品名
      var myTextView = UITextView(frame: CGRectMake(0, 0, 130, 30))
      myTextView.userInteractionEnabled = false
      myTextView.backgroundColor = UIColor(red: 0.0, green: 0.8, blue: 0.8, alpha: 1.0)
      myTextView.text = "ハンバーガー"
      myTextView.font = UIFont.systemFontOfSize(CGFloat(15))
      myTextView.textColor = UIColor.whiteColor()
      myTextView.textAlignment = NSTextAlignment.Center
      myTextView.editable = false
      myTextView.center = CGPointMake(75,15)
      View.addSubview(myTextView)
      
      //値段を入れる
      var price = UITextView(frame: CGRectMake(0, 0, 50, 30))
      price.userInteractionEnabled = false
      price.editable = false
      price.text = "\(foodData[i%3][0])"
      price.backgroundColor = UIColor.orangeColor()
      price.font = UIFont.systemFontOfSize(CGFloat(15))
      price.textColor = UIColor.whiteColor()
      price.textAlignment = NSTextAlignment.Left
      price.center = CGPointMake(125,135)
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
    backButton.layer.position = CGPoint(x: 0, y: 0)
    
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
    // pointLabel.text = toString(Counter) + "歩"
  }
  
  func layoutObject(){

    var backnumber :Int = 0
    var i = 0
    
    let background = SKSpriteNode(imageNamed: "con.jpg")
    background.position = CGPoint(x: self.size.width*0.5, y: self.size.height*0.5)
    background.xScale = 1.5
    background.yScale = 1.5
    self.addChild(background)
    
  }
  
  override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
    /* Called when a touch begins */
    
    for touch in (touches as! Set<UITouch>) {
      let location = touch.locationInNode(self)
      let touchedNode = self.nodeAtPoint(location)
      if(touchedNode.name == "next"){
        Scroll.hidden = true
        let tr = SKTransition.crossFadeWithDuration(0.1)
        let newScene = GameScene(size: self.scene!.size)
        newScene.scaleMode = SKSceneScaleMode.AspectFill
        self.scene!.view!.presentScene(newScene, transition: tr)
      }
    }
  }
  
  func makeWindow(recognizer: UIGestureRecognizer){ //ウィンドウ作成
    if (Flg == false){
      if let imageView = recognizer.view as? UIImageView {
        Flg = true
        //まずはウィンドウ作ろう
        selected = imageView.tag%3
        var point = foodData[selected][0]
        myWindow = UIWindow(frame: CGRectMake(0, 0, 300, 300))
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
    Scroll.hidden = true
    myWindow.hidden = true
    app.FoodFlg = true
    PlayerPoint = PlayerPoint - foodData[selected][0]
    
    //Userのmoneyを減らす
    /*let categoryContext: NSManagedObjectContext = app.managedObjectContext!
    let categoryRequest: NSFetchRequest = NSFetchRequest(entityName: "User")
    var resultPoint = categoryContext.executeFetchRequest(categoryRequest, error: nil)!
    for data in resultPoint{
      data.setValue(PlayerPoint, forKey: "money")
      var error: NSError?
      categoryContext.save(&error)
    }*/
    
    let tr = SKTransition.crossFadeWithDuration(0.1)
    let newScene = GameScene(size: self.scene!.size)
    newScene.scaleMode = SKSceneScaleMode.AspectFill
    self.scene!.view!.presentScene(newScene, transition: tr)
  }
  
  override func willMoveFromView(view: SKView) {
    Scroll.removeFromSuperview()
  }
}
