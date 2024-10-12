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

    public var notionLink: String {
        switch self {
        case .ageAgree:
            return ""
        case .serviceUsage:
            return "https://www.notion.so/Feelin-424aa52fb951444fa95f3966672ec670?pvs=4"
        case .personalInfo:
            return "https://www.notion.so/Feelin-2f586ef1b7c947d89ad8cac8a83b61d1?pvs=4"
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
