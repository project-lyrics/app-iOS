//
//  UserLinkedMenuView.swift
//  FeatureHomeInterface
//
//  Created by 황인우 on 10/13/24.
//

import UIKit

import FlexLayout
import PinLayout
import Shared

public final class UserLinkedMenuView: UIView {
    
    // MARK: - init
    
    override public init(frame: CGRect) {
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
    
    private (set) var copyURLButton: UserLinkedMenuItemButton = {
        let button = UserLinkedMenuItemButton(description: "url 복사")
        button.setBackgroundImage(Colors.gray01.image(), for: .highlighted)
        
        return button
    }()
    
    private (set) var openURLButton: UserLinkedMenuItemButton = {
        let button = UserLinkedMenuItemButton(description: "기본 브라우저에서 열기")
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
                
                flex.addItem(copyURLButton)
                    .height(50)
                    .width(100%)
                
                flex.addItem(openURLButton)
                    .height(50)
                    .width(100%)
            }
    }
}
