//
//  UserValidityServiceTests.swift
//  DomainOAuthTests
//
//  Created by 황인우 on 5/31/24.
//

import Combine
import XCTest

@testable import CoreNetworkInterface
@testable import CoreLocalStorageInterface
@testable import DomainOAuth
@testable import DomainOAuthInterface
@testable import DomainOAuthTesting
@testable import SharedUtil

final class UserValidityServiceTests: XCTestCase {
    var sut: UserValidityService!
    
    override func setUpWithError() throws {}

    override func tearDownWithError() throws {
        sut = nil
    }

    func test_유저_유효성_체크시_내부에_저장되어있는_토큰이_유효하다면_true를_반환한다() throws {
        // given
        let expectedResponse = UserValidityResponse(
            message: "액세스 토큰이 유효합니다.",
            data: .init(
                isValid: true,
                expirationDate: Calendar.current.date(byAdding: .day, value: 1, to: Date())!
            )
        )
        let mockNetworkProvider = MockNetworkProvider(
            response: expectedResponse,
            error: nil
        )
        
        let mockTokenStorage = MockTokenStorage()
        
        sut = UserValidityService(
            networkProvider: mockNetworkProvider,
            tokenStorage: mockTokenStorage
        )
        
        // when
        let result = try awaitPublisher(sut.isUserValid())
        
        // then
        XCTAssertTrue(result)
    }
    
    func test_유저_유효성_체크시_내부에_저장되어있는_토큰이_유효하지_않다면_true를_반환한다() throws {
        let expectedResponse = UserValidityResponse(
            message: "액세스 토큰이 유효하지 않습니다.",
            data: .init(
                isValid: false,
                expirationDate: Calendar.current.date(byAdding: .day, value: 1, to: Date())!
            )
        )
        let mockNetworkProvider = MockNetworkProvider(
            response: expectedResponse,
            error: nil
        )
        
        let mockTokenStorage = MockTokenStorage()
        
        sut = UserValidityService(
            networkProvider: mockNetworkProvider,
            tokenStorage: mockTokenStorage
        )
        
        // when
        let result = try awaitPublisher(sut.isUserValid())
        
        // then
        XCTAssertFalse(result)
    }
}
