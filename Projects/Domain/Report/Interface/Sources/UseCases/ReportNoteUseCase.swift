//
//  ReportNoteUseCase.swift
//  DomainReport
//
//  Created by Derrick kim on 9/22/24.
//

import Core
import Foundation
import Combine

public protocol ReportNoteUseCaseInterface {
    func execute(value: ReportValue) ->AnyPublisher<FeelinSuccessResponse, ReportError>
}

public struct ReportNoteUseCase: ReportNoteUseCaseInterface {
    private let reportAPIService: ReportAPIServiceInterface

    public init(
        reportAPIService: ReportAPIServiceInterface
    ) {
        self.reportAPIService = reportAPIService
    }

    public func execute(value: ReportValue) ->AnyPublisher<FeelinSuccessResponse, ReportError> {
        return reportAPIService.reportNote(value: value)
            .eraseToAnyPublisher()
    }
}
