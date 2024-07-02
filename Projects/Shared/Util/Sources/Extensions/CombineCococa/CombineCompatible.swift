//
//  CombineCompatible.swift
//  SharedUtil
//
//  Created by Derrick kim on 7/2/24.
//

import Combine
import UIKit

public protocol CombineCompatible {}

public extension CombineCompatible where Self: UIControl {
    func publisher(for event: UIControl.Event) -> UIControl.Publisher<UIControl> {
        .init(output: self, event: event)
    }
}

public extension CombineCompatible where Self: UIBarButtonItem {
    var publisher: UIBarButtonItem.Publisher<UIBarButtonItem> {
        .init(output: self)
    }
}

public extension CombineCompatible where Self: UILabel {
    var tapPublisher: AnyPublisher<UILabel, Never> {
        let subject = PassthroughSubject<UILabel, Never>()
        let target = GestureRecognizerTarget(subject: subject, label: self)
        let tapGestureRecognizer = UITapGestureRecognizer(target: target, action: #selector(GestureRecognizerTarget.handleTap(_:)))

        self.isUserInteractionEnabled = true
        self.addGestureRecognizer(tapGestureRecognizer)

        objc_setAssociatedObject(self, &AssociatedKeys.tapSubject, subject, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        objc_setAssociatedObject(self, &AssociatedKeys.gestureRecognizerTarget, target, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)

        return subject.eraseToAnyPublisher()
    }
}

struct AssociatedKeys {
    static var tapSubject = "tapSubject"
    static var gestureRecognizerTarget = "gestureRecognizerTarget"
}

private class GestureRecognizerTarget: NSObject {
    let subject: PassthroughSubject<UILabel, Never>
    weak var label: UILabel?

    init(subject: PassthroughSubject<UILabel, Never>, label: UILabel) {
        self.subject = subject
        self.label = label
    }

    @objc func handleTap(_ sender: UITapGestureRecognizer) {
        if let label = label {
            subject.send(label)
        }
    }
}
