//
//  ViewController2.swift
//  kore test 2
//
//  Created by kenseikamii on 2015/10/03.
//  Copyright © 2015年 kenseikamii. All rights reserved.
//
import Foundation

import UIKit

class ViewController2: UIViewController {

    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    //送ったやつ受信ってことか！！！！！
    var selectedImg: UIImage?
    var selectedlbl: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        label.text = selectedlbl
        label.textColor = UIColor.blackColor()
        
        //２画面目拡大画像
        imageView.image = selectedImg
        
        // 画像のアスペクト比を維持しUIImageViewサイズに収まるように表示
        imageView.contentMode = UIViewContentMode.ScaleAspectFit
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
