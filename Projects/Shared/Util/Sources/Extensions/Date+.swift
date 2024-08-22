//
//  Date+.swift
//  SharedUtil
//
//  Created by 황인우 on 8/18/24.
//

import Foundation

public extension Date {
    func formattedTimeInterval() -> String {
        let now = Date()
        let calendar = Calendar.current
        let components = calendar.dateComponents(
            [.year,
             .month,
             .day,
             .hour,
             .minute,
             .second],
            from: self,
            to: now
        )
        
        if let seconds = components.second, seconds < 60 {
            return "방금 전"
        }
        
        if let minutes = components.minute, minutes > 0, minutes < 60 {
            return "\(minutes)분 전"
        }
        
        if let hours = components.hour, hours > 0, hours < 24 {
            return "\(hours)시간 전"
        }
        
        if let days = components.day, days > 0, days <= 7 {
            return "\(days)일 전"
        }
        
        // 7일 이상 경과한 경우
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yy.MM.dd HH:mm"
        return dateFormatter.string(from: self)
    }
}
