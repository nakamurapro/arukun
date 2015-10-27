import Foundation
import UIKit
import SpriteKit
import CoreData

class FurnitureSetScene: SKScene {
    var Scroll: UIScrollView!
    var phoneSize :CGSize = UIScreen.mainScreen().bounds.size //画面サイズ
    private var TextFurniture :UITextView! //テキスト
    private var imageViews :Array<UIImageView> = [] //これは商品一覧
    var SetButtons :Array<UIButton> = []
    var setFurniture :Array<UIImageView> = [] //これは置いてある家具
    private var myTextView :UITextView! //家具の名前
    var backView :UIImageView! //背景
    var Images :Array<UIImage> = []
    var place = ["左上","右上","左下","右下"]
    var names :Array<String> = ["木のイス","しゃれたイス","こさねぇ","観葉植物"]
    var SetFlug :Bool = false //家具置いてるところかどうか
    private var SetNumber :Int! //何番の家具を置こうとしてるか
    var backSetButton :UIButton! //戻るボタン
    private var myWindow :UIWindow!
    var result :NSArray!
        //場所
    //最後にメニューに戻るボタン
    var backtomenu :UIButton!
    
    
    override func didMoveToView(view: SKView) {
        result = readData()
        var count = result.count
        var heightScroll = ceil(Double(count) / 2.0)
        Scroll = UIScrollView(frame: CGRect(x: 0, y: 0, width: 300, height: 300))
        Scroll.scrollEnabled = true
        Scroll.contentSize = CGSize(width:0 , height: 180*heightScroll)
        Scroll.indicatorStyle = UIScrollViewIndicatorStyle.Black
        Scroll.center = CGPoint(x: phoneSize.width*0.5, y: phoneSize.height*0.5)
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
        
        var dammy = UIImage(named: "nothing")
        //戻るボタン作成
        backSetButton = UIButton(frame: CGRectMake(0, 0, 100, 50))
        backSetButton.backgroundColor = UIColor.blueColor()
        backSetButton.addTarget(self, action: "GobackList:", forControlEvents: .TouchUpInside)
        backSetButton.setTitle("戻る", forState: .Normal)
        backSetButton.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        backSetButton.setTitle("戻る", forState: .Highlighted)
        backSetButton.setTitleColor(UIColor.blackColor(), forState: .Highlighted)
        backSetButton.layer.position = CGPoint(x: phoneSize.width*0.5, y: phoneSize.height*0.9)
        
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
        
        for i in 0...3 { //配置ボタンの用意
            SetButtons.append(UIButton(frame: CGRectMake(0,0,100,100)))
            SetButtons[i].backgroundColor = UIColor(red: 1.0, green: 0.5, blue: 0, alpha: 0.5)
            SetButtons[i].layer.masksToBounds = true
            SetButtons[i].layer.cornerRadius = 20.0
            SetButtons[i].addTarget(self, action: "SetFurniture:", forControlEvents: .TouchUpInside)
            SetButtons[i].setTitle(place[i], forState: .Normal)
            SetButtons[i].setTitleColor(UIColor.whiteColor(), forState: .Normal)
            SetButtons[i].setTitle(place[i], forState: .Highlighted)
            SetButtons[i].setTitleColor(UIColor.blackColor(), forState: .Highlighted)
            SetButtons[i].tag = i
            var x :Array<CGFloat> = [0.30,0.70]
            var y = Int(floor(CGFloat(i/2)))
            var WhereX :CGFloat = phoneSize.width * x[i%2]
            var WhereY :CGFloat = phoneSize.height * (x[y] + 0.1)//高さの間隔
            SetButtons[i].layer.position = CGPoint(x: WhereX,y: WhereY)
            
            var WhereA :CGFloat = phoneSize.width * x[i%2]
            var WhereB :CGFloat = phoneSize.height * (x[y] + 0.05)
            var HGH :CGFloat = 180
            setFurniture.append(UIImageView(image: dammy))
            setFurniture[i].frame = CGRectMake(150*WhereA, HGH*WhereB, 150, 150)
            setFurniture[i].center = CGPointMake(75,90)
        }
        
        var i = 0
        for data in result {
            var imagename = data.valueForKey("image")! as! String
            var name = data.valueForKey("name")! as! String
            
            //コイツが1単位
            var View = UIView()
            View.userInteractionEnabled = true
            var HGH :CGFloat = 180  //高さの間隔
            var WhereY = floor(CGFloat(i/2))
            var which :CGFloat = CGFloat(i%2)
            View.frame = CGRectMake(150*which, HGH*WhereY, 150, 150)
            
            //画像の用意
            Images.append(UIImage(named: imagename)!)
            imageViews.append(UIImageView(image: Images[i]))
            imageViews[i].frame = CGRectMake(0, 0, 120, 120)
            imageViews[i].center = CGPointMake(75,90)
            imageViews[i].tag = i
            imageViews[i].userInteractionEnabled = true
            
            //画像にアクション適用、表示
            let action = UITapGestureRecognizer(target:self, action: "TouchImage:")
            imageViews[i].addGestureRecognizer(action)
            View.addSubview(imageViews[i])
            
            //商品名
            myTextView = UITextView(frame: CGRectMake(0, 0, 130, 30))
            myTextView.userInteractionEnabled = true
            myTextView.backgroundColor = UIColor(red: 0.0, green: 0.8, blue: 0.8, alpha: 1.0)
            myTextView.text = name
            myTextView.font = UIFont.systemFontOfSize(CGFloat(15))
            myTextView.textColor = UIColor.whiteColor()
            myTextView.textAlignment = NSTextAlignment.Center
            myTextView.editable = false
            myTextView.center = CGPointMake(75,15)
            View.addSubview(myTextView)
            
            Scroll.addSubview(View)
            i++;
        }
        
        
        
    }
    
