//
//  NewNotificationResponse.swift
//  CoreNetworkInterface
//
//  Created by 황인우 on 10/15/24.
//

import Foundation

public struct UncheckedNotificationResponse: Decodable {
    public let hasUnchecked: Bool
    
    public init(hasUnchecked: Bool) {
        self.hasUnchecked = hasUnchecked
    }
}
