//
//  Collection+.swift
//  SharedUtil
//
//  Created by 황인우 on 7/20/24.
//

import Foundation

public extension Collection {
    var isNotEmpty: Bool {
        return !self.isEmpty
    }
    
    /// 배열 안전하게 조회. index out of range 방지
    subscript (safe index: Index) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
}
