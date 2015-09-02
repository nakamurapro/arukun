//
//  People.swift
//  
//
//  Created by 坂本一 on 2015/07/16.
//
//

import UIKit
import Foundation
import CoreData

@objc(People)
class People: NSManagedObject {

    @NSManaged var name: String
    @NSManaged var age: NSNumber
    @NSManaged var makeat: NSDate

}
