//
//  GameScene.swift
//  chara_screen
//
//  Created by chikaratada on H27/10/05.
//  Copyright (c) 平成27年 SenshuUNIV. All rights reserved.
//

import SpriteKit
import Foundation
import CoreMotion
import CoreData

class GameScene: SKScene {
  var app:AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
  var phoneSize :CGSize = UIScreen.mainScreen().bounds.size //画面サイズ
  var pointLabel = SKLabelNode(fontNamed:"Hiragino Kaku Gothic ProN")
  var scoreSprite = SKSpriteNode(imageNamed: "score")
  var sprite = SKSpriteNode(imageNamed:"01")
  var backtomenu :UIButton!
  var myMotionManager: CMMotionManager!
  var foodButton: UIButton!
  
  var Rooms: NSArray!
  var Furnitures: NSArray!
  var Animation = [SKTexture]()
  
  var Flg :Bool = false
  
  var Furniture :Array<SKSpriteNode> = []
  
  override func didMoveToView(view: SKView) {
    //        /* Setup your scene here */
    
    readPoint()
    var charaImages = readPictures()
    if(charaImages.count == 0){
      initCharaMasters()
      charaImages  = readPictures()
    }
    Rooms = readRoom()
    if(Rooms.count == 0){
      makeRoom()
      Rooms = readRoom()
    }
    
    Furnitures = readData()
    if(Furnitures.count == 0 ){
      initMasters()
      Furnitures = readData()
      
    }
    layoutObject()
    setFurniture()
    scoreLayout()
    
    let foodimage = UIImage(named: "esa") as UIImage?
    foodButton = UIButton(frame: CGRectMake(0, 0, 50, 50))
    foodButton.addTarget(self, action: "Buyfood:", forControlEvents: .TouchUpInside)
    foodButton.layer.position = CGPoint(x: 50, y: self.frame.height-200)
    foodButton.setImage(foodimage, forState: .Normal)
    self.view!.addSubview(foodButton)
    
    //        self.physicsWorld.contactDelegate = self
    self.physicsWorld.gravity = CGVector(dx: 0, dy: 0)
    self.physicsBody = SKPhysicsBody(edgeLoopFromRect: self.frame)
    sprite.physicsBody = SKPhysicsBody(circleOfRadius: 500)
    
    sprite.xScale = 0.35
    sprite.yScale = 0.35
    sprite.position = CGPoint(x: self.size.width*0.5, y: self.size.height*0.5)
    
    self.addChild(sprite)
    
    //キャラクターにアニメを追加、まずは呼吸
    var anime1 = SKAction.scaleYTo(0.40, duration: 1.5)
    var anime2 = SKAction.scaleYTo(0.35, duration: 1.5)
    var anime3 = SKAction.waitForDuration(3.0)
    var Anime = SKAction.sequence([anime1,anime2,anime3])
    var RepeatAnime = SKAction.repeatActionForever(Anime)
    sprite.runAction(RepeatAnime)
    
    //続いてパラパラ
    
    for image in charaImages{
      var texture = SKTexture(imageNamed: image.valueForKey("picturename")! as! String)
      texture.filteringMode = .Linear
      Animation.append(texture)
    }
    let spriteAnimation = SKAction.animateWithTextures(Animation, timePerFrame: 2.0)
    let repeatAnimation = SKAction.repeatActionForever(spriteAnimation)
    sprite.runAction(repeatAnimation)
    

    
    if(app.FoodFlg == true){
      var Name = app.esaName
      var Number = app.esaNumber
      var food = SKSpriteNode(imageNamed: "\(Name)esa\(Number)-1")
      food.position = CGPoint(x: sprite.position.x, y: sprite.position.y-180)
      food.xScale = 0.3
      food.yScale = 0.3
      self.addChild(food)
      var images = [SKTexture]()
      var esaNames = ["\(Name)esa\(Number)-1" , "\(Name)esa\(Number)-2" , "\(Name)esa\(Number)-3" , "nothing"]
      for image in esaNames{
        var texture = SKTexture(imageNamed: image)
        texture.filteringMode = .Linear
        images.append(texture)     //テクスチャの追加
      }
      println(images)
      let Animate = SKAction.animateWithTextures(images, timePerFrame: 0.6)
      food.runAction(Animate)

      var spriteAction1 = SKAction.scaleYTo(0.40, duration: 0.3)
      var spriteAction2 = SKAction.scaleYTo(0.35, duration: 0.3)
      var Actions = SKAction.sequence([spriteAction1,spriteAction2])
      var RepeatAction = SKAction.repeatAction(Actions, count: 3)
      sprite.runAction(RepeatAction)
  
      app.FoodFlg = false
    }
    
  }
  
