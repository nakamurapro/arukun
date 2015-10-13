//
//  ViewController.swift
//  家具配置
//
//  Created by 坂本一 on 2015/10/06.
//  Copyright (c) 2015年 Hajime Sakamoto. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet var Scroll: UIScrollView!
    var phoneSize :CGSize = UIScreen.mainScreen().bounds.size //iPhoneサイズ取得
    var backButton :UIButton! //戻るボタン
    var SetButtons :Array<UIButton> = []
    private var myTextView :UITextView! //家具の名前
    private var TextFurniture :UITextView! //テキスト
    private var SetNumber :Int! //何番の家具を置こうとしてるか
    var Images :Array<UIImage> = []
    var imageView :Array<UIImageView> = [] //これは商品一覧
    var setFurniture :Array<UIImageView> = [] //これは置いてある家具
    var backView :UIImageView! //背景
    var SetFlug :Bool = false //家具置いてるところかどうか
    //家具
    var name :Array<String> = ["木のイス","しゃれたイス","こさねぇ","観葉植物"]
    //場所
    var place = ["左上","右上","左下","右下"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        Scroll.contentSize = CGSize(width:0 , height: 3000)
        Scroll.indicatorStyle = UIScrollViewIndicatorStyle.Black
        //これは配置のダミー用
        
        var dammy = UIImage(named: "nothing")
        //戻るボタン作成
        backButton = UIButton(frame: CGRectMake(0, 0, 100, 50))
        backButton.backgroundColor = UIColor.blueColor()
        backButton.addTarget(self, action: "Goback:", forControlEvents: .TouchUpInside)
        backButton.setTitle("戻る", forState: .Normal)
        backButton.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        backButton.setTitle("戻る", forState: .Highlighted)
        backButton.setTitleColor(UIColor.blackColor(), forState: .Highlighted)
        backButton.layer.position = CGPoint(x: phoneSize.width*0.5, y: phoneSize.height-25)
        
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
            imageView.append(UIImageView(image: Images[i]))
            imageView[i].frame = CGRectMake(0, 0, 120, 120)
            imageView[i].center = CGPointMake(75,90)
            imageView[i].tag = i
            imageView[i].userInteractionEnabled = true
            
            //画像にアクション適用、表示
            let action = UITapGestureRecognizer(target:self, action: "TouchImage:")
            imageView[i].addGestureRecognizer(action)
            View.addSubview(imageView[i])
            
            //商品名
            myTextView = UITextView(frame: CGRectMake(0, 0, 130, 30))
            myTextView.userInteractionEnabled = true
            myTextView.backgroundColor = UIColor(red: 0.0, green: 0.8, blue: 0.8, alpha: 1.0)
            myTextView.text = name[i]
            myTextView.font = UIFont.systemFontOfSize(CGFloat(15))
            myTextView.textColor = UIColor.whiteColor()
            myTextView.textAlignment = NSTextAlignment.Center
            myTextView.editable = false
            myTextView.center = CGPointMake(75,15)
            View.addSubview(myTextView)
            
            Scroll.addSubview(View)
            
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
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func TouchImage(recognizer: UIGestureRecognizer) {
        if let imageView = recognizer.view as? UIImageView {
            if(imageView.tag != 10000 && SetFlug == false){  //さあ家具を置こう
                //背景表示
                SetNumber = imageView.tag
                var back = UIImage(named: "main")
                backView = UIImageView(frame: CGRectMake(0, 0, phoneSize.width, phoneSize.height))
                backView.image = back
                self.view.addSubview(backView)
                
                //テキスト表示
                TextFurniture.text = "どこに\(name[SetNumber])を配置しますか？"
                self.view.addSubview(TextFurniture)
                //戻るボタン配置
                backButton.hidden = false
                for (var i=0; i<4; i++){ //今置いてる家具と4つのボタンを表示
                    self.view.addSubview(setFurniture[i])
                    self.view.addSubview(SetButtons[i])
                    SetButtons[i].hidden = false
                }
                
                //家具をおくところというフラグをたてておく
                SetFlug = true
                self.view.addSubview(backButton)
            }
        }
    }
    internal func SetFurniture(sender: UIButton){ //家具を置く
        //sender.tag0,1,2,3 = "左上","右上","左下","右下"
        var SetPoint = CGPoint(x: sender.layer.position.x, y: sender.layer.position.y )
        setFurniture[sender.tag].image = imageView[SetNumber].image
        setFurniture[sender.tag].center = SetPoint
        self.view.addSubview(setFurniture[sender.tag])
        
        //テキスト変更
        TextFurniture.text = "配置しました！"
        //ボタンは消去
        for (var i=0; i<4; i++){ //配置ボタンを戻す
            SetButtons[i].hidden = true
        }
    }
    
    internal func Goback(sender: UIButton){ //配置画面から家具一覧に戻る
        
        for (var i=0; i<4; i++){
            SetButtons[i].hidden = true
            setFurniture[i].removeFromSuperview()
        }
        backView.removeFromSuperview()
        TextFurniture.removeFromSuperview()
        backButton.hidden = true
        SetFlug = false
    }

}

