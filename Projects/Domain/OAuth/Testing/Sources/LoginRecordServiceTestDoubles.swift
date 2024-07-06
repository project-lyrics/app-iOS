//
//  LoginRecordServiceTestDoubles.swift
//  DomainOAuthTesting
//
//  Created by 황인우 on 6/16/24.
//

import Combine
import Foundation

import DomainOAuthInterface

public final class DummyLoginRecordService: RecentLoginRecordServiceInterface {
    public func getRecentLoginRecord() -> AnyPublisher<OAuthType, Never> {
        return Empty().eraseToAnyPublisher()
    }
    
    public func save(oAuthType: String) {
        
    }
    
}
