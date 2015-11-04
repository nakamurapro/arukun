import Foundation
import UIKit
import SpriteKit
import CoreData

class FurnitureScene: SKScene {
    //まず家具購入に必要な物
    var phoneSize :CGSize = UIScreen.mainScreen().bounds.size //画面サイズ
    var FurnitureBuyButton :UIButton!
    var FurnitureSetButton :UIButton!
    
    
    override func didMoveToView(view: SKView) {
        //まずScrollViewを2つ作るよ
        if (readData().count == 0){
            initMasters()
        }else if (readData().count == 5){
            addData()
        }
        FurnitureBuyButton = UIButton(frame: CGRectMake(0, 0, 100, 50))
        FurnitureBuyButton.backgroundColor = UIColor.redColor()
        FurnitureBuyButton.addTarget(self, action: "FurnitureBuy:", forControlEvents: .TouchUpInside)
        FurnitureBuyButton.setTitle("家具を購入", forState: .Normal)
        FurnitureBuyButton.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        FurnitureBuyButton.setTitle("家具を購入", forState: .Highlighted)
        FurnitureBuyButton.setTitleColor(UIColor.blackColor(), forState: .Highlighted)
        FurnitureBuyButton.layer.position = CGPoint(x: phoneSize.width*0.5, y: phoneSize.height*0.5)
        self.view!.addSubview(FurnitureBuyButton)
        
        ////押したら家具配置画面が出てくる
        FurnitureSetButton = UIButton(frame: CGRectMake(0, 0, 100, 50))
        FurnitureSetButton.backgroundColor = UIColor.redColor()
        FurnitureSetButton.addTarget(self, action: "FurnitureSet:", forControlEvents: .TouchUpInside)
        FurnitureSetButton.setTitle("家具を配置", forState: .Normal)
        FurnitureSetButton.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        FurnitureSetButton.setTitle("家具を配置", forState: .Highlighted)
        FurnitureSetButton.setTitleColor(UIColor.blackColor(), forState: .Highlighted)
        FurnitureSetButton.layer.position = CGPoint(x: phoneSize.width*0.5, y: phoneSize.height*0.3)
        self.view!.addSubview(FurnitureSetButton)
        
    }
    
    func FurnitureBuy(sender: UIButton){
        FurnitureBuyButton.hidden = true
        FurnitureSetButton.hidden = true
        
        let tr = SKTransition.fadeWithColor(UIColor.whiteColor(), duration: 0.0)
        let newScene = FurnitureBuyScene(size: self.scene!.size)
        newScene.scaleMode = SKSceneScaleMode.AspectFill
        self.scene!.view!.presentScene(newScene, transition: tr)
    }
    
    func FurnitureSet(sender: UIButton){
        FurnitureBuyButton.hidden = true
        FurnitureSetButton.hidden = true
        
        let tr = SKTransition.fadeWithColor(UIColor.whiteColor(), duration: 0.0)
        let newScene = FurnitureSetScene(size: self.scene!.size)
        newScene.scaleMode = SKSceneScaleMode.AspectFill
        self.scene!.view!.presentScene(newScene, transition: tr)
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
        var masterDataDictionary:NSDictionary = NSDictionary(contentsOfFile: path as String)!
        let app: AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let categoryContext: NSManagedObjectContext = app.managedObjectContext!
        
        for(var i = 1; i<=masterDataDictionary.count; i++) {
            let index_name: String = "item" + String(i)
            var item: AnyObject = masterDataDictionary[index_name]!
            
            let categoryEntity: NSEntityDescription! = NSEntityDescription.entityForName(
                "Furniture", inManagedObjectContext: categoryContext)
            var new_data  = NSManagedObject(entity: categoryEntity, insertIntoManagedObjectContext: categoryContext)
            new_data.setValue(item.valueForKey("name") as! String, forKey: "name")
            new_data.setValue(item.valueForKey("kind") as! Int, forKey: "kind")
            new_data.setValue(item.valueForKey("image") as! String, forKey: "image")
            new_data.setValue(item.valueForKey("point") as! Int, forKey: "point")
            new_data.setValue(item.valueForKey("haved"), forKey: "haved")
            
            var error: NSError?
            categoryContext.save(&error)
            
        }
        println("InitMasters OK!")
    }
    
    func addData() {
        println("initMasters ------------")
        //plist読み込み
        let path:NSString = NSBundle.mainBundle().pathForResource("FurnitureMaster", ofType: "plist")!
        var masterDataDictionary:NSDictionary = NSDictionary(contentsOfFile: path as String)!
        let app: AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let categoryContext: NSManagedObjectContext = app.managedObjectContext!

            
        let categoryEntity: NSEntityDescription! = NSEntityDescription.entityForName(
                "Furniture", inManagedObjectContext: categoryContext)
        var new_data  = NSManagedObject(entity: categoryEntity, insertIntoManagedObjectContext: categoryContext)
        new_data.setValue("モノクロな背景", forKey: "name")
        new_data.setValue(2, forKey: "kind")
        new_data.setValue("back2", forKey: "image")
        new_data.setValue(500, forKey: "point")
        new_data.setValue(true, forKey: "haved")
            
        var error: NSError?
        categoryContext.save(&error)

        println("InitMasters OK!")
    }
    
}