    internal func Goback(sender: UIButton){ //戻る
        myWindow.hidden = true
    }
    
    func TouchImage(recognizer: UIGestureRecognizer) {
        if let imageView = recognizer.view as? UIImageView {
            if(imageView.tag != 10000 && SetFlug == false){  //さあ家具を置こう
                //背景表示
                SetNumber = imageView.tag
                var back = UIImage(named: "back1")
                backView = UIImageView(frame: CGRectMake(0, 0, phoneSize.width, phoneSize.height))
                backView.image = back
                self.view!.addSubview(backView)
                
                //テキスト表示
                TextFurniture.text = "どこに\(names[SetNumber])を配置しますか？"
                self.view!.addSubview(TextFurniture)
                //戻るボタン配置
                backSetButton.hidden = false
                for (var i=0; i<4; i++){ //今置いてる家具と4つのボタンを表示
                    self.view!.addSubview(setFurniture[i])
                    self.view!.addSubview(SetButtons[i])
                    SetButtons[i].hidden = false
                }
                
                //家具をおくところというフラグをたてておく
                SetFlug = true
                self.view!.addSubview(backSetButton)
                backSetButton.hidden = false
            }
        }
    }
    internal func SetFurniture(sender: UIButton){ //家具を置く
        //sender.tag0,1,2,3 = "左上","右上","左下","右下"
        var SetPoint = CGPoint(x: sender.layer.position.x, y: sender.layer.position.y )
        setFurniture[sender.tag].image = imageViews[SetNumber].image
        setFurniture[sender.tag].center = SetPoint
        self.view!.addSubview(setFurniture[sender.tag])
        
        //テキスト変更
        TextFurniture.text = "配置しました！"
        //ボタンは消去
        for (var i=0; i<4; i++){ //配置ボタンを戻す
            SetButtons[i].hidden = true
        }
    }
    
    internal func GobackList(sender: UIButton){ //配置画面から家具一覧に戻る
        
        for (var i=0; i<4; i++){
            SetButtons[i].hidden = true
            setFurniture[i].removeFromSuperview()
        }
        backView.removeFromSuperview()
        TextFurniture.removeFromSuperview()
        backSetButton.hidden = true
        SetFlug = false
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
    }
    
    func readData() -> NSArray{
        let app = UIApplication.sharedApplication().delegate as! AppDelegate
        let managedObjectContext = app.managedObjectContext
        let entityDiscription = NSEntityDescription.entityForName("Furniture", inManagedObjectContext: managedObjectContext!)
        let fetchRequest = NSFetchRequest()
        fetchRequest.entity = entityDiscription;
        let predicate = NSPredicate(format: "haved == YES")
        fetchRequest.predicate = predicate
            
        var error: NSError? = nil;
        var results = managedObjectContext!.executeFetchRequest(fetchRequest, error: &error)
        return results!
    }
}