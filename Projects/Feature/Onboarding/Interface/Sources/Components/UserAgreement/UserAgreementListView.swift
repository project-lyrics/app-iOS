//
//  UserAgreementListView.swift
//  FeatureOnboardingInterface
//
//  Created by 황인우 on 6/9/24.
//

import FlexLayout
import PinLayout
import SharedDesignSystem
import SharedUtil
import UIKit

final class UseAgreementListView: UIView {
    private let flexContainer = UIView()

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    private lazy var allAgreeLabel: UILabel = {
        let label = self.createAgreeDescriptionLabel("전체동의")
        return label
    }()

    lazy var allAgreeButton: UIButton = {
        let subFlexContainer = UIView()

        subFlexContainer.flex.direction(.row).define { flex in
            flex.addItem(self.allAgreeLabel)
                .marginLeft(12)
        }

        let button = CheckBoxButton(additionalView: subFlexContainer)
        button.configuration = UIButton.Configuration.bordered()

        button.configurationUpdateHandler = { [weak self] button in
            button.configuration?.baseForegroundColor = button.state == .selected ? nil : Colors.gray04
            button.configuration?.baseBackgroundColor = button.state == .selected ? Colors.alertSuccess : Colors.background
            self?.allAgreeLabel.textColor = button.state == .selected ? Colors.alertSuccess : Colors.gray04
        }

        return button
    }()

    lazy var ageAgreeButton: UIButton = {
        return self.createAgreementButton("만 14세 이상 가입 동의")
    }()

    lazy var serviceUsageAgreeButton: UIButton = {
        return self.createAgreementButton("서비스 이용약관 동의")
    }()

    lazy var personalInfoAgreeButton: UIButton = {
        return self.createAgreementButton("개인정보처리방침 동의")
    }()

    lazy var checkServiceUsageButton: UIButton = {
        let button = self.createCheckUsageButton(title: "보기")
        return button
    }()

    lazy var checkPersonalInfoUsageButton: UIButton = {
        let button = self.createCheckUsageButton(title: "보기")
        return button
    }()

    init() {
        super.init(frame: .zero)

        addSubview(flexContainer)

        flexContainer.flex
            .paddingHorizontal(20)
            .define { flex in

                flex.addItem(allAgreeButton)
                    .marginTop(32)
                    .height(52)

                flex.addItem(ageAgreeButton)
                    .marginTop(24)
                    .height(28)

                flex.addItem()
                    .direction(.row)
                    .define { flex in
                        flex.addItem(serviceUsageAgreeButton)
                            .grow(1)

                        flex.addItem(checkServiceUsageButton)
                    }
                    .marginTop(12)
                    .height(28)

                flex.addItem()
                    .direction(.row)
                    .define { flex in
                        flex.addItem(personalInfoAgreeButton)
                            .grow(1)

                        flex.addItem(checkPersonalInfoUsageButton)
                    }
                    .marginTop(12)
                    .height(28)
        }
        .backgroundColor(Colors.background)
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        flexContainer.pin.all()

        flexContainer.flex
            .layout()
    }
}

// MARK: - View Factory
private extension UseAgreementListView {
    func createAgreementButton(_ description: String) -> UIButton {
        let subFlexContainer = UIView()

        subFlexContainer.flex.direction(.row).define { flex in
            flex.addItem(self.createMandatoryBorderedView())
                .marginLeft(12)
                .marginRight(6)

            flex.addItem(self.createAgreeDescriptionLabel(description))
        }
        let button = CheckBoxButton(additionalView: subFlexContainer)

        return button
    }

    func createAgreeDescriptionLabel(_ description: String) -> UILabel {
        let label = UILabel()
        label.text = description
        label.font = SharedDesignSystemFontFamily.Pretendard.semiBold.font(size: 16)
        label.textColor = Colors.gray04

        return label
    }

    func createMandatoryBorderedView() -> UIView {
        let subflexContainer = UIView()

        let label = UILabel()
        label.text = "필수"
        label.font = SharedDesignSystemFontFamily.Pretendard.medium.font(size: 14)
        label.textColor = Colors.gray05
        label.textAlignment = .center

        subflexContainer.flex
            .justifyContent(.center)
            .alignItems(.center)
            .addItem()
            .size(.init(width: 49, height: 28))
            .cornerRadius(14)
            .border(2, Colors.gray01)
            .define { flex in
                flex.addItem(label)
                    .marginVertical(4)
                    .marginHorizontal(12)
            }

        return subflexContainer
    }

    func createCheckUsageButton(title: String) -> UIButton {
        var configuration = UIButton.Configuration.plain()
        configuration.title = title
        configuration.attributedTitle = AttributedString(
            title,
            attributes: AttributeContainer(
                [
                    NSAttributedString.Key.font: SharedDesignSystemFontFamily.Pretendard.medium.font(size: 14),
                    NSAttributedString.Key.foregroundColor: Colors.gray04
                ]
            )
        )
        let button = UIButton(configuration: configuration)

        return button
    }
}
