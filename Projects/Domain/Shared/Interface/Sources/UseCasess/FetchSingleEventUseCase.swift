//
//  FetchSingleEventUseCase.swift
//  DomainShared
//
//  Created by 황인우 on 3/10/25.
//

import Core

import Foundation
import Combine

public protocol FetchSingleEventUseCaseInterface {
    func execute() -> AnyPublisher<FeelinEvent, EventError>
}

public struct FetchSingleEventUseCase: FetchSingleEventUseCaseInterface {
    private let eventAPIService: EventAPIServiceInterface
    
    public init(eventAPIService: EventAPIServiceInterface) {
        self.eventAPIService = eventAPIService
    }
    
    public func execute() -> AnyPublisher<FeelinEvent, EventError> {
        return eventAPIService.getEvents()
            .compactMap { response in
                response.event.data.first.map {
                    FeelinEvent(
                        dto: $0,
                        refusalPeriod: response.refusalPeriod
                    )
                }
            }
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
}
