//
//  RecentLoginService.swift
//  DomainOAuthInterface
//
//  Created by Derrick kim on 6/12/24.
//

import Combine
import DomainOAuthInterface

extension RecentLoginRecordService: RecentLoginRecordServiceInterface {
    public func getRecentLoginRecord() -> AnyPublisher<OAuthType, RecordError> {
        return Future { [weak self] promise in
            if let record = self?.recentLocalStorage.getRecentLoginRecord() {
                promise(.success(OAuthType(rawValue: record) ?? .none))
            } else {
                promise(.failure(.fetchError))
            }
        }
        .eraseToAnyPublisher()
    }

    public func save(oAuthType: String) {
        recentLocalStorage.save(oAuthType: oAuthType)
    }
}
