//
//  ReportRequest.swift
//  CoreNetworkInterface
//
//  Created by Derrick kim on 9/22/24.
//

import Foundation

public struct ReportRequest: Encodable {
    let noteID: Int?
    let commentID: Int?
    let email: String?
    let reportReason: String

    public init(
        noteID: Int?,
        commentID: Int?,
        email: String?,
        reportReason: String
    ) {
        self.noteID = noteID
        self.commentID = commentID
        self.email = email
        self.reportReason = reportReason
    }
}
