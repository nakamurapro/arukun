//
//  ViewController.swift
//  CoreDataTest
//
//  Created by chikaratada on H27/06/19.
//  Copyright (c) 平成27年 chikaratada. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UIViewController {

    @IBOutlet weak var tfMemoCreate: UITextField!
    @IBOutlet weak var tfMemoRead: UITextField!
    @IBOutlet weak var tfMemoUpdate: UITextField!
    var obj : NSManagedObject? = nil

//    var appDelegate : AppDelegate = (UIApplication.sharedApplication().delegate as! AppDelegate)
//    var context : NSManagedObjectContext = appDelegate.managedObjectContext!
//    
    @IBAction func btnSave(sender: UIButton) {
        // Create
        if (tfMemoCreate!.text == "") {
            return
        }
        
        // managedObjectContext取得
        var appDelegate : AppDelegate = (UIApplication.sharedApplication().delegate as! AppDelegate)
        var context : NSManagedObjectContext = appDelegate.managedObjectContext!
        // 新しいオブジェクトを作成
        var newTodo = NSEntityDescription.insertNewObjectForEntityForName("ToDo", inManagedObjectContext: context) as NSManagedObjectnewTodo.setValue(tfMemoCreate!.text, forKey: "memo")
        // 作成したオブジェクトを保存
        var error: NSError? = nil
        if !context.save(&error) {
            abort()
        }
        println(newTodo)
        println("New Object Saved!")
    }
    
    @IBAction func btnLoad(sender: UIButton) {
        
    }
    
    @IBAction func btnDelete(sender: AnyObject) {
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

