//
//  BirthYearDropDownView.swift
//  FeatureOnboardingInterface
//
//  Created by jiyeon on 6/13/24.
//

import UIKit

import SharedDesignSystem

import FlexLayout
import PinLayout

final class BirthYearDropDownView: UIView {
    
    private var isBirthYearSet = false
    
    // MARK: - components
    
    private let flexContainer = UIView()
    
    private let titleLabel = {
        let label = UILabel()
        label.text = "출생 연도를 입력해주세요"
        label.textColor = Colors.gray03
        label.textAlignment = .center
        label.font = SharedDesignSystemFontFamily.Pretendard.semiBold.font(size: 16)
        return label
    }()
    
    private let dropDownImageView = {
        let imageView = UIImageView()
        imageView.image = SharedDesignSystem.FeelinImages.caretDownLight
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    // MARK: - init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpLayout()
        initAppearance()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - layout
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        flexContainer.pin.all()
        flexContainer.flex.layout()
    }
    
    private func setUpLayout() {
        addSubview(flexContainer)
        flexContainer.flex.justifyContent(.center).define { flex in
            flex.addItem(titleLabel)
                .position(.absolute)
                .alignSelf(.center)
            
            flex.addItem(dropDownImageView)
                .position(.absolute)
                .right(20)
        }
    }
    
    private func initAppearance() {
        isUserInteractionEnabled = true
        
        clipsToBounds = true
        layer.cornerRadius = 8
        layer.borderWidth = 1
        layer.borderColor = Colors.gray01.cgColor
    }
    
    private func updateAppearance() {
        titleLabel.textColor = Colors.alertSuccess
        dropDownImageView.isHidden = true
        
        backgroundColor = Colors.secondary
        layer.borderWidth = 0
    }
    
    func setBirthYear(_ birthYear: Int) {
        if isBirthYearSet == false {
            updateAppearance()
        }
        isBirthYearSet = true
        titleLabel.text = "\(birthYear)년"
    }
}
