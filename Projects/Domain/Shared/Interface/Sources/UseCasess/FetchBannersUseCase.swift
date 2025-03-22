//
//  FetchBannersUseCase.swift
//  DomainShared
//
//  Created by 황인우 on 3/19/25.
//

import Core

import Foundation
import Combine

public protocol FetchBannersUseCaseInterface {
    func execute() -> AnyPublisher<[Banner], EventError>
}

public struct FetchBannersUseCase: FetchBannersUseCaseInterface {
    private let eventAPIService: EventAPIServiceInterface
    
    public init(eventAPIService: EventAPIServiceInterface) {
        self.eventAPIService = eventAPIService
    }
    
    public func execute() -> AnyPublisher<[Banner], EventError> {
        return eventAPIService.getBanners()
            .receive(on: DispatchQueue.main)
            .map { $0.map(Banner.init) }
            .eraseToAnyPublisher()
    }
}
