//
//  RecentLogInRecordService.swift
//  DomainOAuthInterface
//
//  Created by Derrick kim on 6/12/24.
//

import Combine
import CoreLocalStorageInterface
import CoreNetworkInterface
import Foundation
import KakaoSDKUser

public protocol RecentLogInRecordServiceInterface {
    func getRecentLogInRecord() -> AnyPublisher<OAuthType, RecordError>
    func save(oAuthType: String)
}

public final class RecentLogInRecordService {
    public let recentLocalStorage: RecentLogInRecordStorageInterface

    public init(
        recentLocalStorage: RecentLogInRecordStorageInterface
    ) {
        self.recentLocalStorage = recentLocalStorage
    }
}
