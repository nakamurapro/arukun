//
//  CustomLeftTableViewCell.swift
//  nyaa
//
//  Created by yuya omori on 2015/09/30.
//  Copyright (c) 2015年 yuya omori. All rights reserved.
//

import UIKit

class CustomLeftTableViewCell: UITableViewCell{
    var icon: UIImageView = UIImageView() // アイコン
    var name: UILabel = UILabel() // 名前
    var created: UILabel = UILabel() // 投稿日時
    
    var arrow: CustomLeftArrow = CustomLeftArrow() // 吹き出しの突起の部分
    var message: UILabel = UILabel() // 吹き出しの文字を表示している部分
    var viewMessage: UIView = UIView() // 吹き出しの枠部分
    
    required init(coder aDecoder: NSCoder)
    {
        super.init(coder: aDecoder)
        self.selectionStyle = UITableViewCellSelectionStyle.None
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?)
    {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = UITableViewCellSelectionStyle.None
        
        self.viewMessage.layer.borderColor = UIColor.grayColor().CGColor
        self.viewMessage.layer.borderWidth = 0.5
        self.viewMessage.layer.cornerRadius = 10.0
        self.viewMessage.backgroundColor = UIColor.whiteColor()
        
        //self.message.font = UIFont.systemFontOfSize(14)
        self.message.font = UIFont (name: "HiraKakuProN-W6" ,size:20);
        self.message.numberOfLines = 0
        //self.message.backgroundColor = UIColor.clearColor()
        
        self.viewMessage.addSubview(self.message)
        self.contentView.addSubview(self.viewMessage)
        
        self.arrow.backgroundColor = UIColor.clearColor()
        //self.arrow.backgroundColor = UIColor.clearColor()
        self.addSubview(self.arrow)
        
        self.icon.layer.borderColor = UIColor.blackColor().CGColor
        self.icon.layer.borderWidth = 0.5
        
        self.addSubview(self.icon)
        
        //self.name.font = UIFont.boldSystemFontOfSize(13)
        self.name.font = UIFont (name: "HiraKakuProN-W6" ,size:15);
        self.name.textAlignment = NSTextAlignment.Left
        self.addSubview(self.name)
        
        //self.created.font = UIFont.systemFontOfSize(13)
        self.created.font = UIFont (name: "HiraKakuProN-W6" ,size:20);
        self.created.textAlignment = NSTextAlignment.Right
        self.addSubview(self.created)
    }
    
    func setData(widthMax: CGFloat,data: Dictionary<String,AnyObject>) -> CGFloat
    {
        var marginLeft: CGFloat = 60
        var marginRight: CGFloat = 0
        var marginVertical: CGFloat = 30

// アイコン

        var xIcon: CGFloat = 3
        var yIcon: CGFloat = 3
        var widthIcon: CGFloat = 45
        var heightIcon: CGFloat = 55
        self.icon.frame = CGRectMake(xIcon, yIcon, widthIcon, heightIcon)
        self.icon.image = UIImage(named: (data["image"] as? String)!)
        self.icon.layer.cornerRadius = self.icon.frame.size.width * 0.5
        self.icon.clipsToBounds = true
        
        // 名前
        var xName: CGFloat = self.icon.frame.origin.x + self.icon.frame.size.width + 3
        var yName: CGFloat = self.icon.frame.origin.y
        var widthName: CGFloat = widthMax - (self.icon.frame.origin.x + self.icon.frame.size.width + 3)
        var heightName: CGFloat = 30
        self.name.text = data["name"] as? String
        self.name.frame = CGRectMake(xName, yName, widthName, heightName)
        
        // 投稿日時
        var xCreated: CGFloat = self.icon.frame.origin.x + self.icon.frame.size.width + 3
        var yCreated: CGFloat = self.icon.frame.origin.y
        var widthCreated: CGFloat = widthMax - (self.icon.frame.origin.x + self.icon.frame.size.width + 10)
        var heightCreated: CGFloat = 30
        self.created.text = data["created"] as? String
        self.created.frame = CGRectMake(xCreated, yCreated, widthCreated, heightCreated)
        var paddingHorizon: CGFloat = 10
        var paddingVertical: CGFloat = 10
        
        var widthLabelMax: CGFloat = widthMax - (marginLeft + marginRight + paddingHorizon * 2)
        
        var xMessageLabel: CGFloat = paddingHorizon
        var yMessageLabel: CGFloat = paddingVertical
        
        self.message.frame = CGRectMake(xMessageLabel, yMessageLabel, widthLabelMax, 0)
        self.message.text = data["message"] as? String
        self.message.sizeToFit()
        
        var xMessageView: CGFloat = marginLeft
        var yMessageView: CGFloat = marginVertical
        var widthMessageView: CGFloat = self.message.frame.size.width + paddingHorizon * 2
        var heightMessageView: CGFloat = self.message.frame.size.height + paddingVertical * 2
        self.viewMessage.frame = CGRectMake(xMessageView, yMessageView, widthMessageView, heightMessageView)
        
        var widthArrow: CGFloat = 10
        var heightArrorw: CGFloat = 10
        var xArrow: CGFloat = marginLeft - widthArrow + 1
        var yArrow: CGFloat = self.viewMessage.frame.origin.y + heightArrorw
        self.arrow.frame = CGRectMake(xArrow, yArrow, widthArrow, heightArrorw)
        
        var height: CGFloat = self.viewMessage.frame.height + marginVertical * 2
        return height
  }
}
