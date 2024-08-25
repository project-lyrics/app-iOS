//
//  UIGestureRecognizer+Combine.swift
//  SharedUtil
//
//  Created by Derrick kim on 8/21/24.
//

import Combine
import UIKit

public extension UITapGestureRecognizer {
    // UITapGestureRecognizer를 Combine 퍼블리셔로 확장
    var publisher: AnyPublisher<UITapGestureRecognizer, Never> {
        GesturePublisher(gesture: self).eraseToAnyPublisher()
    }
}

struct GesturePublisher: Publisher {
    typealias Output = UITapGestureRecognizer
    typealias Failure = Never

    let gesture: UITapGestureRecognizer

    func receive<S>(subscriber: S) where S: Subscriber, Failure == S.Failure, Output == S.Input {
        let subscription = GestureSubscription(subscriber: subscriber, gesture: gesture)
        subscriber.receive(subscription: subscription)
    }
}

final class GestureSubscription<S: Subscriber>: Subscription where S.Input == UITapGestureRecognizer {
    private var subscriber: S?
    private weak var gesture: UITapGestureRecognizer?

    init(subscriber: S, gesture: UITapGestureRecognizer) {
        self.subscriber = subscriber
        self.gesture = gesture
        gesture.addTarget(self, action: #selector(handleGesture))
    }

    func request(_ demand: Subscribers.Demand) { }

    func cancel() {
        subscriber = nil
    }

    @objc private func handleGesture() {
        _ = subscriber?.receive(gesture!)
    }
}
