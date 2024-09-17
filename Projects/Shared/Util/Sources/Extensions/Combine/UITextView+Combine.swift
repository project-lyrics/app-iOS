//
//  UITextView+Combine.swift
//  SharedUtil
//
//  Created by Derrick kim on 8/18/24.
//

import Combine
import UIKit

public extension UITextView {
    private class TextViewDelegate: NSObject, UITextViewDelegate {
        let shouldBeginEditingSubject = PassthroughSubject<UITextView, Never>()
        var allowEditingPublisher: AnyPublisher<Bool, Never> = Just(true).eraseToAnyPublisher()
        private var cancellable = Set<AnyCancellable>()

        func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
            shouldBeginEditingSubject.send(textView)

            var allowEditing = true
            let semaphore = DispatchSemaphore(value: 0)

            allowEditingPublisher
                .sink { isAllowed in
                    allowEditing = isAllowed
                    semaphore.signal()
                }
                .store(in: &cancellable)

            semaphore.wait()
            return allowEditing
        }
    }

    private struct AssociatedKeys {
        static var delegateKey = "textViewDelegateKey"
    }

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

    var shouldBeginEditingPublisher: AnyPublisher<UITextView, Never> {
        if let delegate = objc_getAssociatedObject(self, AssociatedKeys.delegateKey) as? TextViewDelegate {
            return delegate.shouldBeginEditingSubject.eraseToAnyPublisher()
        } else {
            let delegate = TextViewDelegate()
            self.delegate = delegate
            objc_setAssociatedObject(self, AssociatedKeys.delegateKey, delegate, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            return delegate.shouldBeginEditingSubject.eraseToAnyPublisher()
        }
    }

    func setUpTextView(text: String, textColor: UIColor) {
        self.text = text
        self.textColor = textColor
    }

    func setAllowEditingPublisher(_ publisher: AnyPublisher<Bool, Never>) {
        if let delegate = objc_getAssociatedObject(self, AssociatedKeys.delegateKey) as? TextViewDelegate {
            delegate.allowEditingPublisher = publisher
        }
    }
}
