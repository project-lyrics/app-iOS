//
//  NoteMenuItemButton.swift
//  FeatureMainInterface
//
//  Created by 황인우 on 9/1/24.
//

import UIKit

import FlexLayout
import PinLayout
import Shared

public final class NoteMenuItemButton: UIButton {
    private var itemImageView: UIImageView
    private var itemDescriptionLabel: UILabel
    
    public init(
        image: UIImage,
        description: String,
        frame: CGRect = .zero
    ) {
        self.itemImageView = UIImageView(image: image)
        itemImageView.contentMode = .scaleAspectFit
        
        self.itemDescriptionLabel = UILabel()
        itemDescriptionLabel.text = description
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
                flex.addItem(itemImageView)
                    .size(.init(width: 24, height: 24))
                    .marginRight(12)
                
                flex.addItem(itemDescriptionLabel)
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
