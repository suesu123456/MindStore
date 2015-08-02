//
//  Common.swift
//  MindStores
//
//  Created by sue on 15/7/23.
//  Copyright (c) 2015年 sue. All rights reserved.
//

import UIKit

struct Common {
    static let screenWidth = UIScreen.mainScreen().bounds.maxX
    static let screenHeight = UIScreen.mainScreen().bounds.maxY - 64
    static func frame() -> CGRect{
        var frame: CGRect = UIScreen.mainScreen().bounds
        frame.size.height -= (20+44);//减去状态栏、导航栏的高度
        return frame;
    }
}