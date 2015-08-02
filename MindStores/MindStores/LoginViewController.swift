//
//  LoginViewController.swift
//  MindStores
//
//  Created by sue on 15/7/27.
//  Copyright (c) 2015年 sue. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.whiteColor()
        self.initViews()
    }
    func initViews(){
        var backBtn = UIButton(frame: CGRectMake(15, 30, 50, 50))
        backBtn.addTarget(self, action: Selector("back"), forControlEvents: UIControlEvents.TouchUpInside)
        backBtn.setBackgroundImage(UIImage(named: "undo"), forState: UIControlState.Normal)
        backBtn.sizeToFit()
        self.view.addSubview(backBtn)
        
        var sinaBtn = UIButton(frame: CGRectMake(90, 90, Common.screenWidth-180, 40))
        sinaBtn.setTitle("使用微博登录", forState: UIControlState.Normal)
        sinaBtn.backgroundColor = UIColor.redColor()
        sinaBtn.tintColor = UIColor.whiteColor()
        sinaBtn.layer.cornerRadius = sinaBtn.bounds.width/8
        sinaBtn.layer.masksToBounds = true
        self.view.addSubview(sinaBtn)
        
        var lineView = UIView(frame: CGRectMake(80, 160, (Common.screenWidth-200)/2, 1))
        lineView.backgroundColor = UIColor.blackColor()
        self.view.addSubview(lineView)
        var label = UILabel(frame: CGRectMake(lineView.frame.maxX+5, 150, 30, 20))
        label.text = "或者"
        label.font = UIFont.systemFontOfSize(14)
        label.textColor = UIColor(hexString: "#666666")
        self.view.addSubview(label)
        var lineView2 = UIView(frame: CGRectMake(label.frame.maxX+5, 160, (Common.screenWidth-200)/2, 1))
        lineView2.backgroundColor = UIColor.blackColor()
        self.view.addSubview(lineView2)
        
        var imageView = UIImageView(frame: CGRectMake(80, lineView2.frame.maxY+30, Common.screenWidth-160, 60))
        
        
        var label2 = UILabel(frame: CGRectMake(80, imageView.frame.maxY+10, Common.screenWidth-160, 20))
        label2.text = "请使用微信扫描二维码登录“觅点”"
        label2.font = UIFont.systemFontOfSize(10)
        label2.textColor = UIColor.blackColor()
        self.view.addSubview(label2)
    
    }
    
    func back(){
        self.dismissViewControllerAnimated(true, completion: { () -> Void in
        
        })
    
    }
}
