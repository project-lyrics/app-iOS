//
//  UICollectionView+.swift
//  SharedUtil
//
//  Created by jiyeon on 6/14/24.
//

import UIKit
import Combine

public extension UICollectionView {
    final func register<Cell: UICollectionViewCell>(cellType: Cell.Type) where Cell: Reusable {
        self.register(cellType.self, forCellWithReuseIdentifier: cellType.reuseIdentifier)
    }

    final func dequeueReusableCell<Cell: UICollectionViewCell>(
        for indexPath: IndexPath,
        cellType: Cell.Type = Cell.self
    ) -> Cell where Cell: Reusable {
        guard let cell = self.dequeueReusableCell(withReuseIdentifier: cellType.reuseIdentifier, for: indexPath) as? Cell else {
            fatalError("Could not dequeue cell with identifier: \(cellType.reuseIdentifier)")
        }
        return cell
    }
}

// MARK: Combine Cocoa

public extension UICollectionView {
    func publisher(for events: [PublisherEvent]) -> AnyPublisher<IndexPath, Never> {
        return CombineCollectionViewPublisher(collectionView: self, events: events)
            .eraseToAnyPublisher()
    }

    enum PublisherEvent {
        case didSelectItem
        case didDeselectItem
    }
}

private struct CombineCollectionViewPublisher: Publisher {
    typealias Output = IndexPath
    typealias Failure = Never

    private let collectionView: UICollectionView
    private let events: [UICollectionView.PublisherEvent]

    init(collectionView: UICollectionView, events: [UICollectionView.PublisherEvent]) {
        self.collectionView = collectionView
        self.events = events
    }

    func receive<S>(subscriber: S) where S : Subscriber, Never == S.Failure, IndexPath == S.Input {
        let subscription = CombineCollectionViewSubscription(
            subscriber: subscriber,
            collectionView: collectionView,
            events: events
        )
        subscriber.receive(subscription: subscription)
    }
}

private final class CombineCollectionViewSubscription<S: Subscriber>: NSObject, Subscription, UICollectionViewDelegate where S.Input == IndexPath, S.Failure == Never {
    private var subscriber: S?
    private weak var collectionView: UICollectionView?
    private let events: [UICollectionView.PublisherEvent]

    init(
        subscriber: S,
        collectionView: UICollectionView,
        events: [UICollectionView.PublisherEvent]
    ) {
        self.subscriber = subscriber
        self.collectionView = collectionView
        self.events = events
        super.init()
        self.collectionView?.delegate = self
    }

    /// Subscribers.Demand는 Combine의 백프레셔(Backpressure)를 제어하기 위한 것
    /// 여기서는 기본적으로 무시하고 이벤트가 발생할 때마다 전송하는 방식으로 구현
    func request(_ demand: Subscribers.Demand) { }

    func cancel() {
        subscriber = nil
    }

    func collectionView(
        _ collectionView: UICollectionView,
        didSelectItemAt indexPath: IndexPath
    ) {
        if events.contains(.didSelectItem) {
            _ = subscriber?.receive(indexPath)
        }
    }

    func collectionView(
        _ collectionView: UICollectionView,
        didDeselectItemAt indexPath: IndexPath
    ) {
        if events.contains(.didDeselectItem) {
            _ = subscriber?.receive(indexPath)
        }
    }
}
