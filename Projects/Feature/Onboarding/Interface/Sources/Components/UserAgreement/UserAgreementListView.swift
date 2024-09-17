//
//  UserAgreementListView.swift
//  FeatureOnboardingInterface
//
//  Created by 황인우 on 6/9/24.
//

import FlexLayout
import PinLayout
import Shared
import UIKit
import Domain

final class UseAgreementListView: UIView {

    private let flexContainer = UIView()

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    private lazy var allAgreeLabel: UILabel = {
        let label = UILabel()
        label.text = description
        label.font = SharedDesignSystemFontFamily.Pretendard.semiBold.font(size: 16)
        label.textColor = Colors.gray04
        label.text = "전체동의"
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
        let contentView = SelectableAgreementView()
        contentView.setTitle(TermEntity.ageAgree.title)
        let button = CheckBoxButton(additionalView: contentView)
        return button
    }()

    lazy var serviceUsageAgreeButton: UIButton = {
        let contentView = SelectableAgreementView()
        contentView.setTitle(TermEntity.serviceUsage.title)
        let button = CheckBoxButton(additionalView: contentView)
        return button
    }()

    lazy var personalInfoAgreeButton: UIButton = {
        let contentView = SelectableAgreementView()
        contentView.setTitle(TermEntity.personalInfo.title)
        let button = CheckBoxButton(additionalView: contentView)
        return button
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
        configureLayouts()
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        flexContainer.pin.all()

        flexContainer.flex
            .layout()
    }

    private func configureLayouts() {        
        flexContainer.flex.paddingHorizontal(20)
            .define { flex in
                flex.addItem(allAgreeButton)
                    .marginTop(32)
                    .height(52)

                flex.addItem(ageAgreeButton)
                    .marginLeft(18)
                    .marginTop(24)
                    .height(28)

                flex.addItem()
                    .direction(.row)
                    .define { flex in
                        flex.addItem(serviceUsageAgreeButton)
                            .marginLeft(18)
                            .grow(1)

                        flex.addItem(checkServiceUsageButton)
                    }
                    .marginTop(12)
                    .height(28)

                flex.addItem()
                    .direction(.row)
                    .define { flex in
                        flex.addItem(personalInfoAgreeButton)
                            .marginLeft(18)
                            .grow(1)

                        flex.addItem(checkPersonalInfoUsageButton)
                    }
                    .marginTop(12)
                    .height(28)
        }
        .backgroundColor(Colors.background)
    }
}

// MARK: - View Factory
private extension UseAgreementListView {
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
