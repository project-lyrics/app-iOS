//
//  UserValidityIntegrationTests.swift
//  DomainOAuthTests
//
//  Created by 황인우 on 5/31/24.
//

@testable import CoreLocalStorage
@testable import CoreLocalStorageInterface
@testable import DomainOAuthInterface
@testable import DomainOAuth
@testable import CoreNetworkInterface
@testable import CoreNetwork
@testable import CoreNetworkTesting
@testable import SharedUtil

import Combine
import XCTest

final class UserValidityIntegrationTests: XCTestCase {
    var sut: UserValidityService!
    var networkProvider: NetworkProvider!
    var fakeTokenStorage: FakeTokenStorage!
    
    override func setUpWithError() throws {
        let config = URLSessionConfiguration.ephemeral
        config.protocolClasses = [CountableMockURLProtocol.self]
        let urlSession = URLSession(configuration: config)
        
        let dummyAccessToken = AccessToken(
            token: "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.e30.dQw4w9WgXcQ",
            expiration: Calendar.current.date(
                byAdding: .day,
                value: 1,
                to: .init()
            )!
        )
        
        let dummyRefreshToken = RefreshToken(
            token: "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.e30.RmlZaDFvSG1NeUQ",
            expiration: Calendar.current.date(
                byAdding: .day,
                value: 14,
                to: .init()
            )!
        )
        
        fakeTokenStorage = .init(
            storage: [
                "FeelinAccessTokenKey": dummyAccessToken,
                "FeelinRefreshTokenKey": dummyRefreshToken
            ]
        )
        
        let tokenInterceptor = TokenInterceptor(tokenStorage: fakeTokenStorage)
        
        let networkSession = NetworkSession(
            urlSession: urlSession,
            requestInterceptor: tokenInterceptor
        )
        
        networkProvider = NetworkProvider(networkSession: networkSession)
        
        sut = UserValidityService(
            networkProvider: networkProvider,
            tokenStorage: fakeTokenStorage
        )
    }

    override func tearDownWithError() throws {
        sut = nil
        networkProvider = nil
    }

    func test_토큰이_만료되면_재발급요청을_한뒤_재발급_받은_토큰을_활용하면_사용자인증에_성공한다() throws {
        // given
        CountableMockURLProtocol.requestHandlers = [
            { firstRequest in
                let mockResponse = HTTPURLResponse(
                    url: firstRequest.url!,
                    statusCode: 401,
                    httpVersion: nil,
                    headerFields: nil
                )!
                
                let mockData =
                """
                    {
                        "errorCode" : "00401",
                        "errorMessage" : "액세스 토큰이 유효하지 않습니다."
                    }
                """.data(using: .utf8)!
                
                return (mockResponse, mockData)
            },
            { requestOnReissueToken in
                let mockResponse = HTTPURLResponse(
                    url: requestOnReissueToken.url!,
                    statusCode: 201,
                    httpVersion: nil,
                    headerFields: nil
                )!
                
                let mockData =
                """
                    {
                        "message" : "액세스 토큰이 재발급되었습니다.",
                        "data": {
                            "accessToken": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiIxMjM0NTY3ODkwIiwibmFtZSI6IkpvaG4gRG9lIiwiaWF0IjoxNjg1NjA4MDAwLCJleHAiOjE3MTcwNDUyMDB9.ZsTGkCZQizZDC8E4K9nmdsk7KZJz0LbG-C5n7A2KbBs",
                            "refreshToken": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiI1Njc4OTAxMjM0IiwibmFtZSI6IkphbmUgRG9lIiwiaWF0IjoxNjg1NjA4MDAwLCJleHAiOjE3MTcwNDUyMDB9.pE12rWqpm0Oa1owwymenRzg1YwE-AidcTWw1BrH6Kx8"
                        }
                    }
                """.data(using: .utf8)!
                
                return (mockResponse, mockData)
            },
            { requestWithReissueToken in
                let mockResponse = HTTPURLResponse(
                    url: requestWithReissueToken.url!,
                    statusCode: 201,
                    httpVersion: nil,
                    headerFields: nil
                )!
                
                let mockData =
                """
                    {
                        "message" : "액세스 토큰이 유효합니다.",
                        "data" : {
                            "isValid" : true,
                            "expirationDate" : "2024-06-01T12:00:00Z"
                        }
                    }
                """.data(using: .utf8)!
                
                return (mockResponse, mockData)
            }
        ]
        
        // when
        let result = try awaitPublisher(sut.isUserValid())
        
        // then
        XCTAssertTrue(result)
    }
}
