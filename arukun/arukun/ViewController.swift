//
//  ViewController.swift
//  kore test
//
//  Created by kenseikamii on 2015/09/24.
//  Copyright (c) 2015年 kenseikamii. All rights reserved.
//
import UIKit
import CoreData

class ViewController: UIViewController,UICollectionViewDataSource,UICollectionViewDelegate {
    
    @IBOutlet weak var scrollView :UIScrollView!
    @IBOutlet weak var image3: UIImageView!
    
    var selectedImage: UIImage?
    var selectedLabel: String?
    var str:String?
    var Pets :NSArray! //ペットのデータがここ
    var Pictures :NSArray! //写真データがここ
    
    let imgArray: NSArray = ["photo1.png","photo2.png","photo3.png"]
    let nameArray : NSArray = ["あるくん","あるちゃん","あるお"]
    
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
        var data: AnyObject = Pets[indexPath.row]
        var Charanumber = data.valueForKey("monsterid") as! Int
        var photo = ""
        for pict in Pictures{
            var check = pict.valueForKey("charanumber") as! Int
            if(Charanumber == check){
                photo = pict.valueForKey("picturename") as! String
                break
            }
        }
        cell.image.image = UIImage(named: photo)
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
        
        var results: NSArray! = categoryContext.executeFetchRequest(categoryRequest, error: nil)
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
            
            var error: NSError?
            categoryContext.save(&error)
            
        }
        println("InitMasters OK!")
    }
    
    func initPictureMasters() {
        println("initMasters ------------")
        //plist読み込み
        let path:NSString = NSBundle.mainBundle().pathForResource("CharapictureMaster", ofType: "plist")!
        var masterDataDictionary:NSDictionary = NSDictionary(contentsOfFile: path as String)!
        let app: AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let categoryContext: NSManagedObjectContext = app.managedObjectContext!
        
        for(var i = 1; i<=masterDataDictionary.count; i++) {
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



}
