import Foundation
import UIKit
import SpriteKit
import CoreData

class FurnitureScene: SKScene {
    //まず家具購入に必要な物
    let app: AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate

    var phoneSize :CGSize = UIScreen.mainScreen().bounds.size //画面サイズ
    var FurnitureBuyButton :UIButton!
    var FurnitureSetButton :UIButton!
    var click = SKAction.playSoundFileNamed("click.mp3", waitForCompletion: true)
    
    override func didMoveToView(view: SKView) {
        //まずScrollViewを2つ作るよ
      self.runAction(click)
      var background = SKSpriteNode(imageNamed: "con.jpg")
      background.xScale = 1.5
      background.yScale = 1.5
      background.position = CGPoint(x: self.size.width*0.5, y: self.size.height*0.5)
      self.addChild(background)
      
      var kanban = SKSpriteNode(imageNamed:"kanban7")
      kanban.xScale = 0.6
      kanban.yScale = 0.6
      var height = kanban.frame.height*0.5
      kanban.position = CGPoint(x: self.size.width*0.5, y: self.size.height-height)
      self.addChild(kanban)
      
        if (readData().count == 0){
            initMasters()
        }
        let buyimage = UIImage(named: "buy") as UIImage?
        FurnitureBuyButton = UIButton(frame: CGRectMake(0, 0, 200, 200))
        FurnitureBuyButton.addTarget(self, action: "FurnitureBuy:", forControlEvents: .TouchUpInside)
        FurnitureBuyButton.layer.position = CGPoint(x: phoneSize.width*0.5, y: phoneSize.height*0.7)
        FurnitureBuyButton.setImage(buyimage, forState: .Normal)
        self.view!.addSubview(FurnitureBuyButton)
        
        ////押したら家具配置画面が出てくる
        let setimage = UIImage(named: "set") as UIImage?
        FurnitureSetButton = UIButton(frame: CGRectMake(0, 0, 200, 200))
        FurnitureSetButton.addTarget(self, action: "FurnitureSet:", forControlEvents: .TouchUpInside)
        FurnitureSetButton.layer.position = CGPoint(x: phoneSize.width*0.5, y: phoneSize.height*0.3)
        FurnitureSetButton.setImage(setimage, forState: .Normal)
        self.view!.addSubview(FurnitureSetButton)
        
    }
    
    func FurnitureBuy(sender: UIButton){
        allHidden()
        let tr = SKTransition.fadeWithColor(UIColor.whiteColor(), duration: 0.0)
        let newScene = FurnitureBuyScene(size: self.scene!.size)
        newScene.scaleMode = SKSceneScaleMode.AspectFill
        self.scene!.view!.presentScene(newScene, transition: tr)
    }
    
    func FurnitureSet(sender: UIButton){
        allHidden()
        let tr = SKTransition.fadeWithColor(UIColor.whiteColor(), duration: 0.0)
        let newScene = FurnitureSetScene(size: self.scene!.size)
        newScene.scaleMode = SKSceneScaleMode.AspectFill
        self.scene!.view!.presentScene(newScene, transition: tr)
    }
  
  func allHidden(){
    FurnitureBuyButton.hidden = true
    FurnitureSetButton.hidden = true
  }
  
    func readData() -> NSArray{
        println("readData ------------")
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
  
}
