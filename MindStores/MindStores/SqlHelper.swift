//
//  SqlHelper.swift
//  MindStores
//
//  Created by sue on 15/7/29.
//  Copyright (c) 2015年 sue. All rights reserved.
//

import Foundation

class SqlHelper: NSObject {
    
    var path:String!
    var db: FMDatabase!
    
    func openDatabase(){
        var pa: [AnyObject] = NSSearchPathForDirectoriesInDomains( NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.UserDomainMask, true)
        var document: String = pa[0] as! String
        path = document.stringByAppendingPathComponent("MindStoreIndex.sqlite")
        if db == nil {
            db = FMDatabase(path: path)
        }
        db.open()
    }
    
    func removeTable() {
        if db == nil  {
            self.openDatabase()
        }
        var sql_st = "DROP TABLE MIND"
        db.executeStatements(sql_st)
    }
    
    func createTable() {
        if db == nil  {
            self.openDatabase()
        }
        db.setShouldCacheStatements(true)
        if (!db.tableExists("mind")) {
            var sql_st = "CREATE TABLE IF NOT EXISTS MIND (id,lime_avatar_url Text,title Text,vote_count Text,tagline Text )"
            if db.executeStatements(sql_st) {
                println("Error\(db.lastErrorMessage())")
            }
//            db.close()
        }
        
    }
    
    func insert(mind: MindModel) {
        var sql = "INSERT INTO MIND(id,lime_avatar_url, title, vote_count, tagline) VALUES(?,?,?,?,?)"
        self.openDatabase()
        var a =  [mind.id, mind.created_by["lime_avatar_url"], mind.title, mind.vote_count, mind.tagline]
        db.executeUpdate(sql, withArgumentsInArray: a as! [AnyObject])
        db.close()
    }
    
    func update(mind: MindModel) {
        var sql = "UPDATE MIND set created_by=?, title=?, vote_count=?, tagline=?"
        self.openDatabase()
//        db.executeUpdate(sql, withArgumentsInArray:  [mind.created_by["lime_avatar_url"], mind.title, mind.vote_count, mind.tagline] as Array )
        db.close()
    }
    
    func remove(id: String) {
        var sql = "DELETE FROM MIND WHERE id = ?"
        self.openDatabase()
        db.executeUpdate(sql, withArgumentsInArray: [id])
        db.close()
    }
    
    func removeALl() {
        var sql = "DELETE FROM MIND"
        self.openDatabase()
        db.executeUpdate(sql, withArgumentsInArray: nil)
        db.close()
    }
    
    func insertAll(arr: [MindModel]) {
//        var queue: FMDatabaseQueue = FMDatabaseQueue(path: path)
    
        
//        queue.inTransaction{ (db: FMDatabase!, rollback: Bool) -> Void in
//            var sql:String!,sqlT: [AnyObject]
//            for mind in arr {
//                sql = "INSERT INTO MIND(id,lime_avatar_url, title, vote_count, tagline) VALUES(?,?,?,?,?)"
//                sqlT =  [mind.id, mind.created_by["lime_avatar_url"], mind.title, mind.vote_count, mind.tagline]
//                db.executeUpdate(sql, withArgumentsInArray: sqlT)
//            }
//            if (whoopsSomethingWrongHappened) {
//                rollback = true;
//                return;
//            }
//
//
        self.removeALl()
        self.openDatabase()
        //开启一个事务
        for mind in arr {
            var sql = "INSERT INTO MIND(id,lime_avatar_url, title, vote_count, tagline) VALUES(?,?,?,?,?)"
            var a : [AnyObject] = Array()
            [mind.id, mind.created_by["lime_avatar_url"], mind.title, mind.vote_count, mind.tagline]
            a.append(mind.id)
            a.append(mind.created_by["lime_avatar_url"]!)
            a.append(mind.title)
            a.append(mind.vote_count)
            a.append(mind.tagline)
            db.executeUpdate(sql, withArgumentsInArray: a)
        }
        
        
        db.close()
    }
    
    func hasMindData() -> [MindModel] {
        var sql = "SELECT * FROM MIND"
        self.createTable()
        var rs = db.executeQuery(sql, withArgumentsInArray: nil)
        var array: [MindModel] = Array()
        if rs != nil{
            while rs.next() {
                var mind = MindModel()
                mind.id = Int( rs.intForColumn("id"))
//                mind.created_by.setValue(rs.stringForColumn("lime_avatar_url"), forKey: "lime_avatar_url")
                mind.tagline = rs.stringForColumn("tagline")
                mind.vote_count = Int( rs.intForColumn("vote_count"))
                mind.title = rs.stringForColumn("title")
                array.append(mind)
            }
        }
        rs.close()
        return array
    }
    
}
