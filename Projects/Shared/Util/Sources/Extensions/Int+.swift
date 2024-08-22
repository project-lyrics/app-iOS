//
//  Int+.swift
//  SharedUtil
//
//  Created by 황인우 on 8/18/24.
//

import Foundation

public extension Int {
    func shortenedText() -> String {
        if self >= 1_000_000 {
            let millions = Double(self) / 1_000_000
            return String(format: "%.1fm", millions)
        } else if self >= 1_000 {
            let thousands = Double(self) / 1_000
            return String(format: "%.1fk", thousands)
        } else {
            return "\(self)"
        }
    }
}