  func scoreLayout(){
    //        scoreSprite.xScale = 1
    //        scoreSprite.yScale = 1
    scoreSprite.position = CGPoint(x: self.size.width*0.5, y: self.size.height-50)
    pointLabel.text = "0歩"
    pointLabel.fontSize = 20
    pointLabel.fontColor = UIColor(red:0 , green: 0, blue: 0, alpha: 1)//黒
    pointLabel.position = CGPoint(x:scoreSprite.position.x, y:scoreSprite.position.y-5)
    pointLabel.zPosition = 7
    
    self.addChild(scoreSprite)
    self.addChild(pointLabel)
  }
  override func update(currentTime: NSTimeInterval) {
    pointLabel.text = toString(app.counter) + "歩"
    
  }
  
  func layoutObject(){
    var text :String = ""
    var backnumber :Int = 0
    for data in Rooms{
      backnumber = data.valueForKey("background") as! Int
    }
    
    var i = 0
    for fur in Furnitures{
      if(backnumber == i){
        text = fur.valueForKey("image") as! String
        break
      }
      i++
    }
    let background = SKSpriteNode(imageNamed: text)
    background.position = CGPoint(x: self.size.width*0.5, y: self.size.height*0.5)
    background.xScale = 0.5
    background.yScale = 0.5
    self.addChild(background)
    
    
  }
  
  func setFurniture(){
    for data in Rooms{
      for i in 0...3{
        var x :Array<CGFloat> = [0.42,0.58,0.37,0.63]
        var y :Array<CGFloat> = [0.65,0.65,0.3,0.3]
        var scale :Array<CGFloat> = [0.325,0.325,0.4,0.4]
        var imageNumber = data.valueForKey("fur\(i+1)") as! Int
        if(imageNumber == -1){
          Furniture.append(SKSpriteNode(imageNamed: "nothing"))
        }else{
          var imageName = Furnitures[imageNumber].valueForKey("image") as! String
          Furniture.append(SKSpriteNode(imageNamed: imageName))
          Furniture[i].xScale = scale[i]
          Furniture[i].yScale = scale[i]
        }
        Furniture[i].position = CGPoint(x: self.size.width*x[i], y: self.size.height*y[i])
        self.addChild(Furniture[i])
      }
    }
  }
  
  override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
    /* Called when a touch begins */
    
