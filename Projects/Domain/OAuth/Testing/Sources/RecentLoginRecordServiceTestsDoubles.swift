//
//  RecentLoginRecordServiceTestsDoubles.swift
//  DomainOAuthInterface
//
//  Created by Derrick kim on 7/21/24.
//

import Combine
import Core
import Foundation

// MARK: - FakeRecentLoginRecordService
public class FakeRecentLoginRecordService: RecentLoginRecordServiceInterface {

    private var storage: String = ""

    public init() {}

    public func getRecentLoginRecord() -> AnyPublisher<OAuthType, Never> {
        return Just(OAuthType.kakao).eraseToAnyPublisher()
    }

    public func save(oAuthType: String) {
        storage = oAuthType
    }
}

// MARK: - MockRecentLoginRecordService
public class MockRecentLoginRecordService: RecentLoginRecordServiceInterface {
    public var readResult = OAuthType.kakao
    public var saveResult: Bool = true

    public var readCalled: Bool = false
    public var saveCalled: Bool = false

    public var saveResultCount: Int = 0
    public var readResultCount: Int = 0

    public init() {}

    public func getRecentLoginRecord() -> AnyPublisher<OAuthType, Never> {
        readCalled = true
        readResultCount += 1

        return Just(readResult).eraseToAnyPublisher()
    }

    public func save(oAuthType: String) {
        saveCalled = true
        saveResultCount += 1
    }
}
