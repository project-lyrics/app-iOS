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

struct MockData: Decodable {
    let key: String
}

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

        let expectation = XCTestExpectation(description: "Fetch sample data")
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
            }, receiveValue: { data in })
            .store(in: &cancellables)
        wait(for: [expectation], timeout: 2.0)
    }
}
