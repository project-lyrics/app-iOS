//
//  RefuseEventUseCase.swift
//  DomainShared
//
//  Created by 황인우 on 3/10/25.
//

import Core

import Foundation
import Combine

public protocol RefuseEventUseCaseInterface {
    func execute(eventID: Int) -> AnyPublisher<Bool, EventError>
}

public struct RefuseEventUseCase: RefuseEventUseCaseInterface {
    private let eventAPIService: EventAPIServiceInterface
    
    public init(eventAPIService: EventAPIServiceInterface) {
        self.eventAPIService = eventAPIService
    }
    
    public func execute(eventID: Int) -> AnyPublisher<Bool, EventError> {
        return eventAPIService.postEventRefuse(eventID: eventID)
            .receive(on: DispatchQueue.main)
            .map(\.success)
            .eraseToAnyPublisher()
    }
}
