//
//  RefreshState.swift
//  FeatureMainTesting
//
//  Created by 황인우 on 9/17/24.
//

import Domain

import Foundation

enum RefreshState<E: LocalizedError> {
    case idle               // 대기 상태
    case refreshing         // 새로고침 중
    case completed          // 새로고침 완료
    case failed(E)  // 새로고침 실패 (에러 포함)
}
