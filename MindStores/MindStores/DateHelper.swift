//
//  DateHelper.swift
//  MindStores
//
//  Created by sue on 15/7/24.
//  Copyright (c) 2015年 sue. All rights reserved.
//

import Foundation

class DateHelper: NSObject {
    
    let Weeks = ["一", "二", "三", "四", "五", "六", "日"]
    
    func toTime (stamp: String, parse: String) -> String {
        var outputFormat = NSDateFormatter()
        outputFormat.dateFormat = parse //格式化规则
        let pubTime = NSDate(timeIntervalSince1970: NSString(string: stamp).doubleValue)
        return outputFormat.stringFromDate(pubTime)
    }
    func isSameDay(stamp1: String, stamp2: String) -> Bool {
        var s1 = self.toTime(stamp1, parse: "yyyy-MM-dd")
        var s2 = self.toTime(stamp2, parse: "yyyy-MM-dd")
        if s1 == s2 {
            return true
        }
        return false
    }
    func formatToStr(stamp: String) -> String {
        var str = self.toTime(stamp, parse: "yyyy-MM-dd")
        //获取当前日期
        var nowDate = NSDate()
        var formatter = NSDateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        var nowDateStr = formatter.stringFromDate(nowDate)
        //获取年月日
        var year = self.getYearMD(str, format: 0)
        var month = self.getYearMD(str, format: 1)
        var day = self.getYearMD(str, format: 2)
        var week = self.getYearMD(str, format: 3)
        
        if str == nowDateStr {
            return "今天  \(month)月\(day)日"
        }else if self.isYesterday(nowDate, str: str)  {
            return "昨天  \(month)月\(day)日"
        }else {
            return "星期\(Weeks[week-1]) \(month)月\(day)日"
        }
    }
    // 判断是否是昨天
    func isYesterday (nowDate: NSDate, str: String) -> Bool {
        var secondsPerDay:NSTimeInterval = 24 * 60 * 60;
        var yesterday = nowDate.dateByAddingTimeInterval(-secondsPerDay)
        var yesterdayString:String = (yesterday.description as NSString).substringToIndex(10)
        if yesterdayString == str {
            return true
        }
        return false
    }
    //获取年，月，日,星期---0，1，2，3
    func getYearMD (str:String, format:Int) -> Int {
        var cal = NSCalendar.currentCalendar()
        var unitFlags:NSCalendarUnit = NSCalendarUnit()
        if format == 0 {
             unitFlags =  NSCalendarUnit.CalendarUnitYear
        }else if format == 1 {
             unitFlags =  NSCalendarUnit.CalendarUnitMonth
        }else if format == 2 {
             unitFlags =  NSCalendarUnit.CalendarUnitDay
        }else if format == 3 {
            unitFlags =  NSCalendarUnit.CalendarUnitWeekday
        }
        var formatter1 = NSDateFormatter()
        formatter1.dateFormat = "yyyy-MM-dd"
        var com:NSDateComponents = cal.components(unitFlags, fromDate: formatter1.dateFromString(str)!)
        
        if format == 0 {
            return com.year
        }else if format == 1 {
            return com.month
        }else if format == 2 {
            return com.day
        }else {
            return com.weekday
        }
    }
    
}
