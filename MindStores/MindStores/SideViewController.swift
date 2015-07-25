//
//  SideViewController.swift
//  MindStores
//
//  Created by sue on 15/7/23.
//  Copyright (c) 2015年 sue. All rights reserved.
//

import UIKit

class SideViewController: UIViewController {
    
    var homeViewController: HomeViewController!
    var distance:CGFloat = 0
    
    let FullDistance: CGFloat = 0.78
    let Proportion: CGFloat = 0.77
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initNav()
        //给主视图设置背景
        let imageView = UIImageView(image: UIImage(named: "back"))
        imageView.frame = UIScreen.mainScreen().bounds
        self.view.addSubview(imageView)
        //找到HomeViewController的view ,放在背景视图上面
        homeViewController = HomeViewController()
        self.addChildViewController(homeViewController)
        self.view.addSubview(homeViewController.view)
        //绑定UIPanGestureRecognizer
        homeViewController.panGesture.addTarget(self, action:Selector("pan:"))
        
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func initNav() {
        
        var leftBtn = UIBarButtonItem(image: UIImage(named:"mindstore"), style: UIBarButtonItemStyle.Plain, target: nil, action: nil)
        leftBtn.tintColor = UIColor(hexString: "#39C0C0")
        self.navigationItem.leftBarButtonItem = leftBtn
        //搜索框
        var searchField: UITextField = UITextField(frame: CGRectMake(Common.screenWidth/3, 10, 120, 25))
        searchField.backgroundColor = UIColor.clearColor()
        searchField.placeholder = "搜索"
        searchField.textColor = UIColor(hexString: "#B4B4B4")
        searchField.font = UIFont.boldSystemFontOfSize(12)
        searchField.borderStyle = UITextBorderStyle.RoundedRect
        self.navigationController?.navigationBar.addSubview(searchField)
        //添加产品
        var rightBtn = UIBarButtonItem (barButtonSystemItem: UIBarButtonSystemItem.Add, target: nil, action: nil)
        self.navigationItem.rightBarButtonItem = rightBtn
        
    }
    
    func pan(recongnizer: UIPanGestureRecognizer) {
        let x = recongnizer.translationInView(self.view).x
        let trueDistance = distance + x //实时距离
        // 如果UIPanGestureRecognizer结束，则激活自动停靠
        if recongnizer.state == UIGestureRecognizerState.Ended {
            if trueDistance > Common.screenWidth * (Proportion / 3) {
                showLeft()
            }else if trueDistance < Common.screenWidth * -(Proportion / 3) {
                showRight()
            } else {
                showHome()
            }
            
            return
        }
        // 计算缩放比例
        var proportion: CGFloat = recongnizer.view!.frame.origin.x >= 0 ? -1 : 1
        proportion *= trueDistance / Common.screenWidth
        proportion *= 1 - Proportion
        proportion /= 0.6
        proportion += 1
        if proportion <= Proportion { // 若比例已经达到最小，则不再继续动画
            return
        }
        // 执行平移和缩放动画
        recongnizer.view!.center = CGPointMake(self.view.center.x + trueDistance, self.view.center.y)
        recongnizer.view!.transform = CGAffineTransformScale(CGAffineTransformIdentity, proportion, proportion)
        
    }
    // 封装三个方法，便于后期调用
    
    // 展示左视图
    func showLeft() {
        distance = self.view.center.x * (FullDistance + Proportion / 2)
        doTheAnimate(self.Proportion)
    }
    // 展示主视图
    func showHome() {
        distance = 0
        doTheAnimate(1)
    }
    // 展示右视图
    func showRight() {
        distance = self.view.center.x * -(FullDistance + Proportion / 2)
        doTheAnimate(self.Proportion)
    }
    // 执行三种试图展示
    func doTheAnimate(proportion: CGFloat) {
        UIView.animateWithDuration(0.3, delay: 0, options: UIViewAnimationOptions.CurveEaseInOut, animations: { () -> Void in
            self.homeViewController.view.center = CGPointMake(self.view.center.x + self.distance, self.view.center.y)
            self.homeViewController.view.transform = CGAffineTransformScale(CGAffineTransformIdentity, proportion, proportion)
            }, completion: nil)
    }
    
    
}
