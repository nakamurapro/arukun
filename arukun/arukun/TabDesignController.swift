//
//  TabDesign.swift
//  arukun
//
//  Created by 坂本一 on 2015/12/11.
//  Copyright (c) 2015年 chikaratada. All rights reserved.
//

import UIKit

class TabDesignController: UITabBarController {
  
  override func viewDidLoad() {
    super.viewDidLoad()
    // Do any additional setup after loading the view, typically from a nib.
    
    // あらかじめ色とフォントファミリーを指定
    // アイコンの色変えたい
    UITabBar.appearance().tintColor = UIColor(red: 122/255, green: 176/255, blue: 30/255, alpha: 1.0)
    //UITabBar.appearance().
    // 背景色変えたい
    UITabBar.appearance().barTintColor = UIColor(red: 1, green: 238/255, blue: 244/255, alpha: 1.0)
    
    
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
}

