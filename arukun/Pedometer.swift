//
//  Pedometer.swift
//  arukun
//
//  Created by 坂本一 on 2015/10/21.
//  Copyright (c) 2015年 chikaratada. All rights reserved.
//

import Foundation
import CoreData

@objc(Pedometer)
class Pedometer: NSManagedObject {

    @NSManaged var date: NSDate
    @NSManaged var step: NSNumber

}
