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
    var phoneSize :CGSize = UIScreen.mainScreen().bounds.size
    private var myWindow :UIWindow!
    private var myButton :UIButton!
    private var myTextView :UITextView!
    
    var kind :Array<String> = ["家具","背景"]
    var name :Array<String> = ["きれいな棚","花の壁紙"]
    var place = ["左上","右上","左下","右下"]
    
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
            myTextView.text = "商品名：\(name[i%2])\n種類：\(kind[i%2])"
            myTextView.font = UIFont.systemFontOfSize(CGFloat(15))
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
            myButton.setTitle("配置する", forState: .Normal)
            myButton.setTitleColor(UIColor.whiteColor(), forState: .Normal)
            myButton.setTitle("配置する", forState: .Highlighted)
            myButton.setTitleColor(UIColor.blackColor(), forState: .Highlighted)
            myButton.tag = i%2
            
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
        var conform :UITextView = UITextView(frame: CGRectMake(0,50,300,80))
        if(sender.tag == 0){
            makeWindow()
            
            conform.userInteractionEnabled = true
            conform.text = "\(name[sender.tag])をどこに配置しますか？"
            conform.font = UIFont.systemFontOfSize(CGFloat(20))
            conform.textColor = UIColor.blackColor()
            conform.textAlignment = NSTextAlignment.Center
            conform.editable = false
            myWindow.addSubview(conform)
            
            for (var i=0; i<4; i++){
                var BuyButton: UIButton = UIButton(frame: CGRectMake(0,0,50,50))
                BuyButton.backgroundColor = UIColor.orangeColor()
                BuyButton.layer.masksToBounds = true
                BuyButton.layer.cornerRadius = 20.0
                BuyButton.addTarget(self, action: "clickButton:", forControlEvents: .TouchUpInside)
                BuyButton.setTitle(place[i], forState: .Normal)
                BuyButton.setTitleColor(UIColor.whiteColor(), forState: .Normal)
                BuyButton.setTitle(place[i], forState: .Highlighted)
                BuyButton.setTitleColor(UIColor.blackColor(), forState: .Highlighted)
                BuyButton.tag = 2
                BuyButton.layer.position = CGPoint(x: i*60+50,y: 150)
                myWindow.addSubview(BuyButton)
            }
            
            var Cancel: UIButton = UIButton(frame: CGRectMake(0,0,150,50))
            Cancel.backgroundColor = UIColor.blueColor()
            Cancel.layer.masksToBounds = true
            Cancel.layer.cornerRadius = 20.0
            Cancel.addTarget(self, action: "clickButton:", forControlEvents: .TouchUpInside)
            Cancel.setTitle("キャンセル", forState: .Normal)
            Cancel.setTitleColor(UIColor.whiteColor(), forState: .Normal)
            Cancel.setTitle("キャンセル", forState: .Highlighted)
            Cancel.setTitleColor(UIColor.blackColor(), forState: .Highlighted)
            Cancel.tag = 3000
            Cancel.layer.position = CGPoint(x: 150.0,y: 250.0)
            myWindow.addSubview(Cancel)
        }else if(sender.tag == 1){
            makeWindow()
            
            conform.userInteractionEnabled = true
            conform.text = "\(name[sender.tag])を壁紙にしますか？"
            conform.font = UIFont.systemFontOfSize(CGFloat(20))
            conform.textColor = UIColor.blackColor()
            conform.textAlignment = NSTextAlignment.Center
            conform.editable = false
            myWindow.addSubview(conform)
            
            var YesButton: UIButton = UIButton(frame: CGRectMake(0,0,150,50))
            YesButton.backgroundColor = UIColor.redColor()
            YesButton.layer.masksToBounds = true
            YesButton.layer.cornerRadius = 20.0
            YesButton.addTarget(self, action: "clickButton:", forControlEvents: .TouchUpInside)
            YesButton.setTitle("はい", forState: .Normal)
            YesButton.setTitleColor(UIColor.whiteColor(), forState: .Normal)
            YesButton.setTitle("はい", forState: .Highlighted)
            YesButton.setTitleColor(UIColor.blackColor(), forState: .Highlighted)
            YesButton.tag = 2
            YesButton.layer.position = CGPoint(x: 150.0,y: 150.0)
            myWindow.addSubview(YesButton)
            
            var Cancel: UIButton = UIButton(frame: CGRectMake(0,0,150,50))
            Cancel.backgroundColor = UIColor.blueColor()
            Cancel.layer.masksToBounds = true
            Cancel.layer.cornerRadius = 20.0
            Cancel.addTarget(self, action: "clickButton:", forControlEvents: .TouchUpInside)
            Cancel.setTitle("キャンセル", forState: .Normal)
            Cancel.setTitleColor(UIColor.whiteColor(), forState: .Normal)
            Cancel.setTitle("キャンセル", forState: .Highlighted)
            Cancel.setTitleColor(UIColor.blackColor(), forState: .Highlighted)
            Cancel.tag = 3000
            Cancel.layer.position = CGPoint(x: 150.0,y: 250.0)
            myWindow.addSubview(Cancel)
        }else if(sender.tag == 3000){
            myWindow.hidden = true
        }else if(sender.tag == 2){
            myWindow.hidden = true
            makeWindow()
            
            conform.userInteractionEnabled = true
            conform.text = "配置しました！"
            conform.font = UIFont.systemFontOfSize(CGFloat(20))
            conform.textColor = UIColor.blackColor()
            conform.textAlignment = NSTextAlignment.Center
            conform.editable = false
            myWindow.addSubview(conform)
            
            var Cancel: UIButton = UIButton(frame: CGRectMake(0,0,150,50))
            Cancel.backgroundColor = UIColor.blueColor()
            Cancel.layer.masksToBounds = true
            Cancel.layer.cornerRadius = 20.0
            Cancel.addTarget(self, action: "clickButton:", forControlEvents: .TouchUpInside)
            Cancel.setTitle("戻る", forState: .Normal)
            Cancel.setTitleColor(UIColor.whiteColor(), forState: .Normal)
            Cancel.setTitle("戻る", forState: .Highlighted)
            Cancel.setTitleColor(UIColor.blackColor(), forState: .Highlighted)
            Cancel.tag = 3000
            Cancel.layer.position = CGPoint(x: 150.0,y: 250.0)
            myWindow.addSubview(Cancel)
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

