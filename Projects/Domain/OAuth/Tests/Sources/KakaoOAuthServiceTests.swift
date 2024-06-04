//
//  KakaoOAuthServiceTests.swift
//  DomainOAuthTests
//
//  Created by 황인우 on 5/28/24.
//

import Combine
import XCTest

@testable import CoreNetworkInterface
@testable import CoreLocalStorageInterface
@testable import DomainOAuth
@testable import DomainOAuthInterface
@testable import DomainOAuthTesting
@testable import SharedUtil

final class KakaoOAuthServiceTests: XCTestCase {
    private var cancellables: Set<AnyCancellable>!
    private var kakaoUserAPITestDouble: MockKakaoUserAPI!
    private var networkProviderTestDouble: NetworkProviderInterface!
    private var sut: OAuthServiceInterface!
    
    private let expectedAccessToken: String = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzb21lIjoicGF5bG9hZCIsImV4cCI6MTcxNzIwMDAwMC4wfQ.kNeDhxHkCxWFanC-pTc-oY047ec5JVtk9qQWSBnNUcM"
    
    private let expectedRefreshToken: String = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzb21lIjoicGF5bG9hZCIsImV4cCI6MTcxNzIwMDAwMC4wfQ.kNeDhxHkCxWFanC-pTc-oY047ec5JVtk9qQWSBnNUcM"
    
    override func setUpWithError() throws {
        kakaoUserAPITestDouble = MockKakaoUserAPI(
            oAuthToken: KakaoOAuthToken(
                accessToken: "DummyKakaoAccessToken",
                tokenType: "",
                refreshToken: "DummyKakaoRefreshToken",
                scope: nil,
                scopes: nil
            ),
            error: nil
        )
        
    }

    override func tearDownWithError() throws {
        cancellables = nil
        kakaoUserAPITestDouble = nil
        networkProviderTestDouble = nil
        sut = nil
    }

    func test_카카오_로그인_성공() throws {
        // given
        networkProviderTestDouble = MockNetworkProvider(
            response: UserLoginResponse(
                status: "201",
                data: TokenResponse(
                    accessToken: expectedAccessToken,
                    refreshToken: expectedRefreshToken
                )
            ),
            error: nil
        )
        let mockTokenStorage = MockTokenStorage()
        
        sut = KakaoOAuthService(
            kakaoUserAPI: kakaoUserAPITestDouble,
            networkProvider: networkProviderTestDouble,
            tokenStorage: mockTokenStorage
        )

        // when
        let result = try awaitPublisher(sut.login())

        // then
        XCTAssertEqual(result.oAuthType, .kakaoLogin)
        XCTAssertTrue(mockTokenStorage.saveCalled)
        // 전달받은 accessToken, refreshToken을 저장해야 하니 총 저장횟수는 2번이어야 한다.
        XCTAssertEqual(mockTokenStorage.saveResultCount, 2)
    }

    func test_카카오_로그인_실패() throws {
        // given
        kakaoUserAPITestDouble.error = KakaoOAuthError.ClientFailed(reason: .TokenNotFound, errorMessage: "Mock error")
        networkProviderTestDouble = MockNetworkProvider(
            response: UserLoginResponse(
                status: "401",
                data: TokenResponse(
                    accessToken: expectedAccessToken,
                    refreshToken: expectedRefreshToken
                )
            ),
            error: nil
        )
        let dummyTokenStorage = FakeTokenStorage()
        
        sut = KakaoOAuthService(
            kakaoUserAPI: kakaoUserAPITestDouble,
            networkProvider: networkProviderTestDouble,
            tokenStorage: dummyTokenStorage
        )

        // when
        XCTAssertThrowsError(
            try awaitPublisher(sut.login()),
            "Expected Kakao SDK error"
        ) { error in
            // then
            guard case AuthError.kakaoOAuthError = error else {
                return XCTFail("Expected Kakao SDK error")
            }
        }
    }
}
