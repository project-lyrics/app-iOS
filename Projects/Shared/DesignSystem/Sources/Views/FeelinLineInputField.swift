//
//  FeelinLineInputField.swift
//  FeatureOnboardingInterface
//
//  Created by jiyeon on 6/14/24.
//

import UIKit

import FlexLayout
import PinLayout

/// `FeelinLineInputField`는 사용자로부터 텍스트 입력을 받고, 입력된 텍스트의 유효성을 검증하여 적절한 메시지를 표시하는 뷰입니다.
/// 이 뷰는 입력된 텍스트의 길이를 실시간으로 표시하며, 유효성 검증에 따른 성공 또는 경고 메시지를 제공합니다.
public final class FeelinLineInputField: UIView {
    private let maxLength: Int
    private let lengthExceededMessage: String?
    private let validationRules: [((String) -> (Bool, String?))]?
    public var isValid = false
    
    // MARK: - components
    
    private let flexContainer = UIView()
    
    private let textField = {
        let textField = UITextField()
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
    
    private let alertLabel = {
        let label = FeelinAlertLabel()
        label.font = SharedDesignSystemFontFamily.Pretendard.regular.font(size: 14)
        return label
    }()
    
    private lazy var lengthIndicatorLabel = {
        let label = UILabel()
        label.text = "0/\(maxLength)"
        label.font = SharedDesignSystemFontFamily.Pretendard.regular.font(size: 14)
        label.textColor = Colors.gray02
        label.textAlignment = .right
        return label
    }()
    
    // MARK: - init
    
    public init(
        maxLength: Int,
        placeholder: String?,
        lengthExceededMessage: String?,
        validationRules: [((String) -> (Bool, String?))]?
    ) {
        self.maxLength = maxLength
        self.lengthExceededMessage = lengthExceededMessage
        self.validationRules = validationRules
        
        super.init(frame: .zero)
        
        setUpLayout()
        setUpTextField(with: placeholder)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setUpTextField(with placeholder: String?) {
        textField.placeholder = placeholder
        textField.addTarget(
            self,
            action: #selector(textFieldEditingChanged),
            for: .editingChanged
        )
    }
    
    // MARK: - layout
    
    public override func layoutSubviews() {
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
                    flex.addItem(alertLabel)
                        .grow(1)
                    flex.addItem(lengthIndicatorLabel)
                        .width(50)
                }
        }
    }
}

private extension FeelinLineInputField {
    @objc func textFieldEditingChanged(_ textField: UITextField) {
        guard let text = textField.text else { return }
        validate(text: text)
    }
    
    func validate(text: String) {
        let currentLength = text.count
        let isLengthValid = currentLength <= maxLength
        var isCustomValid = true
        var validationMessage: String?
        
        lengthIndicatorLabel.text = "\(currentLength)/\(maxLength)"
        lengthIndicatorLabel.textColor = isLengthValid ? Colors.gray02 : Colors.alertWarning
        
        if !isLengthValid {
            validationMessage = lengthExceededMessage
        } else {
            if let rules = validationRules {
                for rule in rules {
                    let (isRuleValid, message) = rule(text)
                    isCustomValid = isRuleValid
                    validationMessage = message
                }
            }
        }
        
        alertLabel.text = validationMessage
        updateValidationState(isValid: isCustomValid && isLengthValid)
    }
    
    func updateValidationState(isValid: Bool) {
        self.isValid = isValid
        alertLabel.isValid = isValid
        separator.backgroundColor = isValid ? Colors.gray02 : Colors.alertWarning
    }
}
 
