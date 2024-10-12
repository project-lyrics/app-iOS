//
//  CheckAllAgreeButton.swift
//  FeatureOnboardingInterface
//
//  Created by 황인우 on 10/12/24.
//

import Shared

import UIKit

class CheckAllAgreeButton: UIButton {
    
    // MARK: - UI Components
    
    private let flexContainer: UIView = {
        let view = UIView()
        view.isUserInteractionEnabled = false
        
        return view
    }()
    
    private let selectedImage: UIImage = FeelinImages.checkBoxActive
    private let unSelectedImage: UIImage = FeelinImages.checkBoxInactive
    
    private let checkmarkImageView = UIImageView()
    
    private lazy var allAgreeLabel: UILabel = {
        let label = UILabel()
        label.text = description
        label.font = SharedDesignSystemFontFamily.Pretendard.semiBold.font(size: 16)
        label.textColor = Colors.gray04
        label.text = "전체동의"
        return label
    }()
    
    override init(frame: CGRect = .zero) {
        super.init(frame: frame)
        setUpButton()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError()
    }

    override var isSelected: Bool {
        didSet {
            updateButtonImage()
            updateTitleColor()
            updateButtonBackgroundColor()
        }
    }
    
    private func setUpButton() {
        self.layer.cornerRadius = 8
        updateButtonImage()
        updateTitleColor()
        updateButtonBackgroundColor()
        setUpLayout()
        self.addTarget(
            self,
            action: #selector(buttonTapped),
            for: .touchUpInside
        )
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        flexContainer.pin.all()
        flexContainer.flex.layout()
    }
    
    private func setUpLayout() {
        addSubview(flexContainer)
        
        flexContainer.flex
            .cornerRadius(8)
            .border(2, Colors.fixedGray01)
            .paddingHorizontal(18)
            .paddingVertical(14)
            .direction(.row)
            .define { flex in
                flex.addItem(checkmarkImageView)
                    .marginRight(14)
                
                flex.addItem(allAgreeLabel)
            }
    }
    
    @objc private func buttonTapped() {
        isSelected.toggle()
        updateButtonImage()
        updateButtonBackgroundColor()
        updateTitleColor()
    }
    
    private func updateButtonImage() {
        let image = isSelected ? selectedImage : unSelectedImage
        checkmarkImageView.image = image
    }
    
    private func updateButtonBackgroundColor() {
        self.backgroundColor = isSelected
        ? Colors.pressedBrand
        : Colors.background
    }
    
    private func updateTitleColor() {
        self.allAgreeLabel.textColor = isSelected
        ? Colors.alertSuccess
        : Colors.gray04
    }
}
