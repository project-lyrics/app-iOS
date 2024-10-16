//
//  AppleOAuthServiceInterface.swift
//  DomainOAuthInterface
//
//  Created by 황인우 on 6/3/24.
//

import Combine
import CoreLocalStorageInterface
import CoreNetworkInterface
import Foundation

public class AppleLoginService: NSObject {
    public let networkProvider: NetworkProviderInterface
    public let tokenStorage: TokenStorageInterface
    public let userInfoStorage: UserInfoStorageInterface
    public let jwtDecoder: JWTDecoder = .init()
    public let tokenKeyHolder: TokenKeyHolderInterface
    public var appleTokenSubject: PassthroughSubject<String, AppleOAuthError> = .init()
    public let recentLoginRecordService: RecentLoginRecordServiceInterface

    public init(
        networkProvider: NetworkProviderInterface,
        tokenStorage: TokenStorageInterface,
        userInfoStorage: UserInfoStorageInterface,
        recentLoginRecordService: RecentLoginRecordServiceInterface,
        tokenKeyHolder: TokenKeyHolderInterface = TokenKeyHolder()
    ) {
        self.networkProvider = networkProvider
        self.tokenStorage = tokenStorage
        self.userInfoStorage = userInfoStorage
        self.recentLoginRecordService = recentLoginRecordService
        self.tokenKeyHolder = tokenKeyHolder      
    }
}
