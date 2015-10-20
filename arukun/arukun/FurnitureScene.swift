//
//  ViewController.swift
//  Buy家具
//
//  Created by 坂本一 on 2015/10/02.
//  Copyright (c) 2015年 Hajime Sakamoto. All rights reserved.
//

import Foundation
import UIKit
import SpriteKit

class FurnitureScene: SKScene {
    var Scroll: Array<UIScrollView> = [] //0は家具購入、1は家具配置に使います
    //まず家具購入に必要な物
    var phoneSize :CGSize = UIScreen.mainScreen().bounds.size //画面サイズ
    private var myWindow :UIWindow!
    var BuyButton :UIButton!
    var backButton :UIButton! //戻るボタン
    var cancelButton :UIButton! //キャンセルボタン
    var SetButtons :Array<UIButton> = []
    private var myTextView :UITextView! //家具の名前
    private var Text :UITextView! //テキスト
    private var PointView :UITextView! //所持ポイント表示
    private var price :UITextView! //値段
    var imageView :UIImageView! //これは商品
    var boughtImage = UIImage(named: "bought") //購入済み
    var PlayerPoint :Int = 1000   //お金
    var BuyFurniture :Dictionary<String,String>! //何を買おうとしてるのか
    var selected: Int!  //選んだ番号
    var bought :Array<UIImageView> = [] //買ったのどうなの
    
    var BuyFurnitureView :UIView!
    var FurnitureBuyButton :UIButton!
    //続いて家具配置に必要なもの
    private var TextFurniture :UITextView! //テキスト
    private var imageViews :Array<UIImageView> = [] //これは商品一覧
    var setFurniture :Array<UIImageView> = [] //これは置いてある家具
    var backView :UIImageView! //背景
    var Images :Array<UIImage> = []
    var place = ["左上","右上","左下","右下"]
    var names :Array<String> = ["木のイス","しゃれたイス","こさねぇ","観葉植物"]
    var SetFlug :Bool = false //家具置いてるところかどうか
    private var SetNumber :Int! //何番の家具を置こうとしてるか
    var backSetButton :UIButton! //戻るボタン
    var data = [
        ["name" :"木のイス", "point" :"100", "have" :"false", "pic" :"kagu1"],
        ["name" :"しゃれたイス", "point" :"150", "have" :"false", "pic" :"kagu2"],
        ["name" :"こさねぇ", "point" :"100" ,"have" :"true", "pic" :"kagu3"],
        ["name" :"観葉植物", "point" :"80" ,"have" :"false", "pic" :"kagu4"],
        ["name" :"素朴な背景", "point" : "700", "have" :"false", "pic" :"back1"]
    ]    //場所

    var SetFurnitureView :UIView!
    var FurnitureSetButton :UIButton!

    
    //最後にメニューに戻るボタン
    var backtomenu :UIButton!
    
    
    override func didMoveToView(view: SKView) {
        //まずScrollViewを2つ作るよ
        var heightScroll = ceil(Double(data.count) / 2.0)
        for i in 0...1{
            Scroll.append(UIScrollView())
            Scroll[i].scrollEnabled = true
            Scroll[i].frame = CGRect(x: 0, y: 0, width: 300, height: 300)
            Scroll[i].contentSize = CGSize(width:0 , height: 180*heightScroll)
            Scroll[i].indicatorStyle = UIScrollViewIndicatorStyle.Black
            Scroll[i].center = CGPoint(x: phoneSize.width*0.5, y: phoneSize.height*0.5)
        }
        //押したら家具購入画面が出てくる
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
        
        //メニューに戻るボタン
        backtomenu = UIButton(frame: CGRectMake(0, 0, 100, 50))
        backtomenu.backgroundColor = UIColor.blueColor()
        backtomenu.addTarget(self, action: "backtomenu:", forControlEvents: .TouchUpInside)
        backtomenu.setTitle("戻る", forState: .Normal)
        backtomenu.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        backtomenu.setTitle("戻る", forState: .Highlighted)
        backtomenu.setTitleColor(UIColor.blackColor(), forState: .Highlighted)
        backtomenu.layer.position = CGPoint(x: 60, y: phoneSize.height*0.9-10)
        
        makeBuyFurnitureView() //家具作成画面を作る
        makeSetFurnitureView() //家具配置画面を作る
    }
    
    func makeBuyFurnitureView(){
        BuyFurnitureView = UIView()
        BuyFurnitureView.frame = CGRect(x: 0, y: 0, width: phoneSize.width, height: phoneSize.height)
        
        BuyFurnitureView.addSubview(Scroll[0])
        
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
        Text.backgroundColor = UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.0)
        Text.text = ""
        Text.font = UIFont.systemFontOfSize(CGFloat(20))
        Text.textColor = UIColor.blackColor()
        Text.textAlignment = NSTextAlignment.Left
        Text.editable = false
        Text.center = CGPointMake(self.view!.frame.width/2,100)
        
