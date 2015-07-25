//
//  UILableExtension.swift
//  MindStores
//
//  Created by sue on 15/7/24.
//  Copyright (c) 2015年 sue. All rights reserved.
//

import UIKit

extension UILabel {
    func setLineText(texts: String) {
        self.lineBreakMode = NSLineBreakMode.ByWordWrapping
        self.numberOfLines = 0
        self.text = texts
    }
}
