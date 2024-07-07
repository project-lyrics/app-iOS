//
//  FeelinLineInputField.swift
//  FeatureOnboardingInterface
//
//  Created by jiyeon on 6/14/24.
//

import UIKit

import FlexLayout
import PinLayout

public final class FeelinLineInputField: UIView {
    // MARK: - components
    
    private let flexContainer = UIView()
    
    public let textField = {
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

    public var isValid: Bool = true {
        didSet {
            separator.backgroundColor = isValid ? Colors.gray02 : Colors.alertWarning
        }
    }

    // MARK: - init
    
    public init(placeholder: String?) {
        textField.placeholder = placeholder
        
        super.init(frame: .zero)
        
        setUpLayout()
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
        flexContainer.flex.define { flex in
            flex.addItem(textField)
                .height(24)
            
            flex.addItem(separator)
                .height(1)
                .marginTop(8)
        }
    }
    
    public func setValid(_ isValid: Bool) {
        self.isValid = isValid
    }
}
