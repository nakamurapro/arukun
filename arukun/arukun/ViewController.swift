//
//  ViewController.swift
//  kore test
//
//  Created by kenseikamii on 2015/09/24.
//  Copyright (c) 2015年 kenseikamii. All rights reserved.
//
import UIKit


class ViewController: UIViewController,UICollectionViewDataSource,UICollectionViewDelegate {
    
    @IBOutlet weak var scrollView :UIScrollView!
    @IBOutlet weak var image3: UIImageView!
    
    var selectedImage: UIImage?
    var selectedLabel: String?
    var str:String?
    
    let imgArray: NSArray = ["photo1.png","photo2.png","photo3.png"]
    let nameArray : NSArray = ["あるくん","あるちゃん","あるお"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //背景
        let backgroundImage = UIImage(named:"con.jpg")!
        self.view.backgroundColor = UIColor(patternImage: backgroundImage)
        image3.image = UIImage(named:"kanban.png")
    
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    // MARK: - UICollectionViewDelegate Protocol
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell:CustomCell = collectionView.dequeueReusableCellWithReuseIdentifier("cell", forIndexPath: indexPath) as!CustomCell
        
        //cellの中身の画像処理
        cell.image.image = UIImage(named:"photo\(indexPath.row+1).png")
        cell.image2.image = UIImage(named:"husen.png")
        cell.label.text = nameArray[indexPath.row] as? String
        
        return cell
    }
    
    
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath:NSIndexPath) {
        // SubViewController へ遷移するために Segue を呼び出す
        selectedImage = UIImage(named:"\(imgArray[indexPath.row])")

        //テキストデータ読み込み
        let path = NSBundle.mainBundle().pathForResource("json2", ofType: "txt")
        let jsondata = NSData(contentsOfFile: path!)
        
        let jsonArray = NSJSONSerialization.JSONObjectWithData(jsondata!, options:NSJSONReadingOptions.MutableContainers, error: NSErrorPointer()) as! NSArray
       
        //テキストデータの受け渡し
        str = jsonArray[indexPath.row] as? String
        
        for dat in jsonArray{
            print("\(dat)")
        }
        performSegueWithIdentifier("ViewController2",sender: nil)
    }
    
    // Segue 準備
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        if (segue.identifier == "ViewController2") {
            let subVC: ViewController2 = (segue.destinationViewController as? ViewController2)!
            
            // SubViewControllerに選択された画像・文字を設定する
            subVC.selectedImg = selectedImage
            subVC.selectedlbl = str

        }
    }
    
    //画像枚数分カウント
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imgArray.count
    }
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    @IBAction func returnMenu(segue: UIStoryboardSegue){
    }

}
