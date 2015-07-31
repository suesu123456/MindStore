//
//  UIViewExtension.swift
//  MindStores
//
//  Created by sue on 15/7/27.
//  Copyright (c) 2015年 sue. All rights reserved.
//

import UIKit

extension UIView {

    func frameWithOutNavTab() -> CGRect{
        var frame: CGRect = UIScreen.mainScreen().bounds
        frame.size.height -= (20+44+49);//减去状态栏、导航栏、Tab栏的高度
        return frame;
    }
}