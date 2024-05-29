//
//  JWTDecoderTests.swift
//  DomainOAuthTests
//
//  Created by 황인우 on 5/28/24.
//

import XCTest

@testable import DomainOAuthInterface
@testable import CoreLocalStorageInterface
@testable import SharedUtil

final class JWTDecoderTests: XCTestCase {
    private var sut: JWTDecoder!
    
    override func setUpWithError() throws {
        self.sut = .init()
    }

    override func tearDownWithError() throws {
        self.sut = nil
    }
    
    func test_올바른_형식의_JWT를_전달받을_때_만료날짜가_정상적으로_파싱된다() throws {
        // given
        let accessTokenStub: String = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzb21lIjoicGF5bG9hZCIsImV4cCI6MTcxNzIwMDAwMH0.noU5x_29jiylF_FBIu9QzHvhkjVITjIw1qq7cXokPAE"
        
        var calendar = Calendar.current
        calendar.timeZone = TimeZone(secondsFromGMT: 0)! // UTC 시간대 설정
        
        let expectedExpDate = DateComponents(
            calendar: calendar,
            year: 2024,
            month: 6,
            day: 1
        ).date!
        
        // when
        let decodedToken = try sut.decode(
            accessTokenStub,
            as: AccessToken.self
        )
        
        // then
        
        // 파싱된 토큰의 만료기간과 서버로부터 받은 JWT의 만료기간은 동일해야 한다.
        XCTAssertEqual(decodedToken.expiration, expectedExpDate)
        
        // 서버로부터 받은 JWTString값과 파싱된 토큰의 token변수 값은 동일해야 한다.
        XCTAssertEqual(decodedToken.token, accessTokenStub)
    }
    
    func test_잘못된_형식의_JWT를_전달받을때_invalidFormat에러를_내뱉는다() throws {
        // given
        let invalidFormatToken: String = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9malformedpayload"
        
        // when
        XCTAssertThrowsError(try sut.decode(invalidFormatToken, as: AccessToken.self), "token error", { error in
            // then
            XCTAssertEqual(error as? JWTError, JWTError.invalidFormat)
        })
    }
    
    func test_JWT의_payload_decoding을_실패할경우_decodePayloadSegmentError를_내뱉는다() {
        // given
        let invalidFormatToken: String = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.&%$fdser56.invalidsignature"
        
        // when
        XCTAssertThrowsError(try sut.decode(invalidFormatToken, as: AccessToken.self), "", { error in
            XCTAssertEqual(error as? JWTError, JWTError.decodePayloadSegmentError)
        })
    }
    
    func test_JWT의_payload부분이_잘못된_json형식일_때_parsePayloadJSONError를_내뱉는다() {
        // given
        let invalidFormatToken: String = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpbnZhbGlkX2pzb24ifQ.invalidsignature"
        
        // when
        XCTAssertThrowsError(try sut.decode(invalidFormatToken, as: AccessToken.self), "", { error in
            XCTAssertEqual(error as? JWTError, JWTError.parsePayloadJSONError)
        })
    }
}
