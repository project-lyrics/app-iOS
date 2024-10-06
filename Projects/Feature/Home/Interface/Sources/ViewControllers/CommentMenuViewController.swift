//
//  CommentMenuViewController.swift
//  FeatureHomeInterface
//
//  Created by 황인우 on 9/10/24.
//

import Shared

import Combine
import UIKit

public class CommentMenuViewConroller: BottomSheetViewController<CommentMenuView> {
    private let commentID: Int
    
    private var cancellable: Set<AnyCancellable> = .init()
    
    private var onReport: PassthroughSubject<Int, Never>
    private var onDelete: PassthroughSubject<Int, Never>
    
    public init(
        commentID: Int,
        bottomSheetHeight: CGFloat = 130,
        bottomSheetView: CommentMenuView,
        onReport: PassthroughSubject<Int, Never>,
        onDelete: PassthroughSubject<Int, Never>
    ) {
        self.commentID = commentID
        self.onReport = onReport
        self.onDelete = onDelete
        
        super.init(
            bottomSheetHeight: bottomSheetHeight,
            bottomSheetView: bottomSheetView
        )
    }
    
    deinit {
        print("CommentMenuViewConroller deinit")
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
            .sink { [commentID, unowned self] _ in
                self.onReport.send(commentID)
            }
            .store(in: &cancellable)
        
        bottomSheetView.deleteButton.publisher(for: .touchUpInside)
            .flatMap({ [unowned self] _ -> AnyPublisher<Void, Never> in
                return self.dismissPublisher(animated: true)
            })
            .sink { [commentID, unowned self] _ in
                self.onDelete.send(commentID)
            }
            .store(in: &cancellable)
    }
}
