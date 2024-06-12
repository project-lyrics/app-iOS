//
//  RecentLogInRecordStorage.swift
//  CoreLocalStorageInterface
//
//  Created by Derrick kim on 6/11/24.
//

import Foundation
import CoreLocalStorageInterface

public final class RecentLogInRecordStorage: RecentLogInRecordStorageInterface {
    private let RECENT_LOGIN = "RECENT_LOGIN"
    
    public init() { }

    public func getRecentLoginRecord() -> String? {
        guard let recentLoginRecord: String = UserDefaults.standard.string(forKey: RECENT_LOGIN) else {
            return nil
        }

        return recentLoginRecord
    }
    
    public func save(oAuthType: String) {
        UserDefaults.standard.setValue(oAuthType, forKey: RECENT_LOGIN)
    }
}
