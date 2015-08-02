//
//  SideViewController.swift
//  MindStores
//
//  Created by sue on 15/7/23.
//  Copyright (c) 2015年 sue. All rights reserved.
//

import UIKit

class SideViewController: UIViewController {
    
    var homeNavigationController: UINavigationController!
    var homeViewController: HomeViewController!
    var leftViewController: LeftViewController!
    
    var distance:CGFloat = 0
    
    let FullDistance: CGFloat = 0.78
    let Proportion: CGFloat = 0.77
    var centerOfLeftViewAtBeginning: CGPoint!
    var proportionOfLeftView: CGFloat = 1
    var distanceOfLeftView: CGFloat = 50
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //initNav()
        //渐变色
        var gradient =  CAGradientLayer()
        gradient.colors = [UIColor(hexString: "#3C5E94")!.CGColor, UIColor(hexString: "#000F40")!.CGColor, UIColor.blackColor().CGColor]
        gradient.locations = [0.0, 1.0]
        gradient.frame = self.view.bounds
        self.view.layer.insertSublayer(gradient, atIndex: 0)
        
        
        //取出LeftViewController.view
        leftViewController = LeftViewController()
        leftViewController.view.center = CGPointMake(leftViewController.view.center.x - 50, leftViewController.view.center.y)
        leftViewController.view.transform = CGAffineTransformScale(CGAffineTransformIdentity, 0.8, 0.8)
        centerOfLeftViewAtBeginning = leftViewController.view.center
        self.view.addSubview(leftViewController.view)

        //找到HomeViewController的view ,放在背景视图上面
        homeViewController = HomeViewController()
        homeNavigationController = UINavigationController(rootViewController: homeViewController)
        homeViewController = homeNavigationController.viewControllers.first as! HomeViewController
        self.view.addSubview(homeViewController.view)
        self.view.addSubview(homeViewController.navigationController!.view)
        
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
        let trueDistance = distance + x // 实时距离
        let trueProportion = trueDistance / (Common.screenWidth*FullDistance)
        
        // 如果 UIPanGestureRecognizer 结束，则激活自动停靠
        if recongnizer.state == UIGestureRecognizerState.Ended {
            
            if trueDistance > Common.screenWidth * (Proportion / 3) {
                showLeft()
            } else if trueDistance < Common.screenWidth * -(Proportion / 3) {
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
        proportion /= FullDistance + Proportion/2 - 0.5
        proportion += 1
        if proportion <= Proportion { // 若比例已经达到最小，则不再继续动画
            return
        }
        // 执行平移和缩放动画
        recongnizer.view!.center = CGPointMake(self.view.center.x + trueDistance, self.view.center.y)
        recongnizer.view!.transform = CGAffineTransformScale(CGAffineTransformIdentity, proportion, proportion)
        
        // 执行左视图动画
        let pro = 0.8 + (proportionOfLeftView - 0.8) * trueProportion
        leftViewController.view.center = CGPointMake(centerOfLeftViewAtBeginning.x + distanceOfLeftView * trueProportion, centerOfLeftViewAtBeginning.y - (proportionOfLeftView - 1) * leftViewController.view.frame.height * trueProportion / 2 )
        leftViewController.view.transform = CGAffineTransformScale(CGAffineTransformIdentity, pro, pro)
        
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
