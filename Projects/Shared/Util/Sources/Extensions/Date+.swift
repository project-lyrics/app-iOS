//
//  Date+.swift
//  SharedUtil
//
//  Created by 황인우 on 8/18/24.
//

import Foundation

/// 2025.01.19. 기획명세서 요구사항
/// 알림 및 노트 작성 시간 동일
/// 00:00:00 ~ 00:00:59 -  ""방금 전""
/// 00:01:00 ~ 00:59:59 - ""n분 전"" ex. 59분 전
/// 01:00:00 ~ 23:59:59 -  ""n시간 전"" ex. 23시간 전
/// 등록 후 24시간 경과 (1일) ~ 7일차 23:59:59 - ""n일 전"" ex. 7일 전
/// 그 이후 - ""yy.mm.dd hh:mm"" ex. 24.07.23 13:01

public extension Date {
    func formattedTimeInterval(_ distanceToDate: Date = Date()) -> String {
        let timeInterval = self.distance(to: distanceToDate)  // self부터 toDate까지의 시간 차이
        
        let minute: TimeInterval = 60
        let hour: TimeInterval = minute * 60
        let day: TimeInterval = hour * 24
        let week: TimeInterval = day * 7
        
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
        case day..<(week + day):
            let days = Int(timeInterval / day)
            return "\(days)일 전"
            
        default:
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yy.MM.dd HH:mm"
            return dateFormatter.string(from: self)
        }
    }
}
