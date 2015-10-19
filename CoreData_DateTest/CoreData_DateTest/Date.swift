//
//  Date.swift
//  
//
//  Created by 坂本一 on 2015/10/18.
//
//

import Foundation
import CoreData

@objc(Date)
class Date: NSManagedObject {

    @NSManaged var date: NSDate
    @NSManaged var step: NSNumber

}
