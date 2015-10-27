import Foundation
import UIKit
import SpriteKit

class FurnitureScene: SKScene {
    //まず家具購入に必要な物
    var phoneSize :CGSize = UIScreen.mainScreen().bounds.size //画面サイズ
    var FurnitureBuyButton :UIButton!
    var FurnitureSetButton :UIButton!
    
    
    override func didMoveToView(view: SKView) {
        //まずScrollViewを2つ作るよ
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
    
}
