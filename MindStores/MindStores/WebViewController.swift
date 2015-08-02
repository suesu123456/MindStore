//
//  WebViewController.swift
//  MindStores
//
//  Created by sue on 15/7/31.
//  Copyright (c) 2015年 sue. All rights reserved.
//

import UIKit

class WebViewController: UIViewController {
    
    var webView: UIWebView!
    var urlStr: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.whiteColor()
        self.view.frame=UIView.frameWithOutNavTab(self.view)();
        self.initViews()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func initViews() {
        var url = NSURL(string: urlStr)
        var request = NSURLRequest(URL: url!)
        webView = UIWebView(frame: CGRectMake(0, 0, Common.screenWidth, Common.screenHeight))
        webView.loadRequest(request)

    }
    
}
