//
//  MockReportAPIService.swift
//  DomainReport
//
//  Created by Derrick kim on 9/22/24.
//

import Combine
import Foundation

import Core
import DomainReportInterface
import DomainSharedInterface

public struct MockReportAPIService: ReportAPIServiceInterface {
    private let scenario: DomainTestScenario<ReportError>

    public init(scenario: DomainTestScenario<ReportError>) {
        self.scenario = scenario
    }

    public func reportNote(value: ReportValue) -> AnyPublisher<FeelinSuccessResponse, ReportError> {
        return Empty()
            .setFailureType(to: ReportError.self)
            .eraseToAnyPublisher()
    }
}
