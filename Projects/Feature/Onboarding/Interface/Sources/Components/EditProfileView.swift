//
//  EditProfileView.swift
//  FeatureOnboardingInterface
//
//  Created by jiyeon on 6/14/24.
//

import UIKit

import Shared

import FlexLayout
import PinLayout

public final class EditProfileView: UIView {
    // MARK: - components
    
    private let flexContainer = UIView()
    
    private let titleLabel = {
        let label = UILabel()
        label.text = "프로필 캐릭터"
        label.font = SharedDesignSystemFontFamily.Pretendard.semiBold.font(size: 16)
        label.textColor = Colors.gray09
        return label
    }()
    
    let xButton = {
        let button = UIButton()
        button.setImage(FeelinImages.xLight, for: .normal)
        return button
    }()
    
    let profileCharacterCollectionView = ProfileCharacterCollectionView()
    
    lazy var selectButton = FeelinConfirmButton(title: "선택")
    
    // MARK: - init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = Colors.background
        setUpLayout()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - layout
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        
        flexContainer.pin.all(pin.safeArea)
        flexContainer.flex.layout()
    }
    
    private func setUpLayout() {
        addSubview(flexContainer)
        flexContainer.flex.paddingHorizontal(20).define { flex in
            flex.addItem()
                .direction(.row)
                .justifyContent(.spaceBetween)
                .marginTop(24)
                .define { flex in
                    flex.addItem(titleLabel)
                    flex.addItem(xButton)
                        .width(20)
                        .height(20)
                }
            
            flex.addItem(profileCharacterCollectionView)
                .height(80)
                .marginTop(24)
            
            flex.addItem()
                .grow(1)
            
            flex.addItem(selectButton)
                .height(56)
                .cornerRadius(8)
                .marginBottom(23)
        }
    }
}
