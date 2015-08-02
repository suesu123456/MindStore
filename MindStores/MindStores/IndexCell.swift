//
//  IndexCell.swift
//  MindStores
//
//  Created by sue on 15/7/24.
//  Copyright (c) 2015年 sue. All rights reserved.
//

import UIKit

class IndexCell: UITableViewCell {

    var countLabel: UILabel!
    var titleLabel: UILabel!
    var detailLabel: UILabel!
    var imageViews: UIImageView!
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String!) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        //标题
        titleLabel = UILabel(frame: CGRectMake(15, 10, Common.screenWidth-100, 20))
        titleLabel.contentMode = UIViewContentMode.ScaleToFill
        titleLabel.font = UIFont.boldSystemFontOfSize(14)
        //详情
        detailLabel =  UILabel(frame: CGRectMake(15, 30, Common.screenWidth-100, 30))
        detailLabel.lineBreakMode = NSLineBreakMode.ByWordWrapping
        detailLabel.numberOfLines = 0
        detailLabel.font = UIFont.systemFontOfSize(10)
        detailLabel.textColor = UIColor(hexString: "#878787")
        //头像
        imageViews = UIImageView(frame: CGRectMake(Common.screenWidth-75, 10, 25, 25))
        imageViews.contentMode = UIViewContentMode.ScaleToFill
        imageViews.layer.cornerRadius =  12
        imageViews.layer.masksToBounds  = true
        //气泡
        var bubbleView:UIImageView = UIImageView(frame: CGRectMake(Common.screenWidth-40, 10, 25, 25))
        bubbleView.image = UIImage(named: "bubble")
        self.countLabel = UILabel(frame: CGRectMake(Common.screenWidth-30, 24, 15, 10))
        
        self.countLabel.textAlignment = NSTextAlignment.Center
        self.countLabel.font = UIFont.systemFontOfSize(9)
        self.countLabel.layer.cornerRadius = countLabel.bounds.size.width/2
        self.countLabel.textColor = UIColor.whiteColor()
        self.countLabel.layer.masksToBounds = true
        self.countLabel.backgroundColor = UIColor(hexString: "#22B9B9")
        
        self.contentView.addSubview(titleLabel)
        self.contentView.addSubview(detailLabel)
        self.contentView.addSubview(imageViews)
        self.contentView.addSubview(bubbleView)
        self.contentView.addSubview(countLabel)
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.detailTextLabel?.frame = CGRectMake(self.detailTextLabel!.frame.minX,
                                                 self.detailTextLabel!.frame.minY,
                                                 Common.screenWidth - 130,
                                                 self.detailTextLabel!.bounds.height)
       
        
    }
    
    func setCounLabel(str:String) {
        self.countLabel.text = str
    }
}
