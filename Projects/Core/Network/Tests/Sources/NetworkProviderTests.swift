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
    var networkProvider: NetworkProviderProtocol!
    var cancellables: Set<AnyCancellable>!

    override func setUp() {
        super.setUp()

        let configuration = URLSessionConfiguration.default
        configuration.protocolClasses = [MockURLProtocol.self]
        let mockURLSession = URLSession(configuration: configuration)

        networkProvider = NetworkProvider(session: mockURLSession)
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

        let expectation = XCTestExpectation(description: "badRequestError")
        let networkManager: NetworkProviderProtocol = NetworkProvider(session: urlSession)

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
    
    func test_서버로부터_잘못된_요청_에러수신시_정상적으로_에러를_내뱉는다() throws {
        // given
        let mockData =
        """
            {
                "errorCode" : "00400",
                "errorMessage" : "잘못된 요청입니다.",
            }
        """.data(using: .utf8)!
        let endpoint = FeelinAPI<UserLoginResponse>.login(oauthProvider: .kakao)
        let expectedError = NetworkError.customServerError(
            .init(
                errorCode: "00400",
                errorMessage: "잘못된 요청입니다."
            )
        )
        
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

        let sut: NetworkProviderProtocol = NetworkProvider(session: urlSession)
        
        // when
        XCTAssertThrowsError(try awaitPublisher(sut.request(endpoint)), "서버커스텀에러") { error in
            // then
            if let error = error as? NetworkError {
                XCTAssertEqual(error, expectedError)
            } else {
                XCTFail("received unexpected error")
            }
        }
    }
}
