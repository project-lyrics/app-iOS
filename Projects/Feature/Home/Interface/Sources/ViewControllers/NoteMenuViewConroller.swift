//
//  NoteMenuViewConroller.swift
//  FeatureHomeInterface
//
//  Created by 황인우 on 9/1/24.
//

import Shared

import Combine
import UIKit

public class NoteMenuViewConroller: BottomSheetViewController<NoteMenuView> {
    private let noteID: Int
    
    private var cancellable: Set<AnyCancellable> = .init()
    
    private var onReport: PassthroughSubject<Int, Never>
    private var onEdit: PassthroughSubject<Int, Never>
    private var onDelete: PassthroughSubject<Int, Never>
    
    public init(
        noteID: Int,
        bottomSheetHeight: CGFloat,
        bottomSheetView: NoteMenuView,
        onReport: PassthroughSubject<Int, Never>,
        onEdit: PassthroughSubject<Int, Never>,
        onDelete: PassthroughSubject<Int, Never>
    ) {
        self.noteID = noteID
        self.onReport = onReport
        self.onEdit = onEdit
        self.onDelete = onDelete
        
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
            .sink { [noteID, unowned self] _ in
                self.onReport.send(noteID)
            }
            .store(in: &cancellable)
        
        bottomSheetView.editButton.publisher(for: .touchUpInside)
            .flatMap({ [unowned self] _ -> AnyPublisher<Void, Never> in
                return self.dismissPublisher(animated: true)
            })
            .sink { [noteID, unowned self] _ in
                self.onEdit.send(noteID)
            }
            .store(in: &cancellable)
        
        bottomSheetView.deleteButton.publisher(for: .touchUpInside)
            .flatMap({ [unowned self] _ -> AnyPublisher<Void, Never> in
                return self.dismissPublisher(animated: true)
            })
            .sink { [noteID, unowned self] _ in
                self.onDelete.send(noteID)
            }
            .store(in: &cancellable)
    }
}

#if canImport(SwiftUI)
import SwiftUI

struct NoteMenuViewConroller_Preview: PreviewProvider {
    static var previews: some View {
        return NoteMenuViewConroller(
            noteID: 180,
            bottomSheetHeight: 180,
                bottomSheetView: NoteMenuView(menuType: .me,
            frame: .zero),
            onReport: .init(),
            onEdit: .init(),
            onDelete: .init()
        )
        .asPreview()
    }
}

#endif
