//
//  VoteViewController.swift
//  MindStores
//
//  Created by sue on 15/7/27.
//  Copyright (c) 2015年 sue. All rights reserved.
//

import UIKit

class VoteViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.whiteColor()
        self.title = "sdfd"
        self.view.frame=UIView.frameWithOutNavTab(self.view)();
        initHead()
    
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }


    func initHead () {
        var head: UIView = UIView(frame: CGRectMake(0, 69, Common.screenWidth, 40))
        var avaImageView: UIImageView = UIImageView(frame: CGRectMake(5, 69, 30, 30))
        avaImageView.sd_setImageWithURL(NSURL(string: "http://wenwen.sogou.com/p/20110607/20110607205948-14980965.jpg"), placeholderImage: UIImage(named: "ava"))
        avaImageView.layer.cornerRadius =  12
        avaImageView.layer.masksToBounds  = true
        var infoLabel: UILabel = UILabel(frame: CGRectMake(50, 69, Common.screenWidth-40, 25))
        infoLabel.font = UIFont.systemFontOfSize(12)
        infoLabel.textColor = UIColor(hexString: "#A0A0A0")
        infoLabel.text = "米米 发布于7月23日 09：30"
        
        self.view.addSubview(avaImageView)
        self.view.addSubview(infoLabel)
    }
    

}
