//
//  IncludeNoteButton.swift
//  FeatureMainInterface
//
//  Created by 황인우 on 9/7/24.
//

import Shared

import UIKit

class IncludeNoteButton: UIButton {
    
    // MARK: - UI Components
    
    private var flexContainer: UIView = {
        let view = UIView()
        view.isUserInteractionEnabled = false
        
        return view
    }()
    
    private let checkBoxImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.image = FeelinImages.checkmarkInactive
        
        return imageView
    }()
    
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.text = "가사 포함된 노트만 보기"
        label.textColor = Colors.gray03
        label.font = SharedDesignSystemFontFamily.Pretendard.medium.font(size: 12)
        
        return label
    }()
    
    override var isSelected: Bool {
        didSet {
            updateButtonUI()
        }
    }
    
    // MARK: - init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.setUpButton()
        self.setUpLayout()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        flexContainer.pin.all()
        flexContainer.flex.layout()
    }
    
    // MARK: - SetUp
    
    private func setUpButton() {
        self.updateButtonUI()
        addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
    }
    
    private func updateButtonUI() {
        self.checkBoxImageView.image = isSelected
        ? FeelinImages.checkmarkActive
        : FeelinImages.checkmarkInactive
        
        self.descriptionLabel.textColor = isSelected
        ? Colors.primary
        : Colors.gray03
    }
    
    private func setUpLayout() {
        self.addSubview(flexContainer)
        
        self.flexContainer.flex
            .direction(.row)
            .define { flex in
                flex.addItem(checkBoxImageView)
                
                flex.addItem(descriptionLabel)
            }
    }
    
    @objc private func buttonTapped() {
        isSelected.toggle()
        updateButtonUI()
    }
}

#if canImport(SwiftUI)
import SwiftUI

struct IncludeNoteButton_Preview: PreviewProvider {
    static var previews: some View {
        IncludeNoteButton(
            frame: .init(x: 0,
            y: 0,
            width: 150,
            height: 24)
        )
        .showPreview()
    }
}

#endif
