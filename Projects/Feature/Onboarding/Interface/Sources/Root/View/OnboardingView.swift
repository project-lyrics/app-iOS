//
//  OnboardingView.swift
//  FeatureOnboardingInterface
//
//  Created by Derrick kim on 5/23/24.
//

import UIKit
import PinLayout
import FlexLayout
import SharedDesignSystem

final class OnboardingView: UIView {
    private let rootFlexContainer = UIView()

    private let titleLabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = SharedDesignSystemFontFamily.Pretendard.extraBold.font(size: 72)
        label.text = "Feelin"
        return label
    }()

    private let messageLabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.text = "이야기로 음악을 느끼다, 이야기로 음악을 채우다"
        label.font = SharedDesignSystemFontFamily.Pretendard.medium.font(size: 16)

        return label
    }()

    private let continueWithoutLoginLabel = {
        let label = UILabel()
        label.text = "회원가입은 나중에! 둘러볼게요"
        label.textColor = Colors.gray04
        label.textAlignment = .center
        label.font = SharedDesignSystemFontFamily.Pretendard.medium.font(size: 14)
        let attributeString = NSMutableAttributedString(string: label.text ?? "")

        attributeString.addAttribute(
            .underlineStyle,
            value: 1,
            range: NSRange.init(
                location: 0,
                length: label.text?.count ?? 0
            )
        )
        label.attributedText = attributeString
        label.isUserInteractionEnabled = true

        return label
    }()

    private let logoBeltImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = FeelinImages.logoBelt
        imageView.contentMode = .scaleAspectFit

        return imageView
    }()

    private let appleLoginButton = {
        let button = UIButton()
        button.setTitle("Apple로 시작하기", for: .normal)
        button.titleLabel?.font = SharedDesignSystemFontFamily.EncodeSans.semiBold.font(size: 16)
        button.setTitleColor(Colors.gray01, for: .normal)
        button.setImage(FeelinImages.apple, for: .normal)
        button.backgroundColor = Colors.gray09
        button.configuration?.imagePadding = -100
        button.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 8)

        return button
    }()

    private let kakaoLoginButton = {
        let button = UIButton()
        button.setTitle("카카오로 시작하기", for: .normal)
        button.titleLabel?.font = SharedDesignSystemFontFamily.Pretendard.semiBold.font(size: 16)
        button.setTitleColor(Colors.gray09, for: .normal)
        button.setImage(FeelinImages.kakao, for: .normal)
        button.backgroundColor = Colors.kakaoYellow
        button.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 8)

        return button
    }()

    private var appleLoginAction: (() -> Void)?
    private var kakaoLoginAction: (() -> Void)?
    private var continueWithoutLoginAction: (() -> Void)?

    init() {
        super.init(frame: .zero)

        setupDefault()
        addUIComponents()
    }

    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        fatalError()
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        rootFlexContainer.pin.top(pin.safeArea).horizontally(pin.safeArea)
        rootFlexContainer.flex.layout(mode: .adjustHeight)
        rootFlexContainer.flex.layout()
    }

    func configureLayouts() {
        rootFlexContainer.flex.define { flex in
            flex.addItem().direction(.column).define { flex in
                flex.addItem(titleLabel)
                    .marginTop(UIScreen.main.bounds.height * 0.26)
                flex.addItem(messageLabel)
                    .marginTop(6)
            }

            flex.addItem().direction(.column).define { flex in
                flex.addItem(appleLoginButton)
                    .height(56)
                    .cornerRadius(8)
                flex.addItem(kakaoLoginButton)
                    .height(56)
                    .cornerRadius(8)
                    .marginTop(12)
                flex.addItem(continueWithoutLoginLabel)
                    .marginTop(30)
            }
            .marginTop(93)
        }
        .margin(0, 10, 0, 10)

        NSLayoutConstraint.activate([
            logoBeltImageView.topAnchor.constraint(equalTo: rootFlexContainer.topAnchor, constant: 205),
            logoBeltImageView.leadingAnchor.constraint(equalTo: leadingAnchor),
            logoBeltImageView.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])

        rootFlexContainer.flex.layout()
    }

    func actionAppleLogin(_ action: @escaping (() -> Void)) {
        self.appleLoginAction = action
    }

    func actionKakaoLogin(_ action: @escaping (() -> Void)) {
        self.kakaoLoginAction = action
    }

    func actionContinueWithoutLogin(_ action: @escaping (() -> Void)) {
        self.continueWithoutLoginAction = action
    }

    private func setupDefault() {
        backgroundColor = .white
        addButtonTargets()
    }

    private func addUIComponents() {
        [logoBeltImageView, rootFlexContainer]
            .forEach { addSubview($0) }
    }

    private func addButtonTargets() {
        appleLoginButton.addTarget(
            self,
            action: #selector(didTapAppleLoginButton),
            for: .touchUpInside
        )

        kakaoLoginButton.addTarget(
            self,
            action: #selector(didTapKakaoLoginButton),
            for: .touchUpInside
        )

        let tapGesture = UITapGestureRecognizer(
            target: self,
            action: #selector(didTapContinueWithoutLoginLabel)
        )
        continueWithoutLoginLabel.addGestureRecognizer(tapGesture)
    }

    @objc private func didTapAppleLoginButton(_ sender: UIButton) {
        appleLoginAction?()
    }

    @objc private func didTapKakaoLoginButton(_ sender: UIButton) {
        kakaoLoginAction?()
    }

    @objc private func didTapContinueWithoutLoginLabel(_ sender: UIGestureRecognizer) {
        continueWithoutLoginAction?()
    }
}
