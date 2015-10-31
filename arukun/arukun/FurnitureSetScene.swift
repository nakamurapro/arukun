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
    var backButton :UIButton!
    var backView :UIImageView! //背景
    var Images :Array<UIImage> = []
    var dammy :UIImage! //何も置いてない時

    var places = ["左上","右上","左下","右下"]
    var OnePlace :Int!  //場所を1つ。家具をどかす時に使う。
    var SetFlug :Bool = false //家具置いてるところかどうか
    private var myWindow :UIWindow!
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
    var back :Int!
    
    override func didMoveToView(view: SKView) {
        Furnitures = readData()   //家具情報読み込み
        var count = 0
        for data in Furnitures{   //持ってるやつはどれ？
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
        
        //これはダミー用
        dammy = UIImage(named: "nothing")
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
            SetButtons[i].layer.cornerRadius = 20.0
            SetButtons[i].addTarget(self, action: "SetFurniture:", forControlEvents: .TouchUpInside)
            SetButtons[i].setTitle(places[i], forState: .Normal)
            SetButtons[i].setTitleColor(UIColor.whiteColor(), forState: .Normal)
            SetButtons[i].setTitle(places[i], forState: .Highlighted)
            SetButtons[i].setTitleColor(UIColor.blackColor(), forState: .Highlighted)
            SetButtons[i].tag = i
            var x :Array<CGFloat> = [0.30,0.70]
            var y = Int(floor(CGFloat(i/2)))
            var WhereX :CGFloat = phoneSize.width * x[i%2]
            var WhereY :CGFloat = phoneSize.height * (x[y] + 0.1)//高さの間隔
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
            var WhereY = floor(CGFloat(i/2))
            var which :CGFloat = CGFloat(i%2)
            View.frame = CGRectMake(150*which, HGH*WhereY, 150, 150)
            
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
            k++
            i++
        }
        
        
        removeButton = UIButton(frame: CGRectMake(0, 0, 100, 50))
        removeButton.backgroundColor = UIColor.redColor()
        removeButton.addTarget(self, action: "removeFurniture:", forControlEvents: .TouchUpInside)
        removeButton.setTitle("取り除く", forState: .Normal)
        removeButton.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        removeButton.setTitle("取り除く", forState: .Highlighted)
        removeButton.setTitleColor(UIColor.blackColor(), forState: .Highlighted)
        removeButton.layer.position = CGPoint(x: 150, y: 200)
        
        //キャンセルボタン作成
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


    }

    func TouchImage(recognizer: UIGestureRecognizer) {
        if let imageView = recognizer.view as? UIImageView {
            setData(Furnitures[imageView.tag])
            id = imageView.tag
            //まず最初に置いてあるかどうかを確認しないといけないんですよね…
            var i = 0
            println(ids)
            for data in ids{
                if(id == data){
                    SetFlug = true
                    OnePlace = i
                    MakeWindow()
                    break
                }
                i++
            }
            if(imageView.tag != 10000 && SetFlug == false){  //さあ家具を置こう
                //背景表示
                var backData = Furnitures[back].valueForKey("image") as! String
                var backImage = UIImage(named: backData)
                backView = UIImageView(frame: CGRectMake(0, 0, phoneSize.width, phoneSize.height))
                backView.image = backImage
                self.view!.addSubview(backView)
                
                //テキスト表示
                TextFurniture.text = "どこに\(Furniturename)を配置しますか？"
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
        }
    }
    internal func SetFurniture(sender: UIButton){ //家具を置く
        //sender.tag0,1,2,3 = "左上","右上","左下","右下"
        //idにはもう家具のID入ってます
        //じゃあまず表面上だけ変えよう
        OnePlace = sender.tag //これが場所
        ids[OnePlace] = id
        var SetPoint = CGPoint(x: sender.layer.position.x, y: sender.layer.position.y )
        RoomFurniture[OnePlace].image = UIImage(named: imageName)
        RoomFurniture[OnePlace].center = SetPoint
        self.view!.addSubview(RoomFurniture[OnePlace])
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
    
        for (var i=0; i<4; i++){ //配置ボタンを消す
            SetButtons[i].hidden = true
        }
    }
    
    internal func GobackList(sender: UIButton){ //配置画面から家具一覧に戻る
        for (var i=0; i<4; i++){
            SetButtons[i].hidden = true
            RoomFurniture[i].removeFromSuperview()
        }
        backView.removeFromSuperview()
        TextFurniture.removeFromSuperview()
        backSetButton.hidden = true
        backtomenu.hidden = false
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
        backtomenu.hidden = true
        myWindow = UIWindow(frame: CGRectMake(0, 0, 300, 300))
        myWindow.backgroundColor = UIColor.whiteColor()
        myWindow.layer.position = CGPointMake(self.view!.frame.width/2, self.view!.frame.height/2)
        myWindow.alpha = 1.0
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
        removeButton.removeFromSuperview()
        cancelButton.removeFromSuperview()
        myWindow.addSubview(backButton)
        WindowText.text = "\(Furniturename)を取り除きました！"
        RoomFurniture[OnePlace].image = dammy
        ids[OnePlace] = -1

        var fur = "fur\(OnePlace+1)"
        println(fur)
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
        myWindow.hidden = true
        backtomenu.hidden = false
        SetFlug = false
    }
}