//
//  ReportAPIService.swift
//  DomainReport
//
//  Created by Derrick kim on 9/22/24.
//

import Core
import DomainReportInterface

import Combine
import Foundation

public struct ReportAPIService: ReportAPIServiceInterface {
    
    private let networkProvider: NetworkProviderInterface
    
    public init(networkProvider: NetworkProviderInterface) {
        self.networkProvider = networkProvider
    }
    
    public func reportNote(value: ReportValue) -> AnyPublisher<CoreNetworkInterface.FeelinSuccessResponse, ReportError> {
        let request = value.toDTO()
        let endpoint = FeelinAPI<FeelinSuccessResponse>.reportNote(
            request: request
        )
        
        return networkProvider.request(endpoint)
            .mapError(ReportError.init)
            .eraseToAnyPublisher()
    }
}
