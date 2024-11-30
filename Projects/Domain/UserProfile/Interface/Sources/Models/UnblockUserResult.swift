//
//  UnblockUserResult.swift
//  DomainUserProfileInterface
//
//  Created by 황인우 on 11/23/24.
//

import Foundation

public enum UnblockUserResult<E: LocalizedError & Equatable>: Equatable {
    case none
    case success
    case failure(E)
}
