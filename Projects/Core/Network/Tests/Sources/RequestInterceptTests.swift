//
//  RequestInterceptTests.swift
//  CoreNetworkTests
//
//  Created by 황인우 on 5/29/24.
//

import Combine
import XCTest

@testable import CoreNetwork
@testable import CoreNetworkInterface
@testable import CoreNetworkTesting
@testable import SharedUtil

final class RequestInterceptTest: XCTestCase {
    var sut: NetworkProviderProtocol!
    var mockURLSession: URLSession!
    var mockOAuthInterceptor: MockTokenInterceptor!
    
    private let expectedOauthToken: String = "oauthTokenForUnitTest"
    private let expectedAccessToken: String = "accessTokenForUnitTest"
    private let expectedRefreshToken: String = "refreshTokenForUnitTest"

    override func setUpWithError() throws {
        try super.setUpWithError()
        
        let configuration = URLSessionConfiguration.default
        configuration.protocolClasses = [MockURLProtocol.self]
        self.mockURLSession = URLSession(configuration: configuration)
        
        mockOAuthInterceptor = MockTokenInterceptor(
            oauthToken: expectedOauthToken
        )
    }

    override func tearDownWithError() throws {
        try super.tearDownWithError()
        self.sut = nil
        self.mockURLSession = nil
        self.mockOAuthInterceptor = nil
    }
    
    func test_login_api_호출시_TokenInterceptor가_header에_필요한_토큰을_주입한다() throws {
        // given
        MockURLProtocol.requestHandler = { request in
            let mockResponse = HTTPURLResponse(
                url: request.url!,
                statusCode: 201,
                httpVersion: nil,
                headerFields: nil
            )!
            
            let mockData = """
            {
                "status": 201,
                "data": {
                    "accessToken": "\(self.expectedAccessToken)",
                    "refreshToken": "\(self.expectedRefreshToken)"
                }
            }
            """.data(using: .utf8)!

            return Just((mockResponse, mockData))
                .setFailureType(to: Error.self)
                .eraseToAnyPublisher()
        }
        
        sut = NetworkProvider(
            session: self.mockURLSession,
            requestInterceptor: mockOAuthInterceptor
        )
        
        let endpoint = FeelinAPI<UserLoginResponse>.login(oauthProvider: .kakao)
        
        // when
        let result = try awaitPublisher(sut.request(endpoint))
        
        // then
        XCTAssertEqual(mockOAuthInterceptor.adaptMethodCalled, true)
        XCTAssertEqual(mockOAuthInterceptor.retryMethodCalled, false)
        XCTAssertEqual(mockOAuthInterceptor.request?.value(forHTTPHeaderField: "Authorization"), "Bearer \(self.expectedOauthToken)")
    }
    
    func test_login_처리중_401에러발생시_oAuthInterceptor의_retry_method가_호출된다() throws {
        // given
        MockURLProtocol.requestHandler = { request in
            let mockResponse = HTTPURLResponse(
                url: request.url!,
                statusCode: 401,
                httpVersion: nil,
                headerFields: nil
            )!
            
            let mockData = """
            {
                "accessToken": "\(self.expectedAccessToken)",
                "refreshToken": "\(self.expectedRefreshToken)"
            }
            """.data(using: .utf8)!

            return Just((mockResponse, mockData))
                .setFailureType(to: Error.self)
                .eraseToAnyPublisher()
        }
        
        sut = NetworkProvider(
            session: self.mockURLSession,
            requestInterceptor: mockOAuthInterceptor
        )
        
        let endpoint = FeelinAPI<UserLoginResponse>.login(oauthProvider: .kakao)
        
        // when
        XCTAssertThrowsError(try awaitPublisher(sut.request(endpoint)), "") { error in
            if let error = error as? NetworkError {
                XCTAssertEqual(error, NetworkError.clientError(.authorizationError))
            } else {
                XCTFail("unexpected error")
            }
            
            XCTAssertEqual(mockOAuthInterceptor.retryMethodCalled, true)
        }
    }
    
    func test_login_처리중_401에러외에는_oAuthInterceptor의_retry_method가_호출되지_않는다() throws {
        // given
        MockURLProtocol.requestHandler = { request in
            let mockResponse = HTTPURLResponse(
                url: request.url!,
                statusCode: 404,
                httpVersion: nil,
                headerFields: nil
            )!
            
            let mockData = """
            {
                "accessToken": "\(self.expectedAccessToken)",
                "refreshToken": "\(self.expectedRefreshToken)"
            }
            """.data(using: .utf8)!

            return Just((mockResponse, mockData))
                .setFailureType(to: Error.self)
                .eraseToAnyPublisher()
        }
        
        sut = NetworkProvider(
            session: self.mockURLSession,
            requestInterceptor: mockOAuthInterceptor
        )
        
        let endpoint = FeelinAPI<UserLoginResponse>.login(oauthProvider: .kakao)
        
        // when
        XCTAssertThrowsError(try awaitPublisher(sut.request(endpoint)), "") { error in
            if let error = error as? NetworkError {
                XCTAssertNotEqual(error, NetworkError.clientError(.authorizationError))
            } else {
                XCTFail("unexpected error")
            }
            
            XCTAssertEqual(mockOAuthInterceptor.retryMethodCalled, false)
        }
    }
}
