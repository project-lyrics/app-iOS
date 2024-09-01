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
        let expectedResponse = FeelinDefaultResponse(status: true)
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
        try awaitPublisher(sut.isUserValid())
        
        // then
        // void값을 리턴하는데 이를 어떻게 테스트할지 추후 고민 해 봐야 한다.
    }
    
    func test_유저_유효성_체크시_내부에_저장되어있는_토큰이_유효하지_않다면_에러를_반환한다() throws {
        let expectedError = FeelinAPIError(
            apiFailResponse: .init(errorCode: "01004",
            errorMessage: "토큰이 유효하지 않습니다.")
        )
        let mockNetworkProvider = MockNetworkProvider(
            response: nil,
            error: NetworkError.feelinAPIError(expectedError)
        )
        
        let fakeTokenStorage = FakeTokenStorage()
        let mockTokenKeyHolder = MockTokenKeyHolder(
            expectedAccessTokenKey: "mockAccessTokenKey",
            expectedRefreshTokenKey: "MockRefreshTokenKey"
        )
        try fakeTokenStorage.save(
            token: AccessToken(token: "1234",
            expiration: .init()),
            for: "mockAccessTokenKey"
        )
        
        sut = UserValidityService(
            networkProvider: mockNetworkProvider,
            tokenStorage: fakeTokenStorage,
            tokenKeyHolder: mockTokenKeyHolder
        )
        
        // when
        XCTAssertThrowsError(try awaitPublisher(sut.isUserValid()), "tokenError", { error in
            
            // then
            XCTAssertEqual(
                error as? AuthError,
                AuthError.networkError(.feelinAPIError(.tokenIsExpired(errorCode: "01004",
                errorMessage: "토큰이 유효하지 않습니다.")))
            )
        })
    }
}
