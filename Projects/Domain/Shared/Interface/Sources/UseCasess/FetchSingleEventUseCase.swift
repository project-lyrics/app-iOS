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
                // 받아온 데이터 중 하나만 필요로 하기에 첫 번째 값만 매핑하였습니다.
                // 서버로부터 데이터를 한 개만 받는 것이 확실하기에 last를 써도 무방합니다.
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
