//
//  avatarView.swift
//  MindStores
//
//  Created by sue on 15/7/31.
//  Copyright (c) 2015年 sue. All rights reserved.
//

import UIKit

class AvatarView: UIView {
    
    func addImage(array: [String]){
        var x: CGFloat = 0
        var y: CGFloat = 0
        for str in array {
            var image = UIImageView(frame: CGRectMake(0 + x, 0 + y, 30, 30))
            var url = NSURL(string: str)
            image.sd_setImageWithURL(url, placeholderImage: UIImage(named: "ava"))
            image.layer.cornerRadius = image.bounds.width / 2
            image.layer.masksToBounds = true
            self.addSubview(image)
            x = x + 35
            if x >= Common.screenWidth {
                x = 0
                y = y + 35
            }
        }
    }
}

