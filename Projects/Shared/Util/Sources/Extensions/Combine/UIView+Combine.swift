//
//  UIView+Combine.swift
//  SharedUtil
//
//  Created by Derrick kim on 8/21/24.
//

import Combine
import UIKit

public extension UIView {
    // UIView에서 터치 이벤트를 감지하고 방출하는 퍼블리셔
    var tapPublisher: AnyPublisher<Void, Never> {
        let tapGesture = UITapGestureRecognizer()
        self.addGestureRecognizer(tapGesture)
        self.isUserInteractionEnabled = true // UIView가 터치 이벤트를 받을 수 있도록 설정

        return tapGesture.publisher
            .map { _ in () } // 이벤트 방출 시 Void로 변환
            .eraseToAnyPublisher()
    }

    func publisher(for events: [PublisherEvent]) -> AnyPublisher<IndexPath, Never> {
        return CombineViewPublisher(view: self, events: events)
            .eraseToAnyPublisher()
    }

    enum PublisherEvent {
        case didSelectItem
        case didDeselectItem
    }
}

private struct CombineViewPublisher: Publisher {
    typealias Output = IndexPath
    typealias Failure = Never

    private let view: UIView
    private let events: [UIView.PublisherEvent]

    init(view: UIView, events: [UIView.PublisherEvent]) {
        self.view = view
        self.events = events
    }

    func receive<S>(subscriber: S) where S : Subscriber, Never == S.Failure, IndexPath == S.Input {
        let subscription = CombineViewSubscription(
            subscriber: subscriber,
            view: view,
            events: events
        )

        subscriber.receive(subscription: subscription)
    }
}

private final class CombineViewSubscription<S: Subscriber>: NSObject, Subscription, UICollectionViewDelegate, UITableViewDelegate where S.Input == IndexPath, S.Failure == Never {
    private var subscriber: S?
    private weak var view: UIView?
    private let events: [UIView.PublisherEvent]

    init(
        subscriber: S,
        view: UIView,
        events: [UIView.PublisherEvent]
    ) {
        self.subscriber = subscriber
        self.view = view
        self.events = events
        super.init()

        if let collectionView = view as? UICollectionView {
            if collectionView.delegate == nil { // 중복 방지
                collectionView.delegate = self
            }
        } else if let tableView = view as? UITableView {
            if tableView.delegate == nil { // 중복 방지
                tableView.delegate = self
            }
        }
    }

    func request(_ demand: Subscribers.Demand) { }

    func cancel() {
        subscriber = nil
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if events.contains(.didSelectItem) {
            _ = subscriber?.receive(indexPath)
        }
    }

    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        if events.contains(.didDeselectItem) {
            _ = subscriber?.receive(indexPath)
        }
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if events.contains(.didSelectItem) {
            _ = subscriber?.receive(indexPath)
        }
    }

    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        if events.contains(.didDeselectItem) {
            _ = subscriber?.receive(indexPath)
        }
    }
}
