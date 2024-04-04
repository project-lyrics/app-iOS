//
//  SampleAPITests.swift
//  CoreNetworkTests
//
//  Created by Derrick kim on 4/3/24.
//

import XCTest
import Foundation
import Combine
@testable import CoreNetworkTesting

final class SampleAPITests: XCTestCase {
    var mockNetworkProvider: MockNetworkProvider!
    var cancellables: Set<AnyCancellable>!

    override func setUpWithError() throws {
        super.setUp()

        mockNetworkProvider = MockNetworkProvider()
        cancellables = Set<AnyCancellable>()
    }

    override func tearDownWithError() throws {
        super.tearDown()

        mockNetworkProvider = nil
        cancellables = nil
    }

    func test_유효한JSONResponse를받았을때_디코딩_가능한_객체에_대한Response를디코딩해야한다() {
        let expectation = expectation(description: "")

        let requestDTO = AppSearchRequestDTO(
            keyword: "카카오 뱅크",
            media: "software",
            country: "kr",
            page: 0,
            size: 10
        )

        let endpoint = SampleAPI<AppSearchResponseDTO>.search(requestDTO)
        let api = mockNetworkProvider.request(endpoint).eraseToAnyPublisher()

        api.receive(on: DispatchQueue.main)
            .sink { result in
                switch result {
                case .finished:
                    expectation.fulfill()
                case .failure:
                    XCTFail()
                }
            } receiveValue: { entity in
                XCTAssertTrue(type(of: entity) == AppSearchResponseDTO.self)
            }
            .store(in: &cancellables)

        wait(for: [expectation], timeout: 1)
    }
}
