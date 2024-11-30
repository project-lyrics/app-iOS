//
//  CommentMenuHandling.swift
//  FeatureHomeInterface
//
//  Created by 황인우 on 9/10/24.
//

import Combine
import UIKit

import Domain
import Shared

public protocol CommentMenuHandling where Self: UIViewController {
    var userInfo: UserInformation? { get }
    var onReportComment: PassthroughSubject<Int, Never> { get }
    var onDeleteComment: PassthroughSubject<Int, Never> { get }
    var onBlockCommentPublisher: PassthroughSubject<User, Never> { get }
    
    func makeCommentMenuViewController(checking comment: Comment) -> CommentMenuViewConroller?
}

public extension CommentMenuHandling {
    func makeCommentMenuViewController(checking comment: Comment) -> CommentMenuViewConroller? {
        if let userId = self.userInfo?.userID {
            let bottomSheetHeight: CGFloat = userId == comment.id ? 130 : 180
            
            let menuType = userId == comment.writer.id
            ? CommentMenuType.me
            : CommentMenuType.other
            
            let commentMenuViewController = CommentMenuViewConroller(
                comment: comment,
                bottomSheetHeight: bottomSheetHeight,
                bottomSheetView: CommentMenuView(menuType: menuType),
                onReport: self.onReportComment,
                onDelete: self.onDeleteComment,
                onBlockPublisher: self.onBlockCommentPublisher
            )
            commentMenuViewController.modalPresentationStyle = .overFullScreen
            
            return commentMenuViewController
        }
        
        return nil
    }
}
