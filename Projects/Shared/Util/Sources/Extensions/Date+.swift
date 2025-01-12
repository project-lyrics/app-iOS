//
//  Date+.swift
//  SharedUtil
//
//  Created by 황인우 on 8/18/24.
//

import Foundation

public extension Date {
    func formattedTimeInterval(_ distanceToDate: Date = Date()) -> String {
        let timeInterval = self.distance(to: distanceToDate)  // self부터 toDate까지의 시간 차이
        
        let minute: TimeInterval = 60
        let hour: TimeInterval = minute * 60
        let day: TimeInterval = hour * 24
        let week: TimeInterval = day * 7 + hour * 24
        
        switch timeInterval {
        case 0..<minute:
            return "방금 전"
            
        case minute..<hour:
            let minutes = Int(timeInterval / minute)
            return "\(minutes)분 전"
            
        case hour..<day:
            let hours = Int(timeInterval / hour)
            return "\(hours)시간 전"
            
        // 7일 23:59:59까지
        case day...week:
            let days = Int(timeInterval / day)
            return "\(days)일 전"
            
        default:
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yy.MM.dd HH:mm"
            return dateFormatter.string(from: self)
        }
    }
}
