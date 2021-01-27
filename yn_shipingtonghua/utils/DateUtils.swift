//
//  DataUtils.swift
//  yn_shipingtonghua
//
//  Created by 陈军 on 2021/1/27.
//

import Foundation

class DateUtils {
    
    //MARK: 获取当前时间的时间戳的两种方法(秒为单位)
      static  func getNowTimeStamp() -> String {
            let formatter = DateFormatter()
            formatter.dateStyle = .medium
            formatter.timeStyle = .short
            formatter.dateFormat = "YYYY-MM-dd HH:mm:ss"//设置时间格式；hh——>12小时制， HH———>24小时制
            
            //设置时区
            let timeZone = TimeZone.init(identifier: "Asia/Shanghai")
            formatter.timeZone = timeZone
            
            let dateNow = Date()//当前的时间
            
            //当前时间戳
            let timeStamp = String.init(format: "%ld", Int(dateNow.timeIntervalSince1970))
            
            return timeStamp
        }
        
        //方法2：获取当前时间的时间戳(秒为单位)
       static func getNowTimeStamp2() -> String {
            let date = Date(timeIntervalSinceNow: 0)
            let a = date.timeIntervalSince1970
            let timeStamp = String.init(format: "%.f", a)
            return timeStamp
        }
        
        //MARK: 获取当前时间的时间戳(毫秒Millisecond为单位)
      static  func getNowTimeStampMillisecond() -> String {
            let formatter = DateFormatter()
            formatter.dateStyle = .medium
            formatter.timeStyle = .short
            formatter.dateFormat = "YYYY-MM-dd HH:mm:ss SSS"//设置时间格式；hh——>12小时制， HH———>24小时制
            
            //设置时区
            let timeZone = TimeZone.init(identifier: "Asia/Shanghai")
            formatter.timeZone = timeZone
            
            let dateNow = Date()//当前时间
            let timeStamp = String.init(format: "%ld", Int(dateNow.timeIntervalSince1970) * 1000)
            return timeStamp
        }
    
    // 时间戳转换成Date
    static func timestampWithDate(timeInterval:TimeInterval) -> Date {
        let date = Date.init(timeIntervalSince1970: timeInterval)
        let zone = NSTimeZone.system
        let interval = zone.secondsFromGMT(for: date)
        let localeDate = date.addingTimeInterval(TimeInterval(interval))
        return localeDate
    }
    
    // 获取当前时区的Date
    static func getCurrentDate() -> Date {
        let nowDate = Date()
        let zone = NSTimeZone.system
        let interval = zone.secondsFromGMT(for: nowDate)
        let localeDate = nowDate.addingTimeInterval(TimeInterval(interval))
        return localeDate
     }
}

extension Date {

   /// 获取当前 秒级 时间戳 - 10位
   var timeStamp : TimeInterval {
       let timeInterval: TimeInterval = self.timeIntervalSince1970
       let timeStamp = Int(timeInterval)
    return TimeInterval(timeStamp)
   }

   /// 获取当前 毫秒级 时间戳 - 13位
   var milliStamp : TimeInterval {
       let timeInterval: TimeInterval = self.timeIntervalSince1970
       let millisecond = CLongLong(round(timeInterval*1000))
    return TimeInterval(millisecond)
   }
    
    // 时间戳转换成Date  只能是10位时间戳
    func timestampWithDate(timeInterval:TimeInterval) -> Date {
        let date = Date.init(timeIntervalSince1970: timeInterval)
        let zone = NSTimeZone.system
        let interval = zone.secondsFromGMT(for: date)
        let localeDate = date.addingTimeInterval(TimeInterval(interval))
        return localeDate
    }
}
