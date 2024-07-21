//
//  CombineControlProperty.swift
//  SharedUtil
//
//  Created by 황인우 on 7/17/24.
//

import Combine
import Foundation
import UIKit

// MARK: - Publisher

public extension Combine.Publishers {
    /// A Control Property is a publisher that emits the value at the provided keypath
    /// whenever the specific control events are triggered. It also emits the keypath's
    /// initial value upon subscription.
    struct ControlProperty<Control: UIControl, Value>: Publisher {
        public typealias Output = Value
        public typealias Failure = Never

        private let control: Control
        private let controlEvents: Control.Event
        private let keyPath: KeyPath<Control, Value>

        /// Initialize a publisher that emits the value at the specified keypath
        /// whenever any of the provided Control Events trigger.
        ///
        /// - parameter control: UI Control.
        /// - parameter events: Control Events.
        /// - parameter keyPath: A Key Path from the UI Control to the requested value.
        public init(control: Control,
                    events: Control.Event,
                    keyPath: KeyPath<Control, Value>) {
            self.control = control
            self.controlEvents = events
            self.keyPath = keyPath
        }

        public func receive<S: Subscriber>(subscriber: S) where S.Failure == Failure, S.Input == Output {
            let subscription = Subscription(subscriber: subscriber,
                                            control: control,
                                            event: controlEvents,
                                            keyPath: keyPath)

            subscriber.receive(subscription: subscription)
        }
    }
}

// MARK: - Subscription

extension Combine.Publishers.ControlProperty {
    private final class Subscription<S: Subscriber, uiControl: UIControl, inputValue>: Combine.Subscription where S.Input == inputValue {
        private var subscriber: S?
        weak private var control: uiControl?
        let keyPath: KeyPath<uiControl, inputValue>
        private var didEmitInitial = false
        private let event: uiControl.Event

        init(
            subscriber: S,
            control: uiControl,
            event: uiControl.Event,
            keyPath: KeyPath<uiControl,
            inputValue>
        ) {
            self.subscriber = subscriber
            self.control = control
            self.keyPath = keyPath
            self.event = event
            control.addTarget(
                self,
                action: #selector(processControlEvent),
                for: event
            )
        }

        func request(_ demand: Subscribers.Demand) {
            // Emit initial value upon first demand request
            if !didEmitInitial,
                demand > .none,
                let control = control,
                let subscriber = subscriber {
                _ = subscriber.receive(control[keyPath: keyPath])
                didEmitInitial = true
            }

            // We don't care about the demand at this point.
            // As far as we're concerned - UIControl events are endless until the control is deallocated.
        }

        func cancel() {
            control?.removeTarget(self, action: #selector(processControlEvent), for: event)
            subscriber = nil
        }

        @objc private func processControlEvent() {
            guard let control = control else { return }
            _ = subscriber?.receive(control[keyPath: keyPath])
        }
    }
}

extension UIControl.Event {
    static var defaultValueEvents: UIControl.Event {
        return [.allEditingEvents, .valueChanged]
    }
}
