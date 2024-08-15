//
//  TermEntity.swift
//  DomainOAuthInterface
//
//  Created by Derrick kim on 7/7/24.
//

import Foundation
import Core

public enum TermEntity: CaseIterable {
    case ageAgree
    case serviceUsage
    case personalInfo

    public var title: String {
        switch self {
        case .ageAgree:
            return "만 14세 이상 가입 동의"
        case .serviceUsage:
            return "서비스 이용약관 동의"
        case .personalInfo:
            return "개인정보처리방침 동의"
        }
    }

    // TODO: notionLink 필요
    public var notionLink: String {
        switch self {
        case .ageAgree:
            return ""
        case .serviceUsage:
            return ""
        case .personalInfo:
            return ""
        }
    }

    public static let defaultTerms = TermEntity.allCases

    public func toDTO(_ agree: Bool = true) -> Term {
        return Term(
            agree: agree,
            title: title,
            agreement: notionLink
        )
    }
}
