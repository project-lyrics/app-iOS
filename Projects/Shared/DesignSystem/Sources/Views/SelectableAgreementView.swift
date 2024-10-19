//
//  SelectableAgreementView.swift
//  SharedDesignSystem
//
//  Created by Derrick kim on 9/17/24.
//

import UIKit
import FlexLayout

public final class SelectableAgreementView: UIView {

    // MARK: - UI Components

    private let flexContainer = UIView()
    
    private lazy var subFlexContainer: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 14
        view.layer.borderWidth = 2

        let style: UIUserInterfaceStyle = traitCollection.userInterfaceStyle
        view.layer.borderColor = style == .light ? Colors.fixedGray01.cgColor :
        Colors.gray01.resolvedColor(with: UITraitCollection(userInterfaceStyle: .dark)).cgColor

        return view
    }()

    private let descriptionLabel: UILabel = {
        let label = UILabel()
        return label
    }()

    private let requiredOptionLabel: UILabel = {
        let label = UILabel()
        label.text = "필수"
        label.font = SharedDesignSystemFontFamily.Pretendard.medium.font(size: 14)
        label.textColor = Colors.gray05
        label.textAlignment = .center

        return label
    }()

    private let agreeDescriptionLabel: UILabel = {
        let label = UILabel()
        label.font = SharedDesignSystemFontFamily.Pretendard.semiBold.font(size: 16)
        label.textColor = Colors.gray04

        return label
    }()

    // MARK: - Initializer

    public init() {
        super.init(frame: .zero)
        setUpLayout()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Layout

    public override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        updateBorderColor(for: traitCollection.userInterfaceStyle)
    }

    public override func layoutSubviews() {
        super.layoutSubviews()

        flexContainer.pin.all(pin.safeArea)
        flexContainer.flex.layout()
    }

    private func setUpLayout() {
        self.addSubview(flexContainer)

        flexContainer.flex
            .direction(.row)
            .define { flex in
            flex.addItem(createMandatoryBorderedView())
                .marginLeft(12)
                .marginRight(6)

            flex.addItem(agreeDescriptionLabel)
        }
    }
    
    private func createMandatoryBorderedView() -> UIView {
        subFlexContainer.flex
            .justifyContent(.center)
            .alignItems(.center)
            .addItem()
            .size(.init(width: 49, height: 28))
            .define { flex in
                flex.addItem(requiredOptionLabel)
                    .marginVertical(4)
                    .marginHorizontal(12)
            }
        return subFlexContainer
    }

    private func updateBorderColor(for userInterfaceStyle: UIUserInterfaceStyle) {
        if userInterfaceStyle == .dark {
            subFlexContainer.layer.borderColor = Colors.gray01.resolvedColor(with: UITraitCollection(userInterfaceStyle: .dark)).cgColor
           } else {
               subFlexContainer.layer.borderColor = Colors.fixedGray01.cgColor
           }
    }

    public func setTitle(_ description: String) {
        self.agreeDescriptionLabel.text = description
    }
}
