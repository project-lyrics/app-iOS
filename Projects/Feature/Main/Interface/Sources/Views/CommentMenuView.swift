//
//  CommentMenuView.swift
//  FeatureMainInterface
//
//  Created by 황인우 on 9/10/24.
//

import UIKit

import FlexLayout
import PinLayout
import Shared

public enum CommentMenuType: Equatable {
    case other
    case me
}

public final class CommentMenuView: UIView {
    private let menuType: CommentMenuType
    
    public init(
        menuType: CommentMenuType,
        frame: CGRect = .zero
    ) {
        self.menuType = menuType
        super.init(frame: frame)
        
        self.backgroundColor = Colors.modal
        self.setUpLayout()
    }
    
    @available(*, unavailable)
    public required init?(coder: NSCoder) {
        fatalError()
    }
    
    // MARK: - UI Components
    
    private let flexContainer = UIView()
    
    private (set) var editButton: NoteMenuItemButton = {
        let button = NoteMenuItemButton(
            image: FeelinImages.pencilEdit,
            description: "수정하기"
        )
        button.setBackgroundImage(Colors.gray01.image(), for: .highlighted)
        
        return button
    }()
    
    private (set) var deleteButton: NoteMenuItemButton = {
        let button = NoteMenuItemButton(
            image: FeelinImages.trash,
            description: "삭제하기"
        )
        button.setBackgroundImage(Colors.gray01.image(), for: .highlighted)
        
        return button
    }()
    
    private (set) var reportButton: NoteMenuItemButton = {
        let button = NoteMenuItemButton(
            image: FeelinImages.report,
            description: "신고하기"
        )
        button.setBackgroundImage(Colors.gray01.image(), for: .highlighted)
        
        return button
    }()
    
    // MARK: - Layout
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        
        flexContainer.pin.all(pin.safeArea)
        flexContainer.flex.layout()
    }
    
    private func setUpLayout() {
        addSubview(flexContainer)
        
        flexContainer.flex
            .alignItems(.start)
            .define { flex in
                flex.addItem()
                    .size(.init(width: 56, height: 5))
                    .backgroundColor(Colors.gray02)
                    .cornerRadius(2.5)
                    .alignSelf(.center)
                    .marginTop(12)
                    .marginBottom(22)
                
                switch menuType {
                case .other:
                    flex.addItem(reportButton)
                        .height(50)
                        .width(100%)
                    
                case .me:
                    flex.addItem(deleteButton)
                        .height(50)
                        .width(100%)
                }
            }
    }
}
