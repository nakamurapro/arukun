//
//  ViewController.swift
//  RFCoreDataDemo
//
//  Created by Fuda Ryusuke on 2014/11/18.
//  Copyright (c) 2014年 Ryusuke Fuda. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UIViewController {
    
    var allDataArr = [NSManagedObject]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let managedContext: NSManagedObjectContext = appDelegate.managedObjectContext!
        let entity = NSEntityDescription.entityForName("Person", inManagedObjectContext: managedContext)
    
    }
    
    func saveName(name: String){
        
        /* Get ManagedObjectContext from AppDelegate */
        let appDelegate: AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let managedContext: NSManagedObjectContext = appDelegate.managedObjectContext!
        
        /* Create new ManagedObject */
        let entity = NSEntityDescription.entityForName("Person", inManagedObjectContext: managedContext)
        let personObject = NSManagedObject(entity: entity!, insertIntoManagedObjectContext: managedContext)
        
        /* Set the name attribute using key-value coding */
        personObject.setValue(name, forKey: "name")
        
        /* Error handling */
        var error: NSError?
        if !managedContext.save(&error) {
            println("Could not save \(error), \(error?.userInfo)")
        }
        println("object saved")
    }
    
    func fetchPersonData() {
        allDataArr = []
        
        /* Get ManagedObjectContext from AppDelegate */
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let manageContext = appDelegate.managedObjectContext!
        
        /* Set search conditions */
        let fetchRequest = NSFetchRequest(entityName: "Person")
        var error: NSError?
        
        /* Get result array from ManagedObjectContext */
        let fetchResults = manageContext.executeFetchRequest(fetchRequest, error: &error)
        if let results: Array = fetchResults {
            for obj:AnyObject in results {
                allDataArr.append(obj as! NSManagedObject)
                let name:String? = obj.valueForKey("name") as? String
                println("name=\(name!)")
            }
            println(results.count)
        } else {
            println("Could not fetch \(error) , \(error!.userInfo)")
        }
        
    }
    
    func updateName(managedObject: NSManagedObject, newName: String) {
        
        /* Get ManagedObjectContext from AppDelegate */
        let appDelegate: AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let managedContext: NSManagedObjectContext = appDelegate.managedObjectContext!
        
        /* Change value of managedObject */
        managedObject.setValue(newName, forKey: "name")
        
        /* Save value to managedObjectContext */
        var error: NSError?
        if !managedContext.save(&error) {
            println("Could not update \(error), \(error!.userInfo)")
        }
        
        println("Object updated")
    }
    
    func deleteName(managedObject: NSManagedObject) {
        
        /* Get ManagedObjectContext from AppDelegate */
        let appDelegate: AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let managedContext: NSManagedObjectContext = appDelegate.managedObjectContext!
        
        /* Delete managedObject from managed context */
        managedContext.deleteObject(managedObject)
        
        /* Save value to managed context */
        var error: NSError?
        if !managedContext.save(&error) {
            println("Could not update \(error), \(error!.userInfo)")
        }
        println("Object deleted")
        
    }
    
    @IBAction func tapAddButton(sender: AnyObject) {
        let randInt:Int = Int(arc4random_uniform(10))
        let name:String = "Steave Jobs " + String(randInt)
        saveName(name)
        fetchPersonData()
    }

    @IBAction func tapDeleteButton(sender: AnyObject) {
        if allDataArr.count > 0 {
            deleteName(allDataArr[0])
        }
        fetchPersonData()
    }
    
    @IBAction func tapUpdateButton(sender: AnyObject) {
        if allDataArr.count > 0 {
            updateName(allDataArr[0], newName: "new updated name")
        }
        fetchPersonData()
    }

    @IBAction func tapFetchButton(sender: AnyObject) {
        fetchPersonData()
    }
    
    @IBAction func tapSarchButton(sender: AnyObject) {
        println("ok")
        allDataArr = []
        
        /* Get ManagedObjectContext from AppDelegate */
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let manageContext = appDelegate.managedObjectContext!
        
        /* Set search conditions */
        let fetchRequest = NSFetchRequest(entityName: "Person")
        let predicate = NSPredicate(format: "%K = %s", "name", "1")
        println(predicate)
        fetchRequest.predicate = predicate
        var error: NSError?
        
        /* Get result array from ManagedObjectContext */
        let fetchResults = manageContext.executeFetchRequest(fetchRequest, error: &error)
        if let results: Array = fetchResults {
            for obj:AnyObject in results {
                allDataArr.append(obj as! NSManagedObject)
                let name:String? = obj.valueForKey("name") as? String
                println("name=\(name!)")
            }
            println(results.count)
        } else {
            println("Could not fetch \(error) , \(error!.userInfo)")
        }
    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

