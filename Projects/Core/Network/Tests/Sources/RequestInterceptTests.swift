//
//  RequestInterceptTests.swift
//  CoreNetworkTests
//
//  Created by 황인우 on 5/29/24.
//

import Combine
import XCTest

@testable import CoreLocalStorageInterface
@testable import CoreNetwork
@testable import CoreNetworkInterface
@testable import CoreNetworkTesting
@testable import SharedUtil

final class RequestInterceptTest: XCTestCase {
    var sut: NetworkProviderInterface!
    var fakeTokenStorage: FakeTokenStorage!
    var tokenInterceptor: MockTokenInterceptor!
    var urlSession: URLSession!
    
    

    override func setUpWithError() throws {
        try super.setUpWithError()
        fakeTokenStorage = .init()
        tokenInterceptor = MockTokenInterceptor(tokenStorage: fakeTokenStorage)
        
        let configuration = URLSessionConfiguration.default
        configuration.protocolClasses = [MockURLProtocol.self]
        urlSession = URLSession(configuration: configuration)
    }

    override func tearDownWithError() throws {
        try super.tearDownWithError()
        self.sut = nil
        tokenInterceptor = nil
        urlSession = nil
    }
    
    func test_토큰유효성_검증_과정에서_401에러발생시_oAuthInterceptor의_retry_method가_호출된다() throws {
        // given
        try fakeTokenStorage.save(
            token: AccessToken(
                token: "fakeAccessToken",
                expiration: .init()
            ),
            for: tokenInterceptor.dummyAccessTokenKey
        )
        
        MockURLProtocol.requestHandler = { request in
            let mockResponse = HTTPURLResponse(
                url: request.url!,
                statusCode: 401,
                httpVersion: nil,
                headerFields: nil
            )!
            
            let mockData = """
            {
                "errorCode" : "00401",
                "errorMessage" : "액세스 토큰이 유효하지 않습니다."
            }
            """.data(using: .utf8)!

            return Just((mockResponse, mockData))
                .setFailureType(to: Error.self)
                .eraseToAnyPublisher()
        }
        
        let mockNetworkSession = NetworkSession(
            urlSession: urlSession,
            requestInterceptor: tokenInterceptor
        )
        
        sut = NetworkProvider(
            networkSession: mockNetworkSession
        )

        let accessToken: AccessToken! = try fakeTokenStorage.read(key: "FeelinGoodAccessRight")
        let endpoint = FeelinAPI<UserValidityResponse>.checkUserValidity(accessToken: accessToken.token)

        // when
        XCTAssertThrowsError(try awaitPublisher(sut.request(endpoint)), "") { error in
            if let error = error as? NetworkError {
                XCTAssertEqual(error, NetworkError.clientError(.authorizationError))
            } else {
                XCTFail("unexpected error")
            }
            
            // then
            XCTAssertEqual(tokenInterceptor.retryMethodCalled, true)
        }
    }
    
    func test_토큰유효성_검증_과정에서_401에러외에는_oAuthInterceptor의_retry_method가_호출되지_않는다() throws {
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
                "errorCode" : "00404",
                "errorMessage" : "요청한 데이터가 없습니다."
            }
            """.data(using: .utf8)!

            return Just((mockResponse, mockData))
                .setFailureType(to: Error.self)
                .eraseToAnyPublisher()
        }
        
        let mockNetworkSession = NetworkSession(
            urlSession: urlSession,
            requestInterceptor: tokenInterceptor
        )
        
        sut = NetworkProvider(
            networkSession: mockNetworkSession
        )
        
        let accessToken: AccessToken! = try fakeTokenStorage.read(key: "FeelinGoodAccessRight")
        let endpoint = FeelinAPI<TokenResponse>.checkUserValidity(accessToken: accessToken.token)
        
        // when
        XCTAssertThrowsError(try awaitPublisher(sut.request(endpoint)), "") { error in
            if let error = error as? NetworkError {
                XCTAssertNotEqual(error, NetworkError.clientError(.badRequestError))
            } else {
                XCTFail("unexpected error")
            }
            
            XCTAssertEqual(tokenInterceptor.retryMethodCalled, false)
        }
    }
}
