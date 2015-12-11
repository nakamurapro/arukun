//
//  ViewController2.swift
//  kore test 2
//
//  Created by kenseikamii on 2015/10/03.
//  Copyright © 2015年 kenseikamii. All rights reserved.
//
import Foundation
import SpriteKit
import UIKit
import AVFoundation

class ViewController2: UIViewController {


  @IBOutlet var label: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    //送ったやつ受信ってことか！！！！！
    var selectedImg: UIImage?
    var selectedlbl: String?
    @IBOutlet weak var back_button: UIButton!
  var audioPlayer :AVAudioPlayer?

  
    override func viewDidLoad() {
        super.viewDidLoad()
        if let path = NSBundle.mainBundle().pathForResource("scroll_up", ofType: "mp3") {
        audioPlayer = AVAudioPlayer(contentsOfURL: NSURL(fileURLWithPath: path), fileTypeHint: "mp3", error: nil)
        if let sound = audioPlayer {
          sound.prepareToPlay()
          sound.play()
        }
        }
        back_button.layer.cornerRadius = 10
//        self.imageView.layer.cornerRadius = 30
//        self.imageView.layer.masksToBounds = true
        label.text = selectedlbl!
        label.textColor = UIColor.blackColor()
        
        //２画面目拡大画像
        imageView.image = selectedImg
//        imageView.frame = CGRect(
        
        // 画像のアスペクト比を維持しUIImageViewサイズに収まるように表示
        imageView.contentMode = UIViewContentMode.ScaleAspectFit
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
  
  override func viewWillDisappear(animated: Bool) {
    if let path = NSBundle.mainBundle().pathForResource("scroll_down", ofType: "mp3") {
      audioPlayer = AVAudioPlayer(contentsOfURL: NSURL(fileURLWithPath: path), fileTypeHint: "mp3", error: nil)
      if let sound = audioPlayer {
        sound.prepareToPlay()
        sound.play()
      }
    }
  }

}
