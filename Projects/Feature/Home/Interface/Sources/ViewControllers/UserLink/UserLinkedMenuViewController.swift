//
//  UserLinkedMenuViewController.swift
//  FeatureHomeInterface
//
//  Created by 황인우 on 10/13/24.
//

import Shared

import Combine
import UIKit

public final class UserLinkedMenuViewController: BottomSheetViewController<UserLinkedMenuView> {
    private var cancellable: Set<AnyCancellable> = .init()
    private let linkURL: URL
    
    // MARK: - Subjects
    
    private var onCopyURL: PassthroughSubject<URL, Never>
    private var onOpenURL: PassthroughSubject<URL, Never>
    
    public init(
        linkURL: URL,
        bottomSheetHeight: CGFloat = 160,
        onCopyURL: PassthroughSubject<URL, Never>,
        onOpenURL: PassthroughSubject<URL, Never>
    ) {
        self.linkURL = linkURL
        self.onCopyURL = onCopyURL
        self.onOpenURL = onOpenURL
        
        super.init(bottomSheetHeight: bottomSheetHeight)
    }

    override public func viewDidLoad() {
        super.viewDidLoad()

        self.bindAction()
    }
    
    private func bindAction() {
        bottomSheetView.copyURLButton.publisher(for: .touchUpInside)
            .flatMap { [unowned self] _ -> AnyPublisher<Void, Never> in
                return self.dismissPublisher(animated: true)
            }
            .sink { [unowned self] _ in
                self.onCopyURL.send(self.linkURL)
            }
            .store(in: &cancellable)
        
        bottomSheetView.openURLButton.publisher(for: .touchUpInside)
            .flatMap { [unowned self] _ -> AnyPublisher<Void, Never> in
                return self.dismissPublisher(animated: true)
            }
            .sink { [unowned self] _ in
                self.onOpenURL.send(self.linkURL)
            }
            .store(in: &cancellable)
    }
}
