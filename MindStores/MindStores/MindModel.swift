//
//  MindModel.swift
//  MindStores
//
//  Created by sue on 15/7/29.
//  Copyright (c) 2015年 sue. All rights reserved.
//

import Foundation
class MindModel: NSObject {
    var comment_count: Int = 0
    var created_at: Int = 0
    var created_by: NSDictionary = [:]
    //"company","email", "id","lime_avatar_url","lime_home_url","nickname","position", "userprofile", "weibo_uid"
    var id: Int = 0
    var is_auto_refresh: Int = 0
    var link: String = ""
    var priority: Int = 0
    var producer_participated: Bool = false
    var related_image: [String] = []
    var related_link: [String] = []
    var tagline: String = ""
    var title: String = ""
    var vote_count: Int = 0
    var vote_user_count: Int = 0
    var voted_id: String = ""
    
    func set(objects:NSDictionary) {
        comment_count = (objects["comment_count"] == nil ? 0 : objects["comment_count"]) as! Int
        created_at = (objects["created_at"] == nil ? 0 : objects["created_at"]) as! Int
        created_by = objects["created_by"] as! NSDictionary
        id = objects["comment_count"] as! Int
        is_auto_refresh = objects["is_auto_refresh"] as! Int
        link = objects["link"] as! String
        priority = (objects["priority"] == nil ? 0 : objects["priority"]) as! Int
        producer_participated = objects["producer_participated"] as! Bool
        related_image = objects["related_image"] as! [String]
        related_link = objects["related_link"] as! [String]
        tagline = objects["tagline"] as! String
        title = objects["title"] as! String
        vote_count = objects["vote_count"] as! Int
        vote_user_count = objects["vote_user_count"] as! Int
        voted_id = objects["voted_id"] as! String
    }
}
