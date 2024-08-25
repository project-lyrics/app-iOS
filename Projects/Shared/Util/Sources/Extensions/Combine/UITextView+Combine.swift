//
//  UITextView+Combine.swift
//  SharedUtil
//
//  Created by Derrick kim on 8/18/24.
//

import Combine
import UIKit

public extension UITextView {
    enum TextViewEvent {
        case didBeginEditing
        case didEndEditing
        case didChange

        var notificationName: Notification.Name {
            switch self {
            case .didBeginEditing:
                return UITextView.textDidBeginEditingNotification
            case .didEndEditing:
                return UITextView.textDidEndEditingNotification
            case .didChange:
                return UITextView.textDidChangeNotification
            }
        }
    }

    func textPublisher(for events: [TextViewEvent]) -> AnyPublisher<String?, Never> {
        let publishers = events.map { event in
            NotificationCenter.default.publisher(for: event.notificationName, object: self)
        }

        return Publishers.MergeMany(publishers)
            .map { ($0.object as? UITextView)?.text }
            .eraseToAnyPublisher()
    }

    func setUpTextView(text: String, textColor: UIColor) {
        self.text = text
        self.textColor = textColor
    }
}
