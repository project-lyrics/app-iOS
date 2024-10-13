//
//  ProfileEditView.swift
//  FeatureMyPageInterface
//
//  Created by Derrick kim on 10/9/24.
//

import UIKit

import Shared

import FlexLayout
import PinLayout
import FeatureOnboardingInterface

public final class ProfileEditView: UIView {
    private let maxNicknameLength = 10

    // MARK: - components
    private let navigationBar = NavigationBar()

    private let naviTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "프로필 수정"
        label.font = SharedDesignSystemFontFamily.Pretendard.bold.font(size: 18)
        label.textColor = Colors.gray09

        return label
    }()

    public private (set) lazy var backButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false

        let image = FeelinImages.back
        button.setImage(image, for: .normal)

        return button
    }()

    private let flexContainer = UIView()

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

    public let saveProfileButton = FeelinConfirmButton(title: "프로필 저장")

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
        navigationBar.addTitleView(naviTitleLabel)

        flexContainer.flex
            .define { flex in
                flex.addItem(navigationBar)
                    .height(44)
                    .marginHorizontal(10)
                    .marginTop(pin.safeArea.top)

                flex.addItem()
                    .grow(1)
                    .define { flex in
                        flex.addItem(profileEditButton)
                            .marginTop(72)
                            .marginHorizontal(20)

                        flex.addItem(guideLabel)
                            .marginTop(40)
                            .marginHorizontal(20)

                        flex.addItem(nicknameTextField)
                            .marginTop(20)
                            .marginHorizontal(20)

                        flex.addItem()
                            .direction(.row)
                            .justifyContent(.spaceBetween)
                            .marginHorizontal(20)
                            .marginTop(4)
                            .define { flex in
                                flex.addItem(alertLabel)
                                    .grow(1)
                                flex.addItem(lengthIndicatorLabel)
                                    .width(50)
                            }
                    }

                flex.addItem(saveProfileButton)
                    .minHeight(56)
                    .cornerRadius(8)
                    .marginBottom(23)
                    .marginHorizontal(20)
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

private extension ProfileEditView {
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
