//
//  FormattedDateTests.swift
//  SharedUtilTests
//
//  Created by 황인우 on 12/27/24.
//

@testable import SharedUtil

import XCTest

private extension String {
    func toDate(format: String = "yyyy-MM-dd HH:mm:ss") -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        
        if let date = dateFormatter.date(from: self) {
            return date
        } else {
            return nil
        }
    }
}

final class FormattedDateTests: XCTestCase {
    func test_날짜_차이가_1분_이내인경우_방금전_으로_표기된다() {
        let expectedDate = "2024-12-27 21:20:00".toDate()!
        let mockToday = "2024-12-27 21:20:59".toDate()!
        // 59초 차이
        
        XCTAssertEqual(expectedDate.formattedTimeInterval(mockToday), "방금 전")
    }
    
    func test_날짜_차이가_1분_에서_60분_이하인_경우_n분전_으로_표기된다() {
        let expectedDate = "2024-12-27 21:19:55".toDate()!
        let mockToday = "2024-12-27 21:20:55".toDate()!
        // 1분차이
        
        XCTAssertEqual(expectedDate.formattedTimeInterval(mockToday), "1분 전")
        
        let expectedDate2 = "2024-12-27 20:20:56".toDate()!
        // 59분 59초 차이
        
        XCTAssertEqual(expectedDate2.formattedTimeInterval(mockToday), "59분 전")
    }
    
    func test_날짜_차이가_1시간_에서_24_시간_이내일_경우_n시간전_으로_표기된다() {
        let expectedDate = "2024-12-27 20:20:55".toDate()!
        let mockToday = "2024-12-27 21:20:55".toDate()!
        
        // 1시간 차이
        XCTAssertEqual(expectedDate.formattedTimeInterval(mockToday), "1시간 전")
        
        
        let expectedDate2 = "2024-12-27 00:20:55".toDate()!
        XCTAssertEqual(expectedDate2.formattedTimeInterval(mockToday), "21시간 전")
        
        let expectedDate3 = "2024-12-26 21:20:56".toDate()!
        // 23시간 59분 59초 차이
        XCTAssertEqual(expectedDate3.formattedTimeInterval(mockToday), "23시간 전")
    }
    
    func test_7일까지_날짜인경우_n일전_날짜로_표기된다() {
        let expectedDate = "2024-12-26 21:20:55".toDate()!
        
        let mockToday = "2024-12-27 21:20:55".toDate()!
        
        XCTAssertEqual(expectedDate.formattedTimeInterval(mockToday), "1일 전")
        
        let expectedDate2 = "2024-12-21 21:20:50".toDate()!
        XCTAssertEqual(expectedDate2.formattedTimeInterval(mockToday), "6일 전")
        
        let expectedDate3 = "2024-12-20 21:20:54".toDate()!
        XCTAssertEqual(expectedDate3.formattedTimeInterval(mockToday), "7일 전")
    }
    
    func test_7일_이후_날짜인경우_yyMMddHHmm_날짜로_표기된다() {
        let expectedDate = "2024-12-19 20:37:55".toDate()!
        let mockToday = "2024-12-27 20:37:56".toDate()!
        
        XCTAssertEqual(expectedDate.formattedTimeInterval(mockToday), "24.12.19 20:37")
    }
}
