//
//  ReportViewModel.swift
//  FeatureMainInterface
//
//  Created by Derrick kim on 9/17/24.
//

import Combine
import UIKit

import Domain
import Core

public final class ReportViewModel {
    typealias ReportNoteResult = Result<FeelinSuccessResponse, ReportError>

    struct Input {
        let reportReasonTapPublisher: AnyPublisher<ReportReason, Never>
        let reportReasonTypePublisher: AnyPublisher<String?, Never>
        let agreementTapPublisher: AnyPublisher<UIControl, Never>
        let reportButtonTapPublisher: AnyPublisher<UIControl, Never>
    }

    struct Output {
        let isEnabledReportButton: AnyPublisher<Bool, Never>
        let reportNoteResult: AnyPublisher<ReportNoteResult, Never>
    }

    private var cancellables = Set<AnyCancellable>()

    private let noteID: Int?
    private let commentID: Int?
    private let reportNoteUseCase: ReportNoteUseCaseInterface

    public init(
        noteID: Int?,
        commentID: Int?,
        reportNoteUseCase: ReportNoteUseCaseInterface
    ) {
        self.noteID = noteID
        self.commentID = commentID
        self.reportNoteUseCase = reportNoteUseCase
    }

    func transform(input: Input) -> Output {
        return Output(
            isEnabledReportButton: self.isEnabledReportButton(input), reportNoteResult: self.reportNote(input)
        )
    }
}

private extension ReportViewModel {
    func isEnabledReportButton(_ input: Input) -> AnyPublisher<Bool, Never> {
        return Publishers.CombineLatest(input.agreementTapPublisher, isSelectedReportReason(input))
            .map { agreementControl, isReasonSelected in
                let isAgreementChecked = agreementControl.isSelected
                return isAgreementChecked && isReasonSelected
            }
            .eraseToAnyPublisher()
    }

    func isSelectedReportReason(_ input: Input) -> AnyPublisher<Bool, Never> {
        return input.reportReasonTapPublisher
            .combineLatest(input.reportReasonTypePublisher)
            .map { reason, typedReasonText in
                if reason == .other, let typedReasonText{
                    return typedReasonText.isEmpty == false
                } else {
                    return true
                }
            }
            .eraseToAnyPublisher()
    }

    func reportNote(_ input: Input) -> AnyPublisher<ReportNoteResult, Never> {
        let requiredFieldsPublisher = Publishers.CombineLatest(
            input.reportReasonTapPublisher,
            input.agreementTapPublisher
        )
            .eraseToAnyPublisher()

        let optionalFieldsPublisher = input
            .reportReasonTypePublisher
            .prepend(nil)

        let combinedPublisher = requiredFieldsPublisher
            .combineLatest(optionalFieldsPublisher)
            .map { [weak self] (requiredValues, detailedReportReason) -> ReportValue in
                let (reportReason, _) = requiredValues

                return ReportValue(
                    noteID: self?.noteID,
                    commentID: self?.commentID,
                    email: nil,
                    reportReason: reportReason,
                    detailedReportReason: detailedReportReason
                )
            }
            .eraseToAnyPublisher()

        return input.reportButtonTapPublisher
            .combineLatest(combinedPublisher)
            .flatMap { [weak self] (_, value) -> AnyPublisher<ReportNoteResult, Never> in
                guard let self = self else {
                    return Empty().eraseToAnyPublisher()
                }
                return self.reportNote(value)
            }
            .eraseToAnyPublisher()
    }

    func reportNote(_ requestValue: ReportValue) -> AnyPublisher<ReportNoteResult, Never> {
        return self.reportNoteUseCase
            .execute(value: requestValue)
            .receive(on: DispatchQueue.main)
            .mapError(ReportError.init)
            .mapToResult()
    }
}
