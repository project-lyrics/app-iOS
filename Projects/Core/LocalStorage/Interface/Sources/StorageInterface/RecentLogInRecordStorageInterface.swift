//
//  RecentLoginRecordStorageInterface.swift
//  CoreLocalStorageInterface
//
//  Created by Derrick kim on 6/11/24.
//

import Foundation

public protocol RecentLoginRecordStorageInterface {
    func getRecentLoginRecord() -> String?
    func save(oAuthType: String)
}
