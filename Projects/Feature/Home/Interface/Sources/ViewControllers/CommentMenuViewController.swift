//
//  CommentMenuViewController.swift
//  FeatureHomeInterface
//
//  Created by 황인우 on 9/10/24.
//

import Domain
import Shared

import Combine
import UIKit

public class CommentMenuViewConroller: BottomSheetViewController<CommentMenuView> {
    private let comment: Comment
    
    private var cancellable: Set<AnyCancellable> = .init()
    
    private var onReport: PassthroughSubject<Int, Never>
    private var onDelete: PassthroughSubject<Int, Never>
    private var onBlockPublisher: PassthroughSubject<User, Never>
    
    public init(
        comment: Comment,
        bottomSheetHeight: CGFloat = 130,
        bottomSheetView: CommentMenuView,
        onReport: PassthroughSubject<Int, Never>,
        onDelete: PassthroughSubject<Int, Never>,
        onBlockPublisher: PassthroughSubject<User, Never>
    ) {
        self.comment = comment
        self.onReport = onReport
        self.onDelete = onDelete
        self.onBlockPublisher = onBlockPublisher
        
        super.init(
            bottomSheetHeight: bottomSheetHeight,
            bottomSheetView: bottomSheetView
        )
    }
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        
        self.bindAction()
    }
    
    private func bindAction() {
        bottomSheetView.reportButton.publisher(for: .touchUpInside)
            .flatMap({ [unowned self] _ -> AnyPublisher<Void, Never> in
                return self.dismissPublisher(animated: true)
            })
            .sink { [comment, unowned self] _ in
                self.onReport.send(comment.id)
            }
            .store(in: &cancellable)
        
        bottomSheetView.deleteButton.publisher(for: .touchUpInside)
            .flatMap({ [unowned self] _ -> AnyPublisher<Void, Never> in
                return self.dismissPublisher(animated: true)
            })
            .sink { [comment, unowned self] _ in
                self.onDelete.send(comment.id)
            }
            .store(in: &cancellable)
        
        bottomSheetView.blockUserButton.publisher(for: .touchUpInside)
            .flatMap({ [unowned self] _ -> AnyPublisher<Void, Never> in
                return self.dismissPublisher(animated: true)
            })
            .sink { [comment, unowned self] _ in
                self.onBlockPublisher.send(comment.writer)
            }
            .store(in: &cancellable)
    }
}
