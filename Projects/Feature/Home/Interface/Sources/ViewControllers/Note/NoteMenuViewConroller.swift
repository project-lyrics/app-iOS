//
//  NoteMenuViewConroller.swift
//  FeatureHomeInterface
//
//  Created by 황인우 on 9/1/24.
//

import Domain
import Shared

import Combine
import UIKit

public class NoteMenuViewConroller: BottomSheetViewController<NoteMenuView> {
    private let note: Note

    private var cancellable: Set<AnyCancellable> = .init()
    
    private var onReport: PassthroughSubject<Int, Never>
    private var onEdit: PassthroughSubject<Note, Never>
    private var onDelete: PassthroughSubject<Int, Never>
    
    public init(
        note: Note,
        bottomSheetHeight: CGFloat,
        bottomSheetView: NoteMenuView,
        onReport: PassthroughSubject<Int, Never>,
        onEdit: PassthroughSubject<Note, Never>,
        onDelete: PassthroughSubject<Int, Never>
    ) {
        self.note = note
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
            .sink { [note, unowned self] _ in
                self.onReport.send(note.id)
            }
            .store(in: &cancellable)
        
        bottomSheetView.editButton.publisher(for: .touchUpInside)
            .flatMap({ [unowned self] _ -> AnyPublisher<Void, Never> in
                return self.dismissPublisher(animated: true)
            })
            .sink { [note, unowned self] _ in
                self.onEdit.send(note)
            }
            .store(in: &cancellable)
        
        bottomSheetView.deleteButton.publisher(for: .touchUpInside)
            .flatMap({ [unowned self] _ -> AnyPublisher<Void, Never> in
                return self.dismissPublisher(animated: true)
            })
            .sink { [note, unowned self] _ in
                self.onDelete.send(note.id)
            }
            .store(in: &cancellable)
    }
}

#if canImport(SwiftUI)
import SwiftUI

struct NoteMenuViewConroller_Preview: PreviewProvider {
    static var previews: some View {
        return NoteMenuViewConroller(
            note: Note.mockData.first!,
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
