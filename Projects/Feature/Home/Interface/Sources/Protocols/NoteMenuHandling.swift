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
    var onEditNote: PassthroughSubject<Int, Never> { get }
    var onDeleteNote: PassthroughSubject<Int, Never> { get }
    
    func makeNoteMenuViewController(checking note: Note) -> NoteMenuViewConroller?
}

public extension NoteMenuHandling {
    func makeNoteMenuViewController(checking note: Note) -> NoteMenuViewConroller? {
        if let userId = self.userInfo?.userID {
            let bottomSheetHeight: CGFloat = userId == note.publisher.id ? 180 : 130
            
            let menuType = userId == note.publisher.id ? NoteMenuType.me : NoteMenuType.other
            
            let noteMenuViewController = NoteMenuViewConroller(
                noteID: note.id,
                bottomSheetHeight: bottomSheetHeight,
                bottomSheetView: NoteMenuView(menuType: menuType),
                onReport: self.onReportNote,
                onEdit: self.onEditNote,
                onDelete: self.onDeleteNote
            )
            noteMenuViewController.modalPresentationStyle = .overFullScreen
            
            return noteMenuViewController
        }
        
        return nil
    }
}
