//
//  ProfileView.swift
//  FeatureOnboardingInterface
//
//  Created by jiyeon on 6/14/24.
//

import UIKit

import Shared

import FlexLayout
import PinLayout

final class ProfileView: UIView {
    private let maxNicknameLength = 10
    
    // MARK: - components
    
    private let flexContainer = UIView()
    
    private let titleLabel = {
        let label = UILabel()
        label.text = "프로필을 설정해주세요"
        label.font = SharedDesignSystemFontFamily.Pretendard.bold.font(size: 24)
        label.textColor = Colors.gray08
        return label
    }()
    
    let profileEditButton = ProfileEditButton()
    
    private lazy var guideLabel = {
        let label = UILabel()
        label.setTextWithLineHeight(
            "*닉네임은 한/영/숫자 상관없이 \(maxNicknameLength)자 이내\n(공백, 특수문자, 이모티콘 사용 불가)",
            lineHeight: 20
        )
        label.font = SharedDesignSystemFontFamily.Pretendard.regular.font(size: 14)
        label.textColor = Colors.gray04
        return label
    }()
    
    private lazy var nicknameTextFieldView = FeelinLineInputField(
        maxLength: maxNicknameLength,
        placeholder: "텍스트",
        lengthExceededMessage: "1~10자의 닉네임을 사용해주세요",
        validationRules: [
            { (nickname) in
                let regex = "^[ㄱ-ㅎ가-힣a-zA-Z0-9]*$"
                let isValid = NSPredicate(format: "SELF MATCHES %@", regex).evaluate(with: nickname)
                return (isValid, isValid ? nil : "공백, 특수문자, 이모티콘은 사용 불가합니다")
            }
        ]
    )
    
    let nextButton = FeelinConfirmButton(title: "다음")
    
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
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        flexContainer.pin.all(pin.safeArea)
        flexContainer.flex.layout()
    }
    
    private func setUpLayout() {
        addSubview(flexContainer)
        flexContainer.flex.paddingHorizontal(20).define { flex in
            flex.addItem(titleLabel)
                .marginTop(72)
            
            flex.addItem(profileEditButton)
                .marginTop(40)
            
            flex.addItem(guideLabel)
                .marginTop(40)
            
            flex.addItem(nicknameTextFieldView)
                .marginTop(20)
            
            flex.addItem()
                .grow(1)
            
            flex.addItem(nextButton)
                .minHeight(56)
                .cornerRadius(8)
                .marginBottom(23)
        }
    }
}
