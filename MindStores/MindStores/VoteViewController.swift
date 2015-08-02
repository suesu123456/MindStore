//
//  VoteViewController.swift
//  MindStores
//
//  Created by sue on 15/7/27.
//  Copyright (c) 2015年 sue. All rights reserved.
//

import UIKit

class VoteViewController: UIViewController {
    
    var avaImageView: UIImageView!
    var infoLabel: UILabel!
    var titleLable: UILabel!
    var contentLable: UILabel!
    var personLable: UILabel!
    var avatarView: AvatarView!
    var votelable: UILabel!
    
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
        avaImageView = UIImageView(frame: CGRectMake(15, 74, 30, 30))
        avaImageView.sd_setImageWithURL(NSURL(string: "http://wenwen.sogou.com/p/20110607/20110607205948-14980965.jpg"), placeholderImage: UIImage(named: "ava"))
        avaImageView.layer.cornerRadius =  12
        avaImageView.layer.masksToBounds  = true
        infoLabel = UILabel(frame: CGRectMake(60, 74, Common.screenWidth-40, 25))
        infoLabel.font = UIFont.systemFontOfSize(12)
        infoLabel.textColor = UIColor(hexString: "#A0A0A0")
        infoLabel.text = "米米 发布于7月23日 09：30"
        self.view.addSubview(avaImageView)
        self.view.addSubview(infoLabel)
        //内容
        titleLable = UILabel(frame: CGRectMake(60, infoLabel.frame.maxY+15, Common.screenWidth-75, 20))
        titleLable.font = UIFont.systemFontOfSize(13)
        titleLable.text = "兼客兼职 #iOS #Android"
        contentLable = UILabel(frame: CGRectMake(60, titleLable.frame.maxY, Common.screenWidth-75, 30))
        contentLable.font = UIFont.systemFontOfSize(12)
        contentLable.textColor = UIColor(hexString: "#999999")
        contentLable.text = "每天提供大量兼职信息，并且永久免费。"
        personLable =  UILabel(frame: CGRectMake(60, contentLable.frame.maxY+10, Common.screenWidth-75, 20))
        personLable.font = UIFont.systemFontOfSize(12)
        personLable.textColor = UIColor(hexString: "#999999")
        personLable.text = "6个人投了票"
        self.view.addSubview(titleLable)
        self.view.addSubview(contentLable)
        self.view.addSubview(personLable)
        //头像
        avatarView = AvatarView(frame: CGRectMake(60, personLable.frame.maxY+5, Common.screenWidth-75, 60))
        avatarView.addImage(["http://tp2.sinaimg.cn/1642881017/180/22887240315/1","http://tp2.sinaimg.cn/1642881017/180/22887240315/1","http://tp2.sinaimg.cn/1642881017/180/22887240315/1"])
        self.view.addSubview(avatarView)
        //评论
        var imageView = UIImageView(frame: CGRectMake(15, avatarView.frame.maxY+20, 20, 20))
        imageView.image = UIImage(named: "bubble")
        self.view.addSubview(imageView)
        //lable
        votelable = UILabel(frame: CGRectMake(50, avatarView.frame.maxY+20, 100, 20))
        votelable.font = UIFont.systemFontOfSize(12)
        votelable.text = "3条评论"
        self.view.addSubview(votelable)
        //评论区
        var scrollView = UIScrollView(frame: CGRectMake(0, votelable.frame.maxY+10, Common.screenWidth, 200))
        self.view.addSubview(scrollView)
        
        
        
        
    }
    

}
