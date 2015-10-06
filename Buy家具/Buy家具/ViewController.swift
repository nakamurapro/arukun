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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.

        var image = UIImage(named: "sanlio")!
        var imageHeight :CGFloat = image.size.height
        var imageWidth :CGFloat = image.size.width
        
        Scroll.contentSize = CGSize(width:0 , height: image.size.height*10.0)
        Scroll.indicatorStyle = UIScrollViewIndicatorStyle.Black
        
        for i in 0...10 {
            
            //コイツが1単位
            var View = UIView()
            var HGH = image.size.height * 0.5
            var which :CGFloat = CGFloat(i)
            View.frame = CGRectMake(0, HGH*which, 150, 300)
            //まずは画像を左へ
            let imageView = UIImageView(image: image)
            imageView.center = CGPointMake(75,75)
            imageView.frame = CGRectMake(0, 0, imageWidth*0.3, imageHeight*0.3)
            var frameImage = UIView()
            frameImage.frame = CGRectMake(0, 0, 150, 150)
            frameImage.addSubview(imageView)
            View.addSubview(frameImage)
            
            //ボタン配置
            var frameText = UIView()
            frameText.frame = CGRectMake(0, 0, 150, 300-imageHeight*0.3)
            let myLabel: UILabel = UILabel(frame: CGRectMake(0,0,200,50))
            myLabel.backgroundColor = UIColor.orangeColor()
            myLabel.layer.masksToBounds = true
            myLabel.layer.cornerRadius = 20.0
            myLabel.text = "購入する"
            myLabel.textColor = UIColor.whiteColor()
            myLabel.shadowColor = UIColor.grayColor()
            myLabel.textAlignment = NSTextAlignment.Center
            myLabel.layer.position = CGPoint(x: phoneSize.width*0.5,y: 200)
            self.view.backgroundColor = UIColor.cyanColor()
            frameText.addSubview(myLabel)
            View.addSubview(frameText)
            
            Scroll.addSubview(View)
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}