//
//  CustomCell.swift
//  kore test
//
//  Created by kenseikamii on 2015/09/24.
//  Copyright (c) 2015年 kenseikamii. All rights reserved.
//

import UIKit

class CustomCell: UICollectionViewCell {
        
 
    @IBOutlet weak var image2: UIImageView!
    @IBOutlet var label: UILabel!
    @IBOutlet var image: UIImageView!

    override init(frame: CGRect){
        super.init(frame: frame)
        
    }
    required init(coder aDecoder: NSCoder){
        super.init(coder: aDecoder)
    }
    

    
}