//
//  PostSelectButton.swift
//  FeatureHomeInterface
//
//  Created by Derrick kim on 8/10/24.
//

import UIKit
import Shared
import FlexLayout
import PinLayout

public final class PostSelectButton: UIView {

    private let rootFlexContainer = UIView()

    private let iconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.tintColor = Colors.disabled
        return imageView
    }()

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = Colors.disabled
        return label
    }()

    public var isEnabled: Bool = false {
        didSet {
            updateUI(isEnabled)
        }
    }

    public override init(frame: CGRect) {
        super.init(frame: frame)

        self.backgroundColor = Colors.background
        self.setUpLayout()
        self.setUpLayer()  // 레이어 설정
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError()
    }

    public override func layoutSubviews() {
        super.layoutSubviews()

        rootFlexContainer.pin
            .top(self.pin.safeArea)
            .horizontally()
            .bottom()

        rootFlexContainer.flex.layout()
    }

    private func setUpLayout() {
        self.addSubview(rootFlexContainer)

        rootFlexContainer
            .flex
            .direction(.row)
            .paddingHorizontal(8)
            .define { flex in
                flex.addItem(iconImageView)
                    .alignSelf(.center)
                    .marginRight(4)
                    .size(16)

                flex.addItem(titleLabel)
                    .marginTop(6)
                    .marginBottom(6)
            }
    }

    private func setUpLayer() {
        layer.cornerRadius = 8
        layer.borderWidth = 1
        updateBorderColor()
    }

    // traitCollection이 변경될 때마다 테두리 색상을 업데이트
    public override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        updateBorderColor()
    }

    // 테두리 색상을 다크 모드와 라이트 모드에 따라 변경하는 메서드
    private func updateBorderColor() {
        layer.borderColor = Colors.gray01.cgColor
    }

    private func updateUI(_ isEnabled: Bool) {
        titleLabel.textColor = isEnabled ? Colors.gray05 : Colors.disabled
        iconImageView.tintColor = isEnabled ? Colors.gray05 : Colors.disabled
    }

    public func configure(title: String, image: UIImage) {
        titleLabel.text = title
        iconImageView.image = image.withRenderingMode(.alwaysTemplate)
    }
}