    for touch in (touches as! Set<UITouch>) {
      let location = touch.locationInNode(self)
      let touchedNode = self.nodeAtPoint(location)
      var move = SKAction.moveTo(CGPoint(x: location.x, y: location.y), duration: 1.5)
      sprite.runAction(move)
    }
  }
  
  func Buyfood(sender: UIButton){
    foodButton.hidden = true
    
    let tr = SKTransition.fadeWithColor(UIColor.whiteColor(), duration: 0.0)
    let newScene = foodScene(size: self.scene!.size)
    newScene.scaleMode = SKSceneScaleMode.AspectFill
    self.scene!.view!.presentScene(newScene, transition: tr)
  }
  
  
  //ここらへんデータベースです
  func readRoom() -> NSArray{
    let categoryContext: NSManagedObjectContext = app.managedObjectContext!
    let categoryRequest: NSFetchRequest = NSFetchRequest(entityName: "Room")
    var error: NSError? = nil;
    var results: NSArray! = categoryContext.executeFetchRequest(categoryRequest, error: nil)
    return results!
  }
  
  func makeRoom() {
    //plist読み込み
    let categoryContext: NSManagedObjectContext = app.managedObjectContext!
    let categoryEntity: NSEntityDescription! = NSEntityDescription.entityForName(
      "Room", inManagedObjectContext: categoryContext)
    var new_data  = NSManagedObject(entity: categoryEntity, insertIntoManagedObjectContext: categoryContext)
    new_data.setValue(20, forKey: "background")
    new_data.setValue(-1, forKey: "fur1")
    new_data.setValue(-1, forKey: "fur2")
    new_data.setValue(-1, forKey: "fur3")
    new_data.setValue(-1, forKey: "fur4")
    
    var error: NSError?
    categoryContext.save(&error)
    
    println("InitMasters OK!")
  }
  
  func readData() -> NSArray{
    println("readData ------------")
    let app: AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    let categoryContext: NSManagedObjectContext = app.managedObjectContext!
    let categoryRequest: NSFetchRequest = NSFetchRequest(entityName: "Furniture")
    
    var results: NSArray! = categoryContext.executeFetchRequest(categoryRequest, error: nil)
    return results
  }
  
  func initMasters() {
    println("initMasters ------------")
    //plist読み込み
    let path:NSString = NSBundle.mainBundle().pathForResource("FurnitureMaster", ofType: "plist")!
    var masterDataDictionary:NSArray = NSArray(contentsOfFile: path as String)!
    let categoryContext: NSManagedObjectContext = app.managedObjectContext!
    
    for item in masterDataDictionary{
      let categoryEntity: NSEntityDescription! = NSEntityDescription.entityForName(
        "Furniture", inManagedObjectContext: categoryContext)
      var new_data  = NSManagedObject(entity: categoryEntity, insertIntoManagedObjectContext: categoryContext)
      
      new_data.setValue(item.valueForKey("name"), forKey: "name")
      new_data.setValue(item.valueForKey("kind"), forKey: "kind")
      new_data.setValue(item.valueForKey("image"), forKey: "image")
      new_data.setValue(item.valueForKey("point"), forKey: "point")
      new_data.setValue(item.valueForKey("haved"), forKey: "haved")
      var error: NSError?
      categoryContext.save(&error)
      
    }
    println("InitMasters OK!")
    
  }
  
  func readPoint(){
    println("readUser ------------")
    let app: AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    let categoryContext: NSManagedObjectContext = app.managedObjectContext!
    let categoryRequest: NSFetchRequest = NSFetchRequest(entityName: "User")
    
    var results: NSArray! = categoryContext.executeFetchRequest(categoryRequest, error: nil)
    if(results.count == 0){
      makeUser()
    }else{
      var resultPoint = categoryContext.executeFetchRequest(categoryRequest, error: nil)!
      for data in resultPoint{
        var money = data.valueForKey("money") as! Int
        money = money + (app.counter - app.i)
        data.setValue(money, forKey: "money")
        var error: NSError?
        categoryContext.save(&error)
        app.i = app.counter
      }
      
    }
  }
  
  func readPictures() -> NSArray{
    println("readData ------------")
    let app: AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    let categoryContext: NSManagedObjectContext = app.managedObjectContext!
    let categoryRequest: NSFetchRequest = NSFetchRequest(entityName: "Charapicture")
    let predicate = NSPredicate(format: "charanumber = %d", 1)
    categoryRequest.predicate = predicate
    var results: NSArray! = categoryContext.executeFetchRequest(categoryRequest, error: nil)
    return results
    
  }
  
  
  func makeUser(){
    let app: AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    let categoryContext: NSManagedObjectContext = app.managedObjectContext!
    let categoryEntity: NSEntityDescription! = NSEntityDescription.entityForName(
      "User", inManagedObjectContext: categoryContext)
    var new_data  = NSManagedObject(entity: categoryEntity, insertIntoManagedObjectContext: categoryContext)
    new_data.setValue(10000, forKey: "money")
    new_data.setValue(160, forKey: "stature") //身長のこと
    new_data.setValue(0, forKey: "stride")
    new_data.setValue(1, forKey: "nowgrowing")
    
    var error: NSError?
  }
  
  func initCharaMasters() {
    println("initMasters ------------")
    //plist読み込み
    let path:NSString = NSBundle.mainBundle().pathForResource("CharapictureMaster", ofType: "plist")!
    var masterDataDictionary :NSDictionary = NSDictionary(contentsOfFile: path as String)!
    let app: AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    let categoryContext: NSManagedObjectContext = app.managedObjectContext!
    
    for(var i = 0; i<masterDataDictionary.count; i++) {
      let index_name: String = "item" + String(i)
      var item: AnyObject = masterDataDictionary[index_name]!
      
      let categoryEntity: NSEntityDescription! = NSEntityDescription.entityForName(
        "Charapicture", inManagedObjectContext: categoryContext)
      var new_data  = NSManagedObject(entity: categoryEntity, insertIntoManagedObjectContext: categoryContext)
      
      new_data.setValue(item.valueForKey("charanumber"), forKey: "charanumber")
      new_data.setValue(item.valueForKey("picturenumber"), forKey: "picturenumber")
      new_data.setValue(item.valueForKey("image"), forKey: "picturename")
      
      var error: NSError?
      categoryContext.save(&error)
      
    }
  }
  

}