        PointView = UITextView(frame: CGRectMake(0, 0, 300, 100))
        PointView.userInteractionEnabled = true
        PointView.backgroundColor = UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.0)
        PointView.text = "所持ポイント：\(toString(PlayerPoint))P"
        PointView.font = UIFont.systemFontOfSize(CGFloat(20))
        PointView.textColor = UIColor.blackColor()
        PointView.textAlignment = NSTextAlignment.Left
        PointView.editable = false
        PointView.center = CGPointMake(self.view!.frame.width*0.5,self.view!.frame.height*0.85)
        BuyFurnitureView.addSubview(PointView)
        
        for i in 0...4 { //メイン画面の用意
            var output = self.data[i]
            //コイツが1単位
            var View = UIView()
            View.userInteractionEnabled = true
            var HGH :CGFloat = 180  //高さの間隔
            var WhereY = floor(CGFloat(i/2)) //何行目？
            var which :CGFloat = CGFloat(i%2)
            View.frame = CGRectMake(150*which, HGH*WhereY, 150, 150)
            
            //画像の用意
            var Image = UIImage(named: output["pic"]!)
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
            myTextView.text = output["name"]!
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
            price.text = output["point"]!
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
            if(output["have"]! == "false"){
                bought[i].hidden = true
            }
            
            Scroll[0].addSubview(View)
            
        }

    }//完成です
    
    func makeSetFurnitureView(){ //家具配置画面作成
        SetFurnitureView = UIView()
        SetFurnitureView.frame = CGRect(x: 0, y: 0, width: phoneSize.width, height: phoneSize.height)
        SetFurnitureView.addSubview(Scroll[1])

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
        }
        for i in 0...3 { //メイン画面の用意
            
            //コイツが1単位
            var View = UIView()
            View.userInteractionEnabled = true
            var HGH :CGFloat = 180  //高さの間隔
            var WhereY = floor(CGFloat(i/2))
            var which :CGFloat = CGFloat(i%2)
            View.frame = CGRectMake(150*which, HGH*WhereY, 150, 150)
            
            //画像の用意
            Images.append(UIImage(named: "kagu\(i+1)")!)
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
            myTextView.text = names[i]
            myTextView.font = UIFont.systemFontOfSize(CGFloat(15))
            myTextView.textColor = UIColor.whiteColor()
            myTextView.textAlignment = NSTextAlignment.Center
            myTextView.editable = false
            myTextView.center = CGPointMake(75,15)
            View.addSubview(myTextView)
            
            Scroll[1].addSubview(View)
            
            //部屋配置確認用
            var x :Array<CGFloat> = [0.30,0.70]
            var y = Int(floor(CGFloat(i/2)))
            var WhereA :CGFloat = phoneSize.width * x[i%2]
            var WhereB :CGFloat = phoneSize.height * (x[y] + 0.05)
            setFurniture.append(UIImageView(image: dammy))
            setFurniture[i].frame = CGRectMake(150*WhereA, HGH*WhereB, 150, 150)
            setFurniture[i].center = CGPointMake(75,90)
            //あとで表示する
            
        }

    }
    internal func Goback(sender: UIButton){ //戻る
        myWindow.hidden = true
    }
    
    internal func BuyFurniture(sender: UIButton){ //買う
        PlayerPoint = PlayerPoint - BuyFurniture["point"]!.toInt()!
        BuyButton.removeFromSuperview()
        myWindow.addSubview(backButton)
        Text.text = "購入しました！"
        BuyFurniture.updateValue("true", forKey: "have")
        data[selected] = BuyFurniture
        bought[selected].hidden = false
        PointView.text = "所持ポイント：\(toString(PlayerPoint))P"
    }
    
    
    func makeWindow(recognizer: UIGestureRecognizer){ //ウィンドウ作成
        if let imageView = recognizer.view as? UIImageView {
            selected = imageView.tag
            BuyFurniture = data[selected]
            var Flg = ( BuyFurniture["have"]! )
            if(Flg == "false"){
                //まずはウィンドウ作ろう
                myWindow = UIWindow(frame: CGRectMake(0, 0, 300, 300))
                myWindow.backgroundColor = UIColor.whiteColor()
                myWindow.layer.position = CGPointMake(self.view!.frame.width/2, self.view!.frame.height/2)
                myWindow.alpha = 1.0
                // myWindowをkeyWindowにする.
                myWindow.makeKeyWindow()
                BuyFurnitureView.addSubview(myWindow)
                self.myWindow.makeKeyAndVisible()
                
                var FurniturePoint = BuyFurniture["point"]!.toInt()!
                if(PlayerPoint >= FurniturePoint){ //足りる！
                    var name = BuyFurniture["name"]!
                    Text.text = "\(name)を購入しますか？\n必要ポイント：\(FurniturePoint)P\n所持ポイント：\(PlayerPoint)P"
                    myWindow.addSubview(Text)
                    myWindow.addSubview(BuyButton)
                    myWindow.addSubview(cancelButton)
                }else { //足りない！
                    Text.text = "ポイントが足りません！\n必要ポイント：\(FurniturePoint)P\n所持ポイント：\(PlayerPoint)P"
                    myWindow.addSubview(Text)
                    myWindow.addSubview(backButton)
                }
            }
        }
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
                backButton.hidden = false
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
    
    func FurnitureBuy(sender: UIButton){
        FurnitureBuyButton.hidden = true
        FurnitureSetButton.hidden = true
        self.view!.addSubview(BuyFurnitureView)
        self.view!.addSubview(backtomenu)
        backtomenu.hidden = false
    }
    
    func FurnitureSet(sender: UIButton){
        FurnitureBuyButton.hidden = true
        FurnitureSetButton.hidden = true
        self.view!.addSubview(SetFurnitureView)
        self.view!.addSubview(backtomenu)
        backtomenu.hidden = false

    }
    
    func backtomenu(sender: UIButton){
        FurnitureBuyButton.hidden = false
        FurnitureSetButton.hidden = false
        backtomenu.hidden = true
        BuyFurnitureView.removeFromSuperview()
        SetFurnitureView.removeFromSuperview()
    }
}