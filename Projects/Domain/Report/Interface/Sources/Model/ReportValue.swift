//
//  ReportValue.swift
//  DomainReport
//
//  Created by Derrick kim on 9/22/24.
//

import Core

public struct ReportValue {
    let noteID: Int?
    let commentID: Int?
    let email: String?
    let reportReason: ReportReason
    let detailedReportReason: String?

    public init(
        noteID: Int?,
        commentID: Int?,
        email: String?,
        reportReason: ReportReason,
        detailedReportReason: String?
    ) {
        self.noteID = noteID
        self.commentID = commentID
        self.email = email
        self.reportReason = reportReason
        self.detailedReportReason = detailedReportReason
    }

    public func toDTO() -> ReportRequest {
        return ReportRequest(
            noteID: noteID,
            commentID: commentID,
            email: email,
            reportReason: reportReason.rawValue,
            detailedReportReason: detailedReportReason
        )
    }
}
