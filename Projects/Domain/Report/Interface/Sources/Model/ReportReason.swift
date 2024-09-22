//
//  ReportReason.swift
//  DomainReport
//
//  Created by Derrick kim on 9/22/24.
//

public enum ReportReason: String, CaseIterable {
    case inappropriateContent = "INAPPROPRIATE_CONTENT"
    case defamation = "DEFAMATION"
    case explicitContent = "EXPLICIT_CONTENT"
    case commercialADS = "COMMERCIAL_ADS"
    case infoDisclosure = "INFO_DISCLOSURE"
    case politicalReligious = "POLITICAL_RELIGIOUS"
    case other = "OTHER"

    public var title: String {
        switch self {
        case .inappropriateContent:
            return "커뮤니티 성격에 맞지 않음"
        case .defamation:
            return "타 유저 혹은 아티스트 비방"
        case .explicitContent:
            return "불쾌감을 조성하는 음란성 / 선정적인 내용"
        case .commercialADS:
            return "상업적 광고"
        case .infoDisclosure:
            return "부적절한 정보 유출"
        case .politicalReligious:
            return "정치적인 내용 / 종교 포교 시도"
        case .other:
            return "기타"
        }
    }
}
