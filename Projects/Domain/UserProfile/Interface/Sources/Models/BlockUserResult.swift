//
//  BlockUserResult.swift
//  DomainUserProfileInterface
//
//  Created by 황인우 on 11/23/24.
//

import Foundation

public enum BlockUserResult<E: LocalizedError & Equatable>: Equatable {
    case none
    case success
    case failure(E)
}
