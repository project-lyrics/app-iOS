//
//  FeelinSearchBar.swift
//  SharedDesignSystem
//
//  Created by 황인우 on 6/18/24.
//

import UIKit

import FlexLayout
import PinLayout

public final class FeelinSearchBar: UIView {
    
    // MARK: - View
    
    private let rootFlexContainer = UIView()
    
    private (set) public var searchTextField = UITextField()
    
    private (set) public var clearButton = UIButton()
    
    private var searchImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.image = FeelinImages.search.withRenderingMode(.alwaysTemplate)
        imageView.tintColor = Colors.gray05
        return imageView
    }()
    
    // MARK: - init
    
    public init(placeholder: String) {
        super.init(frame: .zero)
        
        self.setUpView(with: placeholder)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    private func setUpView(with placeholder: String) {
        self.setUpBackground()
        self.setUpButton()
        self.setUpTextField(placeholder: placeholder)
        self.setUpLayout()
    }
    
    private func setUpBackground() {
        self.backgroundColor = Colors.inputField
        self.layer.cornerRadius = 8
    }
    
    private func setUpButton() {
        self.clearButton.setImage(FeelinImages.xCircle, for: .normal)
        self.clearButton.isHidden = true
        self.clearButton.addTarget(
            self,
            action: #selector(clearText),
            for: .touchUpInside
        )
    }
    
    private func setUpTextField(placeholder: String) {
        self.searchTextField.placeholder = placeholder
        self.searchTextField.borderStyle = .none
        self.searchTextField.textColor = Colors.gray09
        self.searchTextField.font = SharedDesignSystemFontFamily.Pretendard.regular.font(size: 14)
        self.searchTextField.tintColor = .black
        self.searchTextField.addTarget(
            self,
            action: #selector(textFieldDidChange),
            for: .editingChanged
        )
    }
    
    private func setUpLayout() {
        self.addSubview(rootFlexContainer)
        
        self.rootFlexContainer.flex.direction(.row)
            .height(44)
            .define { flex in
                flex.addItem(searchImageView)
                    .marginLeft(12)
                    .marginVertical(12)
                
                flex.addItem(searchTextField)
                    .marginLeft(8)
                    .marginVertical(12)
                    .marginRight(12)
                    .grow(1)
                
                flex.addItem(clearButton)
                    .marginVertical(10)
                    .marginRight(12)
            }
    }
    
    override public func layoutSubviews() {
        super.layoutSubviews()
        
        self.rootFlexContainer.pin.all()
        self.rootFlexContainer.flex.layout()
    }
    
    @objc private func textFieldDidChange() {
        self.clearButton.isHidden = searchTextField.text?.isEmpty ?? true
    }
    
    @objc private func clearText() {
        self.searchTextField.text = ""
        self.clearButton.isHidden = true
        self.searchTextField.resignFirstResponder()
    }
}
