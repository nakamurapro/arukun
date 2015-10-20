//
//  CustomLeftArrow.swift
//  nyaa
//
//  Created by yuya omori on 2015/09/30.
//  Copyright (c) 2015年 yuya omori. All rights reserved.
//
import UIKit

class CustomLeftArrow: UIView
{
    override func drawRect(rect: CGRect)
    {
        var x: CGFloat = 0.0
        var y: CGFloat = rect.size.height / 2
        
        var x2: CGFloat = rect.size.width
        var y2: CGFloat = 0.0
        
        var x3: CGFloat = rect.size.width
        var y3: CGFloat = rect.size.height
        
        UIColor.blackColor().setStroke()
        
        var line = UIBezierPath()
        line.lineWidth = 0.3
        line.moveToPoint(CGPointMake(x, y))
        line.addLineToPoint(CGPointMake(x2, y2))
        line.stroke()
        
        var line2 = UIBezierPath()
        line2.lineWidth = 0.3
        line2.moveToPoint(CGPointMake(x3, y3))
        line2.addLineToPoint(CGPointMake(x, y))
        line2.stroke()
        
    }
}
