//
//  UIRefreshControl+Combine.swift
//  SharedUtil
//
//  Created by 황인우 on 8/25/24.
//

import Combine
import UIKit

public extension UIRefreshControl {
    var isRefreshingPublisher: AnyPublisher<Bool, Never> {
        Publishers.ControlProperty(
            control: self,
            events: .defaultValueEvents,
            keyPath: \.isRefreshing
        )
        .eraseToAnyPublisher()
    }
}
