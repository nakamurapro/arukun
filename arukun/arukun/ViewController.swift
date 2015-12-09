//
//  ViewController.swift
//  kore test
//
//  Created by kenseikamii on 2015/09/24.
//  Copyright (c) 2015年 kenseikamii. All rights reserved.
//
import UIKit
import CoreData
import AVFoundation

class ViewController: UIViewController,UICollectionViewDataSource,UICollectionViewDelegate {
    
    @IBOutlet weak var scrollView :UIScrollView!
    @IBOutlet weak var image3: UIImageView!
    
    var selectedImage: UIImage?
    var selectedLabel: String?
    var str:String?
    var Pets :NSArray! //ペットのデータがここ
    var Pictures :NSArray! //写真データがここ
    var CharaDatas :NSArray! //キャラデータがここ
    var audioPlayer :AVAudioPlayer?

  
    override func viewDidLoad() {
        super.viewDidLoad()
      
        Pets = readPets()
        if(Pets.count == 0){
            initPetMasters()
            Pets = readPets()
        }
        
        Pictures = readPictures()
        if(Pictures.count == 0){
            initPictureMasters()
            Pictures = readPictures()
        }
        
        CharaDatas = readCharaData()
        if(CharaDatas.count == 0){
            initCharaMasters()
            CharaDatas = readCharaData()
        }
      
        //背景
        let backgroundImage = UIImage(named:"con.jpg")!
        self.view.backgroundColor = UIColor(patternImage: backgroundImage)
        image3.image = UIImage(named:"kanban3")
    
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    // MARK: - UICollectionViewDelegate Protocol
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell:CustomCell = collectionView.dequeueReusableCellWithReuseIdentifier("cell", forIndexPath: indexPath) as!CustomCell
        
        //cellの中身の画像処理
        var photo = UIImage(named: (takePhoto(indexPath.row)) )
        var height = photo!.size.height
        cell.image.image = photo
        cell.image.layer.frame = CGRect(x: 0, y: 0, width: 80, height: 80*(height/480))
        cell.image.layer.position = CGPoint(x: cell.image2.center.x, y: cell.image2.center.y)
        cell.image2.image = UIImage(named:"husen.png")
        cell.label.text = takePhoto(indexPath.row) == "secret" ?  "？？？" : CharaDatas[indexPath.row].valueForKey("name")! as? String

        return cell
    }
    
    
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath:NSIndexPath) {
        // SubViewController へ遷移するために Segue を呼び出す
        var photo = takePhoto(indexPath.row)
        selectedImage = UIImage(named: photo)
        

        //テキストデータの受け渡し
        var text = CharaDatas[indexPath.row].valueForKey("text") as? String
        var rgb = CharaDatas[indexPath.row].valueForKey("rgb") as? String
        var name = CharaDatas[indexPath.row].valueForKey("name") as? String
        str = photo == "secret" ? "？？？ （属性：？？？）\n\n？？？？？" : "\(name!) (属性:\(rgb!))\n\n\(text!)"
        performSegueWithIdentifier("ViewController2",sender: nil)
    }
    
    // Segue 準備
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        if (segue.identifier == "ViewController2") {
            let subVC: ViewController2 = (segue.destinationViewController as? ViewController2)!
            
            // SubViewControllerに選択された画像・文字を設定する
            // ここで色々送ってるのね！！！わかったわ！！！！！！！
            subVC.selectedImg = selectedImage
            subVC.selectedlbl = str
          
            if let path = NSBundle.mainBundle().pathForResource("scroll_up", ofType: "mp3") {
            audioPlayer = AVAudioPlayer(contentsOfURL: NSURL(fileURLWithPath: path), fileTypeHint: "mp3", error: nil)
            if let sound = audioPlayer {
              sound.prepareToPlay()
              sound.play()
            }
          }


        }
    }
    
    //画像枚数分カウント
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return CharaDatas.count
    }
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    @IBAction func returnMenu(segue: UIStoryboardSegue){
    }
    
    //もうここからデータベース関係ですよ
    func readPets() -> NSArray{
        println("readData ------------")
        let app: AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let categoryContext: NSManagedObjectContext = app.managedObjectContext!
        let categoryRequest: NSFetchRequest = NSFetchRequest(entityName: "Pet")
        
        var results: NSArray! = categoryContext.executeFetchRequest(categoryRequest, error: nil)
        return results
        
    }
    
    func readPictures() -> NSArray{
        println("readData ------------")
        let app: AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let categoryContext: NSManagedObjectContext = app.managedObjectContext!
        let categoryRequest: NSFetchRequest = NSFetchRequest(entityName: "Charapicture")
        let predicate = NSPredicate(format: "picturenumber = %d",1)
        categoryRequest.predicate = predicate
        var results: NSArray! = categoryContext.executeFetchRequest(categoryRequest, error: nil)
        return results
        
    }
    
    func readCharaData() -> NSArray{
        println("readData ------------++++++++++++++++++++++++++@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@")
        
        let app: AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let categoryContext: NSManagedObjectContext = app.managedObjectContext!
        let categoryRequest: NSFetchRequest = NSFetchRequest(entityName: "Charadata")
        
        var results: NSArray! = categoryContext.executeFetchRequest(categoryRequest, error: nil)
        println(results)
        return results
    
    }


    func initPetMasters() {
        println("initMasters ------------")
        //plist読み込み
        let path:NSString = NSBundle.mainBundle().pathForResource("PetMaster", ofType: "plist")!
        var masterDataDictionary:NSDictionary = NSDictionary(contentsOfFile: path as String)!
        let app: AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let categoryContext: NSManagedObjectContext = app.managedObjectContext!
        
        for(var i = 1; i<=masterDataDictionary.count; i++) {
            let index_name: String = "item" + String(i)
            var item: AnyObject = masterDataDictionary[index_name]!
            
            let categoryEntity: NSEntityDescription! = NSEntityDescription.entityForName(
                "Pet", inManagedObjectContext: categoryContext)
            var new_data  = NSManagedObject(entity: categoryEntity, insertIntoManagedObjectContext: categoryContext)
            new_data.setValue(item.valueForKey("monsterid"), forKey: "monsterid")
            new_data.setValue(item.valueForKey("r"), forKey: "r")
            new_data.setValue(item.valueForKey("g"), forKey: "g")
            new_data.setValue(item.valueForKey("b"), forKey: "b")
            new_data.setValue(item.valueForKey("generation"), forKey: "generation")
            new_data.setValue(item.valueForKey("name"), forKey: "name")
            new_data.setValue(item.valueForKey("started"), forKey: "started")
            new_data.setValue(item.valueForKey("ended"), forKey: "ended")
            new_data.setValue(item.valueForKey("totaldistance"), forKey: "totaldistance")
            new_data.setValue(item.valueForKey("totalstep"), forKey: "totalstep")
            new_data.setValue(item.valueForKey("efforts"), forKey: "efforts")
            new_data.setValue(item.valueForKey("godpoint"), forKey: "godpoint")
            
            var error: NSError?
            categoryContext.save(&error)
            
        }
        println("InitMasters OK!")
    }
    
    func initPictureMasters() {
        println("initMasters ------------")
        //plist読み込み
        let path:NSString = NSBundle.mainBundle().pathForResource("CharapictureMaster", ofType: "plist")!
        var masterDataDictionary :NSDictionary = NSDictionary(contentsOfFile: path as String)!
        let app: AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let categoryContext: NSManagedObjectContext = app.managedObjectContext!
        
        for(var i = 0; i<masterDataDictionary.count; i++) {
            let index_name: String = "item" + String(i)
            var item: AnyObject = masterDataDictionary[index_name]!
            
            let categoryEntity: NSEntityDescription! = NSEntityDescription.entityForName(
                "Charapicture", inManagedObjectContext: categoryContext)
            var new_data  = NSManagedObject(entity: categoryEntity, insertIntoManagedObjectContext: categoryContext)
          
            new_data.setValue(item.valueForKey("charanumber"), forKey: "charanumber")
            new_data.setValue(item.valueForKey("picturenumber"), forKey: "picturenumber")
            new_data.setValue(item.valueForKey("image"), forKey: "picturename")
          
            var error: NSError?
            categoryContext.save(&error)
        }
        println("InitMasters OK!")
    }
    
    func initCharaMasters() {
        println("initMasters ------------")
        //plist読み込み
        let path:NSString = NSBundle.mainBundle().pathForResource("CharadataMaster", ofType: "plist")!
        var masterDataDictionary:NSDictionary = NSDictionary(contentsOfFile: path as String)!
        let app: AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let categoryContext: NSManagedObjectContext = app.managedObjectContext!
        
        for(var i = 1; i<=masterDataDictionary.count; i++) {
            let index_name: String = "data" + String(i)
            var item: AnyObject = masterDataDictionary[index_name]!
            
            let categoryEntity: NSEntityDescription! = NSEntityDescription.entityForName(
                "Charadata", inManagedObjectContext: categoryContext)
            var new_data  = NSManagedObject(entity: categoryEntity, insertIntoManagedObjectContext: categoryContext)
            new_data.setValue(item.valueForKey("text"), forKey: "text")
            new_data.setValue(item.valueForKey("haved"), forKey: "haved")
            new_data.setValue(item.valueForKey("name"), forKey: "name")
            new_data.setValue(item.valueForKey("rgb"), forKey: "rgb")
            
            var error: NSError?
            categoryContext.save(&error)
            
        }

    }
  
  //それ以外
  func takePhoto(i :Int) -> String{
    var photo = ""
    var CharaData: AnyObject = CharaDatas[i]
    var haveFlug = CharaData.valueForKey("haved") as! Bool
    if(haveFlug == false){
      photo = "secret"
    }else{
      for pict in Pictures{
        var check = pict.valueForKey("charanumber") as! Int
        if(i+1 == check){
          photo = pict.valueForKey("picturename") as! String
          break
        }
      }
    }
    return photo
    }
  
  override func viewWillDisappear(animated: Bool) {
    if let path = NSBundle.mainBundle().pathForResource("click", ofType: "mp3") {
      audioPlayer = AVAudioPlayer(contentsOfURL: NSURL(fileURLWithPath: path), fileTypeHint: "mp3", error: nil)
      if let sound = audioPlayer {
        sound.prepareToPlay()
        sound.play()
      }
    }
  }

}
