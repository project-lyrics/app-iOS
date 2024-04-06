//
//  MockNetworkProvider.swift
//  CoreNetwork
//
//  Created by Derrick kim on 4/3/24.
//

import Foundation
import Combine
import CoreNetworkInterface
import SharedUtilInterface

public final class MockNetworkProvider: NetworkProviderProtocol {
    public var scenario: Scenario = .success

    public var appSearchResponseDTO: AppSearchResponseDTO = {
        let data = AppSearchItemResponseDTO.completeDataMock

        return AppSearchResponseDTO(
            resultCount: 1,
            results: [data]
        )
    }()

    public var networkError = NetworkError.unknownError

    public func request<N, T>(
        _ endpoint: N
    ) -> AnyPublisher<T, NetworkError> where N: HTTPNetworking, T: Decodable, T == N.Response {
        guard let data = appSearchResponseDTO as? T else {
            return Fail(error: networkError)
                .eraseToAnyPublisher()
        }

        switch scenario {
        case .success:
            return Just(data)
                .setFailureType(to: NetworkError.self)
                .eraseToAnyPublisher()
        case .failure:
            return Fail(error: networkError)
                .eraseToAnyPublisher()
        }
    }
}
