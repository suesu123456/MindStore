//
//  UserModel.swift
//  MindStores
//
//  Created by sue on 15/7/27.
//  Copyright (c) 2015年 sue. All rights reserved.
//

import Foundation

class UserModel: NSObject {
    
    
   static func isLogin() -> Bool {
     
        var loginStatus: AnyObject? = NSUserDefaults.standardUserDefaults().objectForKey("login_status")
        if loginStatus!.boolValue! {
            return true
        }else{
            return false
        }
    }
}
