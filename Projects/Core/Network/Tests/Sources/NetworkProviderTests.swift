//
//  NetworkProviderTests.swift
//  CoreNetworkTests
//
//  Created by Derrick kim on 4/3/24.
//

import XCTest
import Foundation
import Combine

@testable import CoreNetworkTesting
@testable import CoreNetworkInterface
@testable import CoreNetwork
@testable import SharedUtil

final class NetworkProviderTests: XCTestCase {
    var networkProvider: NetworkProviderInterface!
    var cancellables: Set<AnyCancellable>!

    override func setUp() {
        super.setUp()

        let configuration = URLSessionConfiguration.default
        configuration.protocolClasses = [MockURLProtocol.self]
        let mockURLSession = URLSession(configuration: configuration)
        let mockNetworkSession = NetworkSession(
            urlSession: mockURLSession,
            requestInterceptor: nil
        )

        networkProvider = NetworkProvider(networkSession: mockNetworkSession)
        cancellables = Set<AnyCancellable>()
    }

    override func tearDown() {
        super.tearDown()

        networkProvider = nil
        cancellables = nil
    }

    func test_Response_200_Network_Request에_성공한다() throws {
        // 모의 응답 데이터와 HTTPURLResponse 설정
        let expectation = XCTestExpectation(description: "Search sample data")
        let endpoint = SampleAPI<MockData>.search
        let mockData = "{\"key\":\"value\"}".data(using: .utf8)!

        // MockURLProtocol의 loadingHandler에 모의 응답을 반환하도록 설정
        MockURLProtocol.requestHandler = { request in
            let mockResponse = HTTPURLResponse(
                url: request.url!,
                statusCode: 200,
                httpVersion: nil,
                headerFields: nil
            )!

            return Just((mockResponse, mockData))
                .setFailureType(to: Error.self)
                .eraseToAnyPublisher()
        }

        networkProvider.request(endpoint)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    XCTFail("API 호출 실패: \(error)")
                }
            }, receiveValue: { data in
                XCTAssertNotNil(data, "반환된 데이터가 nil입니다.")
                expectation.fulfill()
            })
            .store(in: &cancellables)

        wait(for: [expectation], timeout: 2.0)
    }

    func test_Response_400_badRequestError_Network_Request에_실패한다() throws {
        // 모의 응답 데이터와 HTTPURLResponse 설정
        let mockData = "{\"key\":\"value\"}".data(using: .utf8)!
        let endpoint = SampleAPI<MockData>.search
        let result = NetworkError.clientError(.badRequestError)

        // MockURLProtocol의 loadingHandler에 모의 응답을 반환하도록 설정
        MockURLProtocol.requestHandler = { request in
            let mockResponse = HTTPURLResponse(
                url: request.url!,
                statusCode: 400,
                httpVersion: nil,
                headerFields: nil
            )!

            return Just((mockResponse, mockData))
                .setFailureType(to: Error.self)
                .eraseToAnyPublisher()
        }

        let config = URLSessionConfiguration.ephemeral
        config.protocolClasses = [MockURLProtocol.self]
        let urlSession = URLSession(configuration: config)
        let mockNetworkSesison = NetworkSession(urlSession: urlSession, requestInterceptor: nil)

        let expectation = XCTestExpectation(description: "badRequestError")
        let networkManager: NetworkProviderInterface = NetworkProvider(networkSession: mockNetworkSesison)

        networkManager.request(endpoint)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    XCTAssertEqual(error, result)
                    expectation.fulfill()
                }
            }, receiveValue: { _ in })
            .store(in: &cancellables)
        wait(for: [expectation], timeout: 2.0)
    }
    
    func test_login_api_호출_실패시_400_에러메세지를_내뱉는다() throws {
        // given
        let expectedOauthToken: String = "oauthTokenForUnitTest"
        let mockData =
        """
            {
                "errorCode" : "00400",
                "errorMessage" : "잘못된 요청입니다.",
            }
        """.data(using: .utf8)!
        let endpoint = FeelinAPI<TokenResponse>.login(
            oAuthProvider: .kakao,
            oAuthAccessToken: expectedOauthToken
        )
        let expectedError = NetworkError.clientError(.badRequestError)
        
        MockURLProtocol.requestHandler = { request in
            let mockResponse = HTTPURLResponse(
                url: request.url!,
                statusCode: 400,
                httpVersion: nil,
                headerFields: nil
            )!

            return Just((mockResponse, mockData))
                .setFailureType(to: Error.self)
                .eraseToAnyPublisher()
        }

        let config = URLSessionConfiguration.ephemeral
        config.protocolClasses = [MockURLProtocol.self]
        let urlSession = URLSession(configuration: config)
        let mockNetworkSession = NetworkSession(urlSession: urlSession, requestInterceptor: nil)

        let sut: NetworkProviderInterface = NetworkProvider(networkSession: mockNetworkSession)
        
        // when
        XCTAssertThrowsError(try awaitPublisher(sut.request(endpoint)), "") { error in
            // then
            if let error = error as? NetworkError {
                XCTAssertEqual(error, expectedError)
            } else {
                XCTFail("received unexpected error")
            }
        }
    }
    
    func test_login_api_호출_성공시_accessToken과_refreshToken을_반환한다() throws {
        // given
        let expectedOauthToken: String = "oauthTokenForUnitTest"
        let expectedAccessToken: String = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.e30.dQw4w9WgXcQ"
        let expectedRefreshToken: String = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.e30.RmlZaDFvSG1NeUQ"
        
        MockURLProtocol.requestHandler = { request in
            let mockResponse = HTTPURLResponse(
                url: request.url!,
                statusCode: 201,
                httpVersion: nil,
                headerFields: nil
            )!
            
            let mockData = """
            {
                "status": "소셜 로그인이 완료되었습니다.",
                "data": {
                    "accessToken": "\(expectedAccessToken)",
                    "refreshToken": "\(expectedRefreshToken)"
                }
            }
            """.data(using: .utf8)!

            return Just((mockResponse, mockData))
                .setFailureType(to: Error.self)
                .eraseToAnyPublisher()
        }
        
        let configuration = URLSessionConfiguration.default
        configuration.protocolClasses = [MockURLProtocol.self]
        let urlSession = URLSession(configuration: configuration)
        let mockNetworkSession = NetworkSession(
            urlSession: urlSession,
            requestInterceptor: nil
        )
        
        networkProvider = NetworkProvider(networkSession: mockNetworkSession)
        
        let endpoint = FeelinAPI<TokenResponse>.login(
            oAuthProvider: .kakao,
            oAuthAccessToken: expectedOauthToken
        )
        
        // when
        do {
            let result = try awaitPublisher(networkProvider.request(endpoint))
            // then
            XCTAssertEqual(result.accessToken, expectedAccessToken)
            XCTAssertEqual(result.refreshToken, expectedRefreshToken)
        } catch {
            XCTFail()
        }
    }

    func test_sign_up_api_호출_성공시_accessToken과_refreshToken을_반환한다() throws {
        // given
        let expectedOauthToken: String = "oauthTokenForUnitTest"
        let expectedAccessToken: String = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.e30.dQw4w9WgXcQ"
        let expectedRefreshToken: String = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.e30.RmlZaDFvSG1NeUQ"

        MockURLProtocol.requestHandler = { request in
            let mockResponse = HTTPURLResponse(
                url: request.url!,
                statusCode: 201,
                httpVersion: nil,
                headerFields: nil
            )!

            let mockData = """
            {
                "status": "회원가입이 완료되었습니다.",
                "data": {
                    "accessToken": "\(expectedAccessToken)",
                    "refreshToken": "\(expectedRefreshToken)"
                }
            }
            """.data(using: .utf8)!

            return Just((mockResponse, mockData))
                .setFailureType(to: Error.self)
                .eraseToAnyPublisher()
        }

        let configuration = URLSessionConfiguration.default
        configuration.protocolClasses = [MockURLProtocol.self]
        let urlSession = URLSession(configuration: configuration)
        let mockNetworkSession = NetworkSession(
            urlSession: urlSession,
            requestInterceptor: nil
        )

        networkProvider = NetworkProvider(networkSession: mockNetworkSession)

        let request = UserSignUpRequest(
            socialAccessToken: "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.e30.dQw4w9WgXcQ",
            authProvider: .kakao,
            nickname: "derrick",
            profileCharacter: "poopHair",
            gender: .male,
            birthYear: "1992년",
            terms: [Term(
                agree: true,
                title: "만 14세 이상 가입 동의",
                agreement: "url"
            )]
        )
        let endpoint = FeelinAPI<TokenResponse>.signUp(
            request: request
        )

        // when
        do {
            let result = try awaitPublisher(networkProvider.request(endpoint))
            // then
            XCTAssertEqual(result.accessToken, expectedAccessToken)
            XCTAssertEqual(result.refreshToken, expectedRefreshToken)
        } catch {
            XCTFail()
        }
    }

    func test_sign_up_api_호출_성공시_accessToken과_refreshToken을_반환한다() throws {
        // given
        let expectedOauthToken: String = "oauthTokenForUnitTest"
        let expectedAccessToken: String = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.e30.dQw4w9WgXcQ"
        let expectedRefreshToken: String = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.e30.RmlZaDFvSG1NeUQ"

        MockURLProtocol.requestHandler = { request in
            let mockResponse = HTTPURLResponse(
                url: request.url!,
                statusCode: 201,
                httpVersion: nil,
                headerFields: nil
            )!

            let mockData = """
            {
                "status": "회원가입이 완료되었습니다.",
                "data": {
                    "accessToken": "\(expectedAccessToken)",
                    "refreshToken": "\(expectedRefreshToken)"
                }
            }
            """.data(using: .utf8)!

            return Just((mockResponse, mockData))
                .setFailureType(to: Error.self)
                .eraseToAnyPublisher()
        }

        let configuration = URLSessionConfiguration.default
        configuration.protocolClasses = [MockURLProtocol.self]
        let urlSession = URLSession(configuration: configuration)
        let mockNetworkSession = NetworkSession(
            urlSession: urlSession,
            requestInterceptor: nil
        )

        networkProvider = NetworkProvider(networkSession: mockNetworkSession)

        let request = UserSignUpRequest(
            socialAccessToken: "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.e30.dQw4w9WgXcQ",
            authProvider: .kakao,
            nickname: "derrick",
            profileCharacter: "poopHair",
            gender: .male,
            birthYear: "1992년",
            terms: [Term(
                agree: true,
                title: "만 14세 이상 가입 동의",
                agreement: "url"
            )]
        )
        let endpoint = FeelinAPI<TokenResponse>.signUp(
            request: request
        )

        // when
        do {
            let result = try awaitPublisher(networkProvider.request(endpoint))
            // then
            XCTAssertEqual(result.accessToken, expectedAccessToken)
            XCTAssertEqual(result.refreshToken, expectedRefreshToken)
        } catch {
            XCTFail()
        }
    }
}
