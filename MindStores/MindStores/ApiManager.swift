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
    func mindAll (parameters: String, andClosure: (AnyObject) -> () , failure:  (NSError) -> ()) {
        
        self.post("http://mindstore.io/api/v1.2/mind/schema/", parameters: parameters,  success: {
                (result:AnyObject) -> () in
                    andClosure(result)
            },  failure: {
                (error:NSError) -> () in
                    failure(error)
        })
    }
    
    
    
    
    /** post 方法发送请求 */
    func post (url:String, parameters: String, success: ((AnyObject) -> ()), failure: ((NSError) -> ())) {
        //检查网络
        let reachability = Reachability.reachabilityForInternetConnection()
        reachability.whenReachable = { reachability in
            if reachability.isReachableViaWiFi() {
                println("Reachable via WiFi")
            } else {
                println("Reachable via Cellular")
            }
        }
        reachability.whenUnreachable = { reachability in
            println("Not reachable")
            return
        }
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
   

    
}

