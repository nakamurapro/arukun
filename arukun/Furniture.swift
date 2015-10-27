//
//  Furniture.swift
//  arukun
//
//  Created by 坂本一 on 2015/10/27.
//  Copyright (c) 2015年 chikaratada. All rights reserved.
//

import Foundation
import CoreData

@objc(Furniture)
class Furniture: NSManagedObject {

    @NSManaged var haved: NSNumber
    @NSManaged var image: String
    @NSManaged var kind: String
    @NSManaged var name: String
    @NSManaged var point: NSNumber

}
