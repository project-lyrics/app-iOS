//
//  Array.swift
//  SharedUtil
//
//  Created by Derrick kim on 2/19/24.
//

import Foundation

public extension Array {
    subscript (safe index: Int) -> Element? {
        return indices ~= index ? self[index] : nil
    }
}
