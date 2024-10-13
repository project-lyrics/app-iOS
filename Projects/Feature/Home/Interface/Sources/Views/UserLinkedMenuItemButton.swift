//
//  UserLinkedMenuItemButton.swift
//  FeatureHomeInterface
//
//  Created by 황인우 on 10/13/24.
//

import UIKit

import FlexLayout
import PinLayout
import Shared

class UserLinkedMenuItemButton: UIButton {
    private var itemDescriptionLabel: UILabel
    
    public init(
        description: String,
        frame: CGRect = .zero
    ) {
        
        self.itemDescriptionLabel = UILabel()
        itemDescriptionLabel.text = description
        itemDescriptionLabel.textAlignment = .left
        itemDescriptionLabel.font = SharedDesignSystemFontFamily.Pretendard.regular.font(size: 16)
        itemDescriptionLabel.textColor = Colors.gray09
        
        super.init(frame: frame)
        
        self.setUpLayout()
    }
    
    @available(*, unavailable)
    public required init?(coder: NSCoder) {
        fatalError()
    }
    
    // MARK: - Layout
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        
        flexContainer.pin.all()
        flexContainer.flex.layout()
    }
    
    private func setUpLayout() {
        addSubview(flexContainer)
        
        flexContainer.flex
            .direction(.row)
            .alignItems(.center)
            .define { flex in
                flex.addItem(itemDescriptionLabel)
                    .width(100%)
            }
            .paddingLeft(20)
    }
    
    // MARK: - UI Components
    
    private let flexContainer: UIView = {
        let view = UIView()
        view.isUserInteractionEnabled = false
        
        return view
    }()
    
}

