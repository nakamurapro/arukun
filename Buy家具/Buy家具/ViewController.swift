//
//  ViewController.swift
//  Buy家具
//
//  Created by 坂本一 on 2015/10/02.
//  Copyright (c) 2015年 Hajime Sakamoto. All rights reserved.
//

import UIKit
import SpriteKit

class ViewController: UIViewController {

    @IBOutlet var Scroll: UIScrollView!
    var phoneSize :CGSize = UIScreen.mainScreen().bounds.size
    private var myWindow :UIWindow!
    private var myButton :UIButton!
    private var myTextView :UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.

        var image = UIImage(named: "sanlio")!
        var imageHeight :CGFloat = image.size.height
        var imageWidth :CGFloat = image.size.width
        
        Scroll.contentSize = CGSize(width:0 , height: 3000)
        Scroll.indicatorStyle = UIScrollViewIndicatorStyle.Black
        
        for i in 0...9 {
            
            //コイツが1単位
            var View = UIView()
            View.userInteractionEnabled = true
            var HGH :CGFloat = 300
            var which :CGFloat = CGFloat(i)
            View.frame = CGRectMake(0, HGH*which, 300, 300)
            //まずは画像を左へ
            let imageView = UIImageView(image: image)
            imageView.center = CGPointMake(75,75)
            imageView.frame = CGRectMake(0, 0, imageWidth*0.3, imageHeight*0.3)
            View.addSubview(imageView)
            
            //説明文
            myTextView = UITextView(frame: CGRectMake(imageWidth*0.3, 0, 300-imageWidth*0.3, imageHeight*0.3))
            myTextView.userInteractionEnabled = true
            myTextView.backgroundColor = UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.3)
            myTextView.text = "商品名：きれいな棚\n種類：家具\nポイント：200"
            myTextView.font = UIFont.systemFontOfSize(CGFloat(13))
            myTextView.textColor = UIColor.whiteColor()
            myTextView.textAlignment = NSTextAlignment.Left
            myTextView.editable = false
            View.addSubview(myTextView)
            
            //最後にボタン配置
            myButton = UIButton(frame: CGRectMake(0,0,150,50))
            myButton.backgroundColor = UIColor.orangeColor()
            myButton.layer.masksToBounds = true
            myButton.layer.cornerRadius = 20.0
            myButton.addTarget(self, action: "clickButton:", forControlEvents: .TouchUpInside)
            myButton.setTitle("購入する", forState: .Normal)
            myButton.setTitleColor(UIColor.whiteColor(), forState: .Normal)
            myButton.setTitle("購入する", forState: .Highlighted)
            myButton.setTitleColor(UIColor.blackColor(), forState: .Highlighted)
            myButton.tag = 1
            
            myButton.layer.position = CGPoint(x: 150,y: 200 )
            View.addSubview(myButton)
            

            Scroll.addSubview(View)
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    internal func clickButton(sender: UIButton){
        var conform :UITextView = UITextView(frame: CGRectMake(0,50,300,100))
        if(sender.tag == 1){
            makeWindow()
            
            conform.userInteractionEnabled = true
            conform.text = "きれいな棚を購入しますか？"
            conform.font = UIFont.systemFontOfSize(CGFloat(20))
            conform.textColor = UIColor.blackColor()
            conform.textAlignment = NSTextAlignment.Center
            conform.editable = false
            myWindow.addSubview(conform)
            
            var BuyButton: UIButton = UIButton(frame: CGRectMake(0,0,150,50))
            BuyButton.backgroundColor = UIColor.redColor()
            BuyButton.layer.masksToBounds = true
            BuyButton.layer.cornerRadius = 20.0
            BuyButton.addTarget(self, action: "clickButton:", forControlEvents: .TouchUpInside)
            BuyButton.setTitle("はい", forState: .Normal)
            BuyButton.setTitleColor(UIColor.whiteColor(), forState: .Normal)
            BuyButton.setTitle("はい", forState: .Highlighted)
            BuyButton.setTitleColor(UIColor.blackColor(), forState: .Highlighted)
            BuyButton.tag = 2
            BuyButton.layer.position = CGPoint(x: 150.0,y: 150.0)
            myWindow.addSubview(BuyButton)
            
            var Cancel: UIButton = UIButton(frame: CGRectMake(0,0,150,50))
            Cancel.backgroundColor = UIColor.blueColor()
            Cancel.layer.masksToBounds = true
            Cancel.layer.cornerRadius = 20.0
            Cancel.addTarget(self, action: "clickButton:", forControlEvents: .TouchUpInside)
            Cancel.setTitle("キャンセル", forState: .Normal)
            Cancel.setTitleColor(UIColor.whiteColor(), forState: .Normal)
            Cancel.setTitle("キャンセル", forState: .Highlighted)
            Cancel.setTitleColor(UIColor.blackColor(), forState: .Highlighted)
            Cancel.tag = 3
            Cancel.layer.position = CGPoint(x: 150.0,y: 250.0)
            myWindow.addSubview(Cancel)

        }else if(sender.tag == 3){
            myWindow.hidden = true
        }else if(sender.tag == 2){
            myWindow.hidden = true
            makeWindow()
            conform.userInteractionEnabled = true
            conform.text = "きれいな棚を購入しました！\n残り100ポイントです。"
            conform.font = UIFont.systemFontOfSize(CGFloat(20))
            conform.textColor = UIColor.blackColor()
            conform.textAlignment = NSTextAlignment.Center
            conform.editable = false
            myWindow.addSubview(conform)
            
            var back: UIButton = UIButton(frame: CGRectMake(0,0,150,50))
            back.backgroundColor = UIColor.blueColor()
            back.layer.masksToBounds = true
            back.layer.cornerRadius = 20.0
            back.addTarget(self, action: "clickButton:", forControlEvents: .TouchUpInside)
            back.setTitle("戻る", forState: .Normal)
            back.setTitleColor(UIColor.whiteColor(), forState: .Normal)
            back.setTitle("戻る", forState: .Highlighted)
            back.setTitleColor(UIColor.blackColor(), forState: .Highlighted)
            back.tag = 3
            back.layer.position = CGPoint(x: 150.0,y: 250.0)
            myWindow.addSubview(back)

        }
        
        
    }
    
    func makeWindow(){
        myWindow = UIWindow(frame: CGRectMake(0, 0, 300, 300))
        myWindow.backgroundColor = UIColor.whiteColor()
        myWindow.layer.position = CGPointMake(self.view.frame.width/2, self.view.frame.height/2)
        myWindow.alpha = 1.0
        // myWindowをkeyWindowにする.
        myWindow.makeKeyWindow()
        self.view.addSubview(myWindow)
        self.myWindow.makeKeyAndVisible()
    }


}