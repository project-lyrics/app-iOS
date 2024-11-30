//
//  NoteMenuHandling.swift
//  FeatureHomeInterface
//
//  Created by 황인우 on 9/7/24.
//

import Combine
import UIKit

import Domain
import Shared

public protocol NoteMenuHandling where Self: UIViewController {
    var userInfo: UserInformation? { get }
    var onReportNote: PassthroughSubject<Int, Never> { get }
    var onEditNote: PassthroughSubject<Note, Never> { get }
    var onDeleteNote: PassthroughSubject<Int, Never> { get }
    var onBlockNotePublisher: PassthroughSubject<User, Never> { get }
    
    func makeNoteMenuViewController(checking note: Note) -> NoteMenuViewConroller?
    func showBlockPublisherAlert(
        onConfirm: (() -> Void)?,
        onCancel: (() -> Void)?
    )
    func showBlockPublisherResultAlert(onConfirm: (() -> Void)?)
}

public extension NoteMenuHandling {
    func makeNoteMenuViewController(checking note: Note) -> NoteMenuViewConroller? {
        if let userId = self.userInfo?.userID {
            let bottomSheetHeight: CGFloat = 180
            
            let menuType = userId == note.publisher.id ? NoteMenuType.me : NoteMenuType.other
            
            let noteMenuViewController = NoteMenuViewConroller(
                note: note,
                bottomSheetHeight: bottomSheetHeight,
                bottomSheetView: NoteMenuView(menuType: menuType),
                onReport: self.onReportNote,
                onEdit: self.onEditNote,
                onDelete: self.onDeleteNote,
                onBlockNotePublisher: self.onBlockNotePublisher
            )
            noteMenuViewController.modalPresentationStyle = .overFullScreen
            
            return noteMenuViewController
        }
        
        return nil
    }
    
    func showBlockPublisherAlert(
        onConfirm: (() -> Void)? = nil,
        onCancel: (() -> Void)? = nil
    ) {
        self.showAlert(
            title: "해당 유저를 차단하시겠어요?",
            message: "차단 시 해당 유저의 노트와 댓글을\n볼 수 없어요",
            leftActionTitle: "취소",
            rightActionTitle: "차단",
            leftActionCompletion: onCancel,
            rightActionCompletion: onConfirm
        )
    }
    
    func showBlockPublisherResultAlert(onConfirm: (() -> Void)? = nil) {
        self.showAlert(
            title: "해당 유저가 차단되었어요.",
            message: "마이페이지-설정에서\n 차단 해제할 수 있어요",
            singleActionTitle: "확인",
            actionCompletion: onConfirm
        )
    }
}
