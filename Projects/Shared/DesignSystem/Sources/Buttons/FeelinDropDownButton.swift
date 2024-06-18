//
//  FeelinDropDownButton.swift
//  FeatureOnboardingInterface
//
//  Created by jiyeon on 6/13/24.
//

import UIKit

import FlexLayout
import PinLayout

public final class FeelinDropDownButton: UIButton {
    private var isInitialAppearance = true
    
    // MARK: - Components
    
    private let flexContainer: UIView = {
        let view = UIView()
        view.isUserInteractionEnabled = false
        return view
    }()
    
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = SharedDesignSystemFontFamily.Pretendard.semiBold.font(size: 16)
        return label
    }()
    
    private lazy var dropDownImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = FeelinImages.caretDownLight
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    // MARK: - init
    
    public init(description: String) {
        super.init(frame: .zero)
        setUpLayout()
        configureInitialAppearance(with: description)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - layout
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        
        flexContainer.pin.all()
        flexContainer.flex.layout()
    }
    
    private func setUpLayout() {
        addSubview(flexContainer)
        flexContainer.flex.justifyContent(.center).define { flex in
            flex.addItem(descriptionLabel)
                .position(.absolute)
                .alignSelf(.center)
            
            flex.addItem(dropDownImageView)
                .position(.absolute)
                .right(20)
        }
    }
    
    // MARK: - appearance
    
    private func configureInitialAppearance(with description: String) {
        descriptionLabel.text = description
        descriptionLabel.textColor = Colors.gray03
        layer.borderWidth = 1
        layer.borderColor = Colors.gray01.cgColor
    }
    
    private func updateAppearanceAfterFirstSet() {
        descriptionLabel.textColor = Colors.alertSuccess
        dropDownImageView.isHidden = true
        layer.borderWidth = 0
        backgroundColor = Colors.secondary
    }
    
    public func setDescription(_ description: String?) {
        if isInitialAppearance {
            updateAppearanceAfterFirstSet()
        }
        isInitialAppearance = false
        descriptionLabel.text = description
    }
}
