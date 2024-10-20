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

public final class ProfileView: UIView {
    private let maxNicknameLength = 10

    // MARK: - components
    private let navigationBar = NavigationBar()

    let backButton: UIButton = {
        let button = UIButton()
        button.setImage(FeelinImages.back, for: .normal)

        return button
    }()

    private let flexContainer = UIView()

    private let titleLabel = {
        let label = UILabel()
        label.text = "프로필을 설정해주세요"
        label.font = SharedDesignSystemFontFamily.Pretendard.bold.font(size: 24)
        label.textColor = Colors.gray08

        return label
    }()

    public let profileEditButton = ProfileEditButton()

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

    public private (set) lazy var nicknameTextField = FeelinLineInputField(placeholder: "닉네임")

    private let alertLabel = {
        let label = UILabel()
        label.font = SharedDesignSystemFontFamily.Pretendard.regular.font(size: 14)
        label.textColor = Colors.alertWarning

        return label
    }()

    private lazy var lengthIndicatorLabel = {
        let label = UILabel()
        label.text = "0/\(maxNicknameLength)"
        label.font = SharedDesignSystemFontFamily.Pretendard.regular.font(size: 14)
        label.textColor = Colors.gray02
        label.textAlignment = .right

        return label
    }()

    public let nextButton = FeelinConfirmButton(title: "다음")

    // MARK: - init

    public override init(frame: CGRect) {
        super.init(frame: frame)

        backgroundColor = Colors.background
        setUpLayout()
        setUpNicknameTextField()
    }

    @available(*, unavailable)
    public required init?(coder: NSCoder) {
        fatalError()
    }

    // MARK: - layout

    public override func layoutSubviews() {
        super.layoutSubviews()

        flexContainer.pin.all(pin.safeArea)
        flexContainer.flex.layout()
    }

    private func setUpLayout() {
        addSubview(flexContainer)

        navigationBar.addLeftBarView([backButton])

        flexContainer.flex
            .define { flex in
                flex.addItem(navigationBar)
                    .height(44)
                    .marginHorizontal(10)
                    .marginTop(pin.safeArea.top)

                flex.addItem()
                    .marginHorizontal(20)
                    .marginTop(28)
                    .grow(1)
                    .define { flex in
                        flex.addItem(titleLabel)

                        flex.addItem(profileEditButton)
                            .marginTop(40)

                        flex.addItem(guideLabel)
                            .marginTop(40)

                        flex.addItem(nicknameTextField)
                            .marginTop(20)

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

                        flex.addItem()
                            .grow(1)

                        flex.addItem(nextButton)
                            .minHeight(56)
                            .cornerRadius(8)
                            .marginBottom(23)
                    }
            }
    }

    private func setUpNicknameTextField() {
        nicknameTextField.textField.addTarget(
            self,
            action: #selector(textFieldEditingChanged),
            for: .editingChanged
        )
    }
}

private extension ProfileView {
    @objc func textFieldEditingChanged(_ textField: UITextField) {
        guard let text = textField.text else { return }
        validate(text: text)
    }

    func validate(text: String) {
        let currentLength = text.count
        let isLengthValid = currentLength <= maxNicknameLength
        let isCharacterValid = text.containsOnlyAllowedCharacters

        lengthIndicatorLabel.text = "\(currentLength)/\(maxNicknameLength)"
        lengthIndicatorLabel.textColor = isLengthValid ? Colors.gray02 : Colors.alertWarning

        if !isLengthValid {
            alertLabel.text = "1~10자의 닉네임을 사용해주세요"
        } else if !isCharacterValid {
            alertLabel.text = "공백, 특수문자, 이모티콘은 사용 불가합니다"
        }

        setNicknameValid(isLengthValid && isCharacterValid)
    }

    func setNicknameValid(_ isValid: Bool) {
        nicknameTextField.setValid(isValid)
        alertLabel.isHidden = isValid
    }
}
