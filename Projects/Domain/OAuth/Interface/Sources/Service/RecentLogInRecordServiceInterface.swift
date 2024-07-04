//
//  RecentLoginRecordService.swift
//  DomainOAuthInterface
//
//  Created by Derrick kim on 6/12/24.
//

import Combine
import CoreLocalStorageInterface
import CoreNetworkInterface
import Foundation
import KakaoSDKUser

public protocol RecentLoginRecordServiceInterface {
    func getRecentLoginRecord() -> AnyPublisher<OAuthType, Never>
    func save(oAuthType: String)
}

public final class RecentLoginRecordService {
    public let recentLocalStorage: RecentLoginRecordStorageInterface

    public init(
        recentLocalStorage: RecentLoginRecordStorageInterface
    ) {
        self.recentLocalStorage = recentLocalStorage
    }
}
