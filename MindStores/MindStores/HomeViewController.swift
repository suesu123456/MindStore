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

    var resultObjects: [[MindModel]]!
    var dictModel: [MindModel]!
    var sqlHelper: SqlHelper!
    var urlCu: (String,String)!
    var loadMoreEnabled: Bool = true
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
        self.initNav()
        sqlHelper = SqlHelper()
        self.initViews()
        
        //不管有没有网络，先去请求本地的
        self.resultObjects = Array()
        self.initData()
        urlCu = ("","")
        self.netWork("")
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
        self.view.endEditing(true)
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
        self.navigationItem.titleView = searchField
        var rightBtn = UIBarButtonItem (barButtonSystemItem: UIBarButtonSystemItem.Add, target: nil, action: "add")
        self.navigationItem.rightBarButtonItem = rightBtn
        //self.navigationController!.hidesBarsOnSwipe = true;
    }
    
    func initViews() {
        self.view.backgroundColor = UIColor.whiteColor()
        self.automaticallyAdjustsScrollViewInsets = false
        panGesture = UIPanGestureRecognizer()
        //        panGesture.delegate = self
        panGesture.minimumNumberOfTouches = 1;
        panGesture.maximumNumberOfTouches = 1;
        self.view.addGestureRecognizer(panGesture)
        // 创建tableView
        tableView = UITableView(frame: CGRectMake(0, 0, Common.screenWidth, Common.screenHeight))
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 100.0
        self.view.addSubview(tableView)
        //添加下拉刷新 上拉加载
        self.refreshControl = UIRefreshControl()
        self.refreshControl.addTarget(self, action: "onPullToRefresh", forControlEvents: UIControlEvents.ValueChanged)
        self.tableView.addSubview(refreshControl!)
        self.setupInfiniteScrollingView()
        
    }
    
    func initData() {
        var datas : [MindModel] =  self.sqlHelper.hasMindData()
        if datas.count > 0 {
            self.convertArray(datas)
        }
    }
    
    func netWork (str: String) {
        self.refreshing = false
        self.loadMoreEnabled = false
        //请求测试
        ApiManager.sharedInstance.mindAll(str, andClosure: { (result) -> () in
            var meta: NSDictionary = result["meta"] as! NSDictionary
            
            if !meta["previous"]!.isKindOfClass(NSNull) {
                self.urlCu.0 = meta["previous"] as! String
            }
            
            if !meta["next"]!.isKindOfClass(NSNull) {
                self.urlCu.1 = meta["next"] as! String
            }
            
            //异步去转换为对象
            self.convertToModel(result["objects"] as! [NSDictionary])
            //更新缓存
            self.sqlHelper.insertAll(self.dictModel)
            self.refreshing = true
            self.loadMoreEnabled = true
            }) { (error) -> () in
                println(error)
                return
        }
    }
    

    
    func add() {
        //判断登录状态
        if UserModel.isLogin() {
        
        }else{
            
            
        }
        
    }
    
    //tableView datasource
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return self.resultObjects == nil ? 1 : self.resultObjects.count
    }
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        if self.resultObjects == nil {
            return ""
        }
        var dicta: MindModel = self.resultObjects[section][0]
        var timeTemp: String = dicta.created_at.description
        var timeStr: String = DateHelper().formatToStr(timeTemp)
        return timeStr
    }
    
    func tableView(tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        
        var timeStr = ""
        if self.resultObjects != nil {
            var dicta: MindModel = self.resultObjects[section][0]
            var timeTemp: String = dicta.created_at.description
            var timeStr: String = DateHelper().formatToStr(timeTemp)
            var atrStr: NSMutableAttributedString = NSMutableAttributedString(string: timeStr)
          //  atrStr.addAttribute(NSForegroundColorAttributeName, value: UIColor.blackColor(), range: NSMakeRange(0, 4))
          //  atrStr.addAttribute(NSForegroundColorAttributeName, value: UIColor(hexString: "#CACACA")!, range: NSMakeRange(4, 6))
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
        // 填充tableView
        if(self.resultObjects != nil){
            var dic1 = self.resultObjects[indexPath.section][indexPath.row]
            var dic2 = dic1.created_by
            var imageUrl = "http://tp2.sinaimg.cn/1642881017/180/22887240315/1"//dic2["lime_avatar_url"]as! String
            var title = dic1.title
            var counts = dic1.vote_count
            var tagline = dic1.tagline
            
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
        var vote = VoteViewController()
//        SideViewController().removeFromParentViewController()
        self.navigationController!.pushViewController(vote, animated: true)
    }
    func scrollViewDidEndDragging(scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if scrollView.contentOffset.y > scrollView.contentSize.height - scrollView.frame.size.height {
            self.loadMore()
        }
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
    func onPullToRefresh() {
           self.netWork("")
    }
    func loadMore(){
        if loadMoreEnabled {
            self.netWork(self.urlCu.1)
        }
    }
    // 转换为二维数组，按天来划分
    func convertArray (dict: [MindModel]) {
        var arrayTemp: [MindModel] = Array()
        arrayTemp.append(dict.first!)
        var dicta: MindModel = arrayTemp[0]
        var timeTemp: String = dicta.created_at.description
        for var i = 1; i<dict.count; i++ {
            var json: MindModel = dict[i]
            if (DateHelper().isSameDay(timeTemp, stamp2: json.created_at.description)) { //判断是否为同一天
                arrayTemp.append(json)
            }else{
                self.resultObjects.append(arrayTemp)
                arrayTemp = Array()
                arrayTemp.append(json)
                timeTemp = json.created_at.description
            }
            if i == dict.count-1 {
                self.resultObjects.append(arrayTemp)
            }
        }
        self.tableView.reloadData()
    }
    func convertToModel(dict: [NSDictionary]) {
        self.dictModel = Array()
        for a1 in dict {
            var mind = MindModel()
            mind.set(a1)
            self.dictModel.append(mind)
        }
        self.convertArray(self.dictModel)
    }
}

