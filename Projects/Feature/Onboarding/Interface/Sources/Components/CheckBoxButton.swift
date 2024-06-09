//
//  CheckBoxButton.swift
//  FeatureOnboardingInterface
//
//  Created by 황인우 on 6/9/24.
//

import FlexLayout
import SharedDesignSystem
import UIKit

open class CheckBoxButton: UIButton {
    let flexContainer = UIView()
    
    private var uncheckedImage: UIImage = SharedDesignSystem.FeelinImages.checkBoxInactive
    private var checkedImage = SharedDesignSystem.FeelinImages.checkBoxActive
    
    private (set) public var isChecked: Bool = false {
        didSet {
            updateImage()
        }
    }
    
    // MARK: - View
    private var checkBoxImageView: UIImageView = {
        let imageView = UIImageView(image: SharedDesignSystem.FeelinImages.checkBoxInactive)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        
        return imageView
    }()
    
    private var additionalView: UIView?
    
    public init(
        additionalView: UIView? = nil,
        action: UIAction? = nil
    ) {
        super.init(frame: .zero)
        if let action = action {
            self.addAction(action, for: .touchUpInside)
        }
        addSubview(flexContainer)
        self.additionalView = additionalView
        
        if let additionalView = additionalView {
            addSubview(additionalView)
        }
        
        setupButton()
    }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        setupButton()
    }
    
    required public init?(coder: NSCoder) {
        super.init(coder: coder)
        setupButton()
    }
    
    open override func layoutSubviews() {
        super.layoutSubviews()
        
        flexContainer.pin.all()
        flexContainer.flex.layout()
    }
    
    private func setupButton() {
        addTarget(
            self,
            action: #selector(buttonTapped),
            for: .touchUpInside
        )
        updateImage()
        setUpView()
    }
    
    @objc private func buttonTapped() {
        isChecked.toggle()
        isSelected.toggle()
    }
    
    private func updateImage() {
        let image = isChecked ? checkedImage : uncheckedImage
        self.checkBoxImageView.image = image
    }
    
    private func setUpView() {
        flexContainer.isUserInteractionEnabled = false
        
        flexContainer.flex
            .alignSelf(.center)
            .direction(.row).define { flex in
            flex.addItem(checkBoxImageView)
                .marginLeft(18)
            
            if let additionalView = additionalView {
                flex.addItem(additionalView)
            }
        }
    }
}
