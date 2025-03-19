//
//  EventAPIService.swift
//  DomainShared
//
//  Created by 황인우 on 3/10/25.
//

import Core

import Combine
import Foundation

public protocol EventAPIServiceInterface {
    func getEvents() -> AnyPublisher<GetEventInfoResponse, EventError>
    func postEventRefuse(eventID: Int) -> AnyPublisher<FeelinSuccessResponse, EventError>
}

public struct EventAPIService: EventAPIServiceInterface {
    let networkProvider: NetworkProviderInterface
    
    public init(networkProvider: NetworkProviderInterface) {
        self.networkProvider = networkProvider
    }
    
    public func getEvents() -> AnyPublisher<GetEventInfoResponse, EventError> {
        let endpoint = FeelinAPI<GetEventInfoResponse>.getEvents
        
        return networkProvider.request(endpoint)
            .mapError(EventError.init)
            .eraseToAnyPublisher()
    }
    
    public func postEventRefuse(eventID: Int) -> AnyPublisher<FeelinSuccessResponse, EventError> {
        let endpoint = FeelinAPI<FeelinSuccessResponse>.postEventRefuse(eventID: eventID)
        
        return networkProvider.request(endpoint)
            .mapError(EventError.init)
            .eraseToAnyPublisher()
    }
}
