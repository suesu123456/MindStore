//
//  ViewController.swift
//  MindStores
//
//  Created by sue on 15/7/23.
//  Copyright (c) 2015年 sue. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController,UIGestureRecognizerDelegate,UITableViewDataSource,UITableViewDelegate {
    
    var panGesture: UIPanGestureRecognizer!
    var tableView: UITableView!
    var refreshControl: UIRefreshControl!
    var infiniteScrollingView: UIView!

    var resultObjects: [[NSDictionary]]!
    
    var refreshing: Bool = false {
        didSet {
            if (self.refreshing) {
                self.refreshControl?.beginRefreshing()
                self.refreshControl?.attributedTitle = NSAttributedString(string: "Loading...")
                println("Loading...")
            }
            else {
                
                self.refreshControl?.endRefreshing()
                self.refreshControl?.attributedTitle = NSAttributedString(string: "Pull to Refresh")
                println("Loaded & set:Pull to Refresh")
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.whiteColor()
        panGesture = UIPanGestureRecognizer()
        //        panGesture.delegate = self
        panGesture.minimumNumberOfTouches = 1;
        panGesture.maximumNumberOfTouches = 1;
        self.view.addGestureRecognizer(panGesture)
        // 创建tableView
        tableView = UITableView(frame: CGRectMake(0, 80, Common.screenWidth, Common.screenHeight))
        tableView.delegate = self
        tableView.dataSource = self
        self.view.addSubview(tableView)
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 100.0
        //添加下拉刷新 上拉加载
        self.refreshControl = UIRefreshControl()
        self.refreshControl.addTarget(self, action: "onPullToRefresh", forControlEvents: UIControlEvents.ValueChanged)
        self.tableView.addSubview(refreshControl!)
        self.setupInfiniteScrollingView()
        
        //请求测试
        ApiManager.sharedInstance.mindAll("", andClosure: { (result) -> () in
            //异步去转换数组
            self.convertArray(result["objects"] as! [NSDictionary])
        }) { (error) -> () in
            println(error)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //tableView datasource
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return self.resultObjects == nil ? 1 : self.resultObjects.count
    }
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        if self.resultObjects == nil {
            return ""
        }
        var dicta: NSDictionary = self.resultObjects[section][0]
        var timeTemp: String = dicta["created_at"]!.description
        var timeStr: String = DateHelper().formatToStr(timeTemp)
        return timeStr
    }
    
    func tableView(tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        
        var timeStr = ""
        if self.resultObjects != nil {
            var dicta: NSDictionary = self.resultObjects[section][0]
            var timeTemp: String = dicta["created_at"]!.description
            var timeStr: String = DateHelper().formatToStr(timeTemp)
            var atrStr: NSMutableAttributedString = NSMutableAttributedString(string: timeStr)
            atrStr.addAttribute(NSForegroundColorAttributeName, value: UIColor.blackColor(), range: NSMakeRange(0, 4))
//            atrStr.addAttribute(NSForegroundColorAttributeName, value: UIFont.boldSystemFontOfSize(14), range: NSMakeRange(0, 4))
            atrStr.addAttribute(NSForegroundColorAttributeName, value: UIColor(hexString: "#CACACA")!, range: NSMakeRange(4, 6))
//            atrStr.addAttribute(NSForegroundColorAttributeName, value: UIFont.boldSystemFontOfSize(10), range: NSMakeRange(5, 6))
            var label:UITableViewHeaderFooterView = view as! UITableViewHeaderFooterView;
            label.textLabel.attributedText = atrStr

        }
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.resultObjects != nil ? self.resultObjects[section].count:1
        
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell: IndexCell! = tableView.dequeueReusableCellWithIdentifier("table") as? IndexCell
        if cell == nil {
            cell = IndexCell(style: UITableViewCellStyle.Default, reuseIdentifier: "table")
        }
        //当下拉到底部，执行loadMore()
        if (refreshing && indexPath.row == 2) {
            self.tableView.tableFooterView = self.infiniteScrollingView
            loadMore()
        }
        // 填充tableView
        if(self.resultObjects != nil){
            var dic1 = self.resultObjects[indexPath.section][indexPath.row]
            var dic2 = dic1["created_by"]as! NSDictionary
            var imageUrl = dic2["lime_avatar_url"]as! String
            var title = dic1["title"]as! String
            var counts = dic1["vote_count"]as! Int
            var tagline = dic1["tagline"]as! String
            
            cell.imageViews!.sd_setImageWithURL(NSURL(string: imageUrl), placeholderImage: UIImage(named: "ava"))
            
            cell.titleLabel!.text = title
            cell.detailLabel!.text = tagline
            cell.setCounLabel(counts.description)
            
        }
        
        return cell
    }
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        var cell = self.tableView(tableView, cellForRowAtIndexPath: indexPath)
        return cell.frame.height + 15.0;
    }
        // tableView Delegate
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    
    }
    
    //上拉加载
    private func setupInfiniteScrollingView() {
        self.infiniteScrollingView = UIView(frame: CGRectMake(0, self.tableView.contentSize.height, self.tableView.bounds.size.width, 60))
        self.infiniteScrollingView!.autoresizingMask = UIViewAutoresizing.FlexibleWidth
        self.infiniteScrollingView!.backgroundColor = UIColor.whiteColor()
        var activityViewIndicator = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.White)
        activityViewIndicator.color = UIColor.darkGrayColor()
        activityViewIndicator.frame = CGRectMake(self.infiniteScrollingView!.frame.size.width/2-activityViewIndicator.frame.width/2, self.infiniteScrollingView!.frame.size.height/2-activityViewIndicator.frame.height/2, activityViewIndicator.frame.width, activityViewIndicator.frame.height)
        activityViewIndicator.startAnimating()
        self.infiniteScrollingView!.addSubview(activityViewIndicator)
    
    }
    //下拉获取数据
    func onPullToFresh() {
        
//        fetchDataFromServer()
    }
    func loadMore(){
        println("loadMore")
//        self.data = self.data.arrayByAddingObjectsFromArray(self.newData as! [String])
        self.tableView.reloadData()
    }
    // 转换为二维数组，按天来划分
    func convertArray (dict: [NSDictionary]) {
        self.resultObjects = Array()
        var arrayTemp: [NSDictionary] = Array()
        arrayTemp.append(dict.first!)
        var dicta: NSDictionary = arrayTemp[0]
        var timeTemp: String = dicta["created_at"]!.description
        for var i = 1; i<dict.count; i++ {
            var json = dict[i]
            if (DateHelper().isSameDay(timeTemp, stamp2: json["created_at"]!.description)) { //判断是否为同一天
                arrayTemp.append(json)
            }else{
                self.resultObjects.append(arrayTemp)
                arrayTemp = Array()
                arrayTemp.append(json)
                timeTemp = json["created_at"]!.description
            }
            if i == dict.count-1 {
                self.resultObjects.append(arrayTemp)
            }
        }
        self.tableView.reloadData()
    }

}

