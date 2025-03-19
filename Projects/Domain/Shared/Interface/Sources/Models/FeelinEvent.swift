//
//  FeelinEvent.swift
//  DomainShared
//
//  Created by 황인우 on 3/10/25.
//

import Core

import Foundation

public struct EventExtraInfo: Hashable {
    public let buttonTitle: String
    public let refusalText: String
    
    public init(
        buttonTitle: String,
        refusalPeriod: Int
    ) {
        self.buttonTitle = buttonTitle
        self.refusalText = Self.makeRefusalText(
            from: refusalPeriod
        )
    }
    
    private static func makeRefusalText(from period: Int) -> String {
        switch period {
        case 1:
            return "오늘 하루 보지 않기"
        case 7:
            return "일주일간 보지 않기"
        case 30:
            return "한 달 동안 보지 않기"
        default:
            return "\(period)일간 보지 않기"
        }
    }
}

public struct FeelinEvent: Hashable {
    public let id: Int
    public let imageURL: URL
    public let redirectURL: URL
    public let eventExtraInfo: EventExtraInfo
    
    public init(
        id: Int,
        imageURL: URL,
        redirectURL: URL,
        eventExtraInfo: EventExtraInfo
    ) {
        self.id = id
        self.imageURL = imageURL
        self.redirectURL = redirectURL
        self.eventExtraInfo = eventExtraInfo
    }
    
    public init(
        dto: GetEventDetailResponse,
        refusalPeriod: Int
    ) {
        self.id = dto.id
        self.imageURL = dto.imageUrl
        self.redirectURL = dto.redirectUrl
        self.eventExtraInfo = .init(
            buttonTitle: dto.buttonText,
            refusalPeriod: refusalPeriod
        )
    }
}
