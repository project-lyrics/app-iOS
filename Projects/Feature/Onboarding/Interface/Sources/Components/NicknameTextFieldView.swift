//
//  NicknameTextFieldView.swift
//  FeatureOnboardingInterface
//
//  Created by jiyeon on 6/14/24.
//

import UIKit

import Shared

import FlexLayout
import PinLayout

final class NicknameTextFieldView: UIView {
    private let maxNicknameLength: Int
    
    // MARK: - components
    
    private let flexContainer = UIView()
    
    private let textField = {
        let textField = UITextField()
        textField.placeholder = "닉네임"
        textField.font = SharedDesignSystemFontFamily.Pretendard.semiBold.font(size: 16)
        textField.textColor = Colors.gray08
        textField.borderStyle = .none
        textField.autocorrectionType = .no
        textField.autocapitalizationType = .none
        textField.clearButtonMode = .whileEditing
        return textField
    }()
    
    private let separator = {
        let view = UIView()
        view.backgroundColor = Colors.gray02
        return view
    }()
    
    private lazy var messageLabel = {
        let label = createDescriptionLabel()
        label.textColor = Colors.alertWarning
        label.isHidden = true
        return label
    }()
    
    private lazy var lengthLabel = {
        let label = createDescriptionLabel()
        label.text = "0/\(maxNicknameLength)"
        label.textColor = Colors.gray02
        label.textAlignment = .right
        return label
    }()
    
    // MARK: - init
    
    init(maxNicknameLength: Int) {
        self.maxNicknameLength = maxNicknameLength
        
        super.init(frame: .zero)
        
        setUpLayout()
        textField.addTarget(
            self,
            action: #selector(textFieldEditingChanged),
            for: .editingChanged
        )
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
        flexContainer.flex.define { flex in
            flex.addItem(textField)
                .height(24)
            
            flex.addItem(separator)
                .height(1)
                .marginTop(8)
            
            flex.addItem()
                .direction(.row)
                .justifyContent(.spaceBetween)
                .marginTop(4)
                .define { flex in
                    flex.addItem(messageLabel)
                        .grow(1)
                    flex.addItem(lengthLabel)
                        .width(50)
                }
        }
    }
}

private extension NicknameTextFieldView {
    func createDescriptionLabel() -> UILabel {
        let label = UILabel()
        label.font = SharedDesignSystemFontFamily.Pretendard.regular.font(size: 14)
        return label
    }
}

private extension NicknameTextFieldView {
    @objc private func textFieldEditingChanged(_ textField: UITextField) {
        guard let text = textField.text else { return }
        updateLengthLabel(with: text)
        validateNickname(text)
    }
    
    private func updateLengthLabel(with text: String) {
        let currentNicknameLength = text.count
        lengthLabel.text = "\(currentNicknameLength)/\(maxNicknameLength)"
    }
    
    private func validateNickname(_ text: String) {
        let isCharactersValid = text.containsOnlyAllowedCharacters
        let isLengthValid = text.count <= maxNicknameLength
        
        if !isLengthValid {
            messageLabel.text = "1~10자의 닉네임을 사용해주세요"
        }
        if !isCharactersValid {
            messageLabel.text = "공백, 특수문자, 이모티콘은 사용 불가합니다"
        }
        
        let isValid = isCharactersValid && isLengthValid
        messageLabel.isHidden = isValid
        separator.backgroundColor = isValid ? Colors.gray02 : Colors.alertWarning
        lengthLabel.textColor = isLengthValid ? Colors.gray02 : Colors.alertWarning
    }
}
