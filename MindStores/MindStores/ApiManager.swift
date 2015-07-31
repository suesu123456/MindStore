//
//  ApiManager.swift
//  MindStores
//
//  Created by sue on 15/7/23.
//  Copyright (c) 2015年 sue. All rights reserved.
//

import UIKit
import Alamofire
import ReachabilitySwift
import JDStatusBarNotification

class  ApiManager{
    
    class var sharedInstance : ApiManager {
        struct Static {
            static var onceToken : dispatch_once_t = 0
            static var instance : ApiManager? = nil
        }
        dispatch_once(&Static.onceToken) {
            Static.instance = ApiManager()
        }
        return Static.instance!
    }
    //首页获取所有Mind
    func mindAll (str: String, andClosure: (AnyObject) -> () , failure:  (NSError) -> ()) {
        var url: String = "http://mindstore.io/"
        if str != "" {
            url = url + str
        }else{
            url = url + "api/v1.2/mind"
        }
        self.get(url, parameters: "",  success: {
                (result:AnyObject) -> () in
                    andClosure(result)
            },  failure: {
                (error:NSError) -> () in
                    failure(error)
        })
    }
    
    
    
    
    /** post 方法发送请求 */
    func get (url:String, parameters: String, success: ((AnyObject) -> ()), failure: ((NSError) -> ())) {

        //检查网络
        let reachability = Reachability.reachabilityForInternetConnection()
        println(reachability.currentReachabilityStatus);
        if reachability.currentReachabilityStatus == Reachability.NetworkStatus.NotReachable {
            println("网络已经断开");
            self.showStatusBarErrorStr("网络已经断开")
            
            
            var error: NSError?
            error = NSError(domain: "", code: -1, userInfo: ["NETWORK":"NOT"])
            
            failure(error!)
            return
        }
        
//        reachability.whenReachable = { reachability in
//            if reachability.isReachableViaWiFi() {
//                println("Reachable via WiFi")
//            } else {
//                println("Reachable via Cellular")
//            }
//        }
//        reachability.whenUnreachable = { reachability in
//            println("Not reachable")
//            return
//        }
        reachability.startNotifier()
        // 发送请求
        let request = Alamofire.request(.GET, "http://mindstore.io/api/v1.2/mind/")
            .responseJSON { _, response, json, error in
                if (error != nil) {
                    failure(error!)
                }else {
                    success(json!)
                }
            }
        // debugPrintln(request)
    }

    func showStatusBarErrorStr(tipStr: String) {
        if JDStatusBarNotification.isVisible() {
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (Int64)(1 * NSEC_PER_SEC)), dispatch_queue_t(), { () -> Void in
                JDStatusBarNotification.showActivityIndicator(false, indicatorStyle: UIActivityIndicatorViewStyle.White)
                JDStatusBarNotification.showWithStatus(tipStr, dismissAfter: 2.5, styleName: JDStatusBarStyleError)
            })
        }else{
            JDStatusBarNotification.showActivityIndicator(false, indicatorStyle: UIActivityIndicatorViewStyle.White)
            JDStatusBarNotification.showWithStatus(tipStr, dismissAfter: 2.0, styleName: JDStatusBarStyleError)
        }
    
    }
}

