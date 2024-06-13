//
//  LogInView.swift
//  FeatureOnboardingInterface
//
//  Created by Derrick kim on 5/23/24.
//

import UIKit
import PinLayout
import FlexLayout
import SharedDesignSystem

final class LogInView: UIView {
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

    lazy var continueWithoutLogInLabel = {
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

    lazy var appleLogInButton = {
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

    lazy var kakaoLogInButton = {
        let button = UIButton()
        button.setTitle("카카오로 시작하기", for: .normal)
        button.titleLabel?.font = SharedDesignSystemFontFamily.Pretendard.semiBold.font(size: 16)
        button.setTitleColor(Colors.gray09, for: .normal)
        button.setImage(FeelinImages.kakao, for: .normal)
        button.backgroundColor = Colors.kakaoYellow
        button.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 8)

        return button
    }()

    private let topBallonView = BalloonView()
    private let bottomBallonView = BalloonView()

    init() {
        super.init(frame: .zero)

        setUpDefault()
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
                flex.addItem(appleLogInButton)
                    .height(56)
                    .cornerRadius(8)
                flex.addItem(kakaoLogInButton)
                    .height(56)
                    .cornerRadius(8)
                    .marginTop(12)
                flex.addItem(continueWithoutLogInLabel)
                    .marginTop(30)
            }
            .marginTop(93)
        }
        .margin(0, 10, 0, 10)

        rootFlexContainer.flex.layout()

        NSLayoutConstraint.activate([
            logoBeltImageView.topAnchor.constraint(equalTo: rootFlexContainer.topAnchor, constant: 205),
            logoBeltImageView.leadingAnchor.constraint(equalTo: leadingAnchor),
            logoBeltImageView.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])

        NSLayoutConstraint.activate([
            topBallonView.bottomAnchor.constraint(equalTo: appleLogInButton.topAnchor, constant: 13),
            topBallonView.trailingAnchor.constraint(equalTo: appleLogInButton.trailingAnchor, constant: -4)
        ])

        NSLayoutConstraint.activate([
            bottomBallonView.bottomAnchor.constraint(equalTo: kakaoLogInButton.topAnchor, constant: 13),
            bottomBallonView.trailingAnchor.constraint(equalTo: kakaoLogInButton.trailingAnchor, constant: -4)
        ])
    }

    func setUpRecentLogInRecordBallonView(_ isHidden: Bool) {
        topBallonView.isHidden = isHidden
        bottomBallonView.isHidden = !isHidden
    }

    private func setUpDefault() {
        backgroundColor = .white
    }

    private func addUIComponents() {
        [logoBeltImageView, rootFlexContainer, topBallonView, bottomBallonView]
            .forEach { addSubview($0) }
    }
}
