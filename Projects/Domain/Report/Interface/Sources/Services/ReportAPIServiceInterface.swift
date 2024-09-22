//
//  ReportAPIServiceInterface.swift
//  DomainReport
//
//  Created by Derrick kim on 9/22/24.
//

import Core

import Combine
import Foundation

public protocol ReportAPIServiceInterface {
    func reportNote(
        value: ReportValue
    ) -> AnyPublisher<FeelinSuccessResponse, ReportError>
}
