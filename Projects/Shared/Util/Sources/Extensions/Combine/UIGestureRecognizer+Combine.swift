//
//  UIGestureRecognizer+Combine.swift
//  SharedUtil
//
//  Created by Derrick kim on 8/21/24.
//

import Combine
import UIKit

public extension UIGestureRecognizer {
    var publisher: AnyPublisher<UIGestureRecognizer, Never> {
        GesturePublisher(gesture: self).eraseToAnyPublisher()
    }
}

// MARK: - Gesture Publisher

public struct GesturePublisher<Gesture: UIGestureRecognizer>: Publisher {
    public typealias Output = Gesture
    public typealias Failure = Never

    let gesture: Gesture

    public func receive<S>(subscriber: S) where S: Subscriber, Failure == S.Failure, Output == S.Input {
        let subscription = GestureSubscription(
            subscriber: subscriber,
            gesture: gesture
        )
        subscriber.receive(subscription: subscription)
    }
}

public final class GestureSubscription<S: Subscriber, Gesture: UIGestureRecognizer>: Subscription
where S.Input == Gesture, S.Failure == Never {
    private var subscriber: S?
    private weak var gesture: Gesture?

    init(subscriber: S, gesture: Gesture) {
        self.subscriber = subscriber
        self.gesture = gesture
        gesture.addTarget(self, action: #selector(handleGesture))
    }

    public func request(_ demand: Subscribers.Demand) { }

    public func cancel() {
        subscriber = nil
        gesture?.removeTarget(self, action: #selector(handleGesture))
    }

    @objc private func handleGesture() {
        guard let gesture = gesture else { return }
        _ = subscriber?.receive(gesture)
    }
}
