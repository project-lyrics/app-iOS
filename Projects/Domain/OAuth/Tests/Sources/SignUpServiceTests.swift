//
//  SignUpServiceTests.swift
//  DomainOAuthTests
//
//  Created by 황인우 on 9/1/24.
//

import Combine
import XCTest

@testable import CoreNetworkInterface
@testable import CoreLocalStorageInterface
@testable import DomainOAuth
@testable import DomainOAuthInterface
@testable import DomainOAuthTesting
@testable import SharedUtil

final class SignUpServiceTests: XCTestCase {
    var sut: SignUpService!
    
    private let expectedAccessToken: String = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzb21lIjoicGF5bG9hZCIsImV4cCI6MTcxNzIwMDAwMC4wfQ.kNeDhxHkCxWFanC-pTc-oY047ec5JVtk9qQWSBnNUcM"
    
    private let expectedRefreshToken: String = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzb21lIjoicGF5bG9hZCIsImV4cCI6MTcxNzIwMDAwMC4wfQ.kNeDhxHkCxWFanC-pTc-oY047ec5JVtk9qQWSBnNUcM"

    override func setUpWithError() throws {}

    override func tearDownWithError() throws {
        sut = nil
    }

    func test_회원가입시_유저_id가_정상적으로_저장된다() throws {
        // given
        let expectedUserId = 1321
        
        let mockNetworkProvider = MockNetworkProvider(
            response: UserAuthResponse(
                accessToken: expectedAccessToken,
                refreshToken: expectedRefreshToken,
                userId: expectedUserId
            ),
            error: nil
        )
        
        let dummyTokenStorage = FakeTokenStorage()
        try dummyTokenStorage.save(token: AccessToken(token: expectedAccessToken, expiration: .init()), for: "FakeTokenStorage")
        
        let fakeUserInfoStorage = FakeUserInfoStorage()
        
        sut = SignUpService(
            networkProvider: mockNetworkProvider,
            tokenStorage: dummyTokenStorage,
            userInfoStorage: fakeUserInfoStorage,
            tokenKeyHolder: MockTokenKeyHolder(
                expectedAccessTokenKey: "mockAccessTokenKey",
                expectedRefreshTokenKey: "mockRefreshTokenKey"
            )
        )
        
        // when
        let _ = try awaitPublisher(sut.signUp(.init()))
        
        // then
        XCTAssertEqual(fakeUserInfoStorage.userInfo?.userID, expectedUserId)
    }
}
