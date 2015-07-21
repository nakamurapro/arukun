//
//  Person.swift
//  SeeddataTest
//
//  Created by 坂本一 on 2015/07/21.
//  Copyright (c) 2015年 Hajime Sakamoto. All rights reserved.
//

import Foundation
import CoreData

@objc(Person)
class Person: NSManagedObject {

    @NSManaged var age: NSNumber
    @NSManaged var name: String
    @NSManaged var makeat: NSDate

}
