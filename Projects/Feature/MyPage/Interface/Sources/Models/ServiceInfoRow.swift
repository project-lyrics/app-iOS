//
//  ServiceInfoRow.swift
//  FeatureMyPageInterface
//
//  Created by Derrick kim on 10/12/24.
//

import Foundation

public enum ServiceInfoRow: CaseIterable, Hashable {
    case userInfo
    case serviceUsage
    case personalInfo
    case serviceInquiry

    public var title: String {
        switch self {
        case .userInfo:
            return "회원 정보"
        case .serviceUsage:
            return "서비스 이용 약관"
        case .personalInfo:
            return "개인정보처리방침"
        case .serviceInquiry:
            return "서비스 문의하기"
        }
    }

    // TODO: URL 변경이 필요함
    // 현재 serviceUsage, personalInfo 있음

    public var url: String {
        switch self {
        case .userInfo:
            return ""

        case .serviceUsage:
            return "https://www.notion.so/Feelin-424aa52fb951444fa95f3966672ec670?pvs=4"

        case .personalInfo:
            return "https://www.notion.so/Feelin-2f586ef1b7c947d89ad8cac8a83b61d1?pvs=4"

        case .serviceInquiry:
            return "https://www.notion.so/Feelin-2f586ef1b7c947d89ad8cac8a83b61d1?pvs=4"
        }
    }
}
