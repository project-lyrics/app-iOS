//
//  UITextField+.swift
//  SharedUtil
//
//  Created by Derrick kim on 7/7/24.
//

import Combine
import UIKit

public extension UITextField {
    var textPublisher: AnyPublisher<String?, Never> {
        NotificationCenter.default.publisher(for: UITextField.textDidChangeNotification, object: self)
            .map { ($0.object as? UITextField)?.text }
            .eraseToAnyPublisher()
    }
}
