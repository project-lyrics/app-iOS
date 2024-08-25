//
//  PostSelectButton.swift
//  FeatureMainInterface
//
//  Created by Derrick kim on 8/10/24.
//

import UIKit
import Shared
import FlexLayout
import PinLayout

final class PostSelectButton: UIView {

    private let rootFlexContainer = UIView()

    private let iconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = Colors.disabled
        return label
    }()

    var isEnabled: Bool = false {
        didSet {
            updateUI(isEnabled)
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)

        self.backgroundColor = Colors.background

        self.setUpLayout()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError()
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        rootFlexContainer.pin
            .top(self.pin.safeArea)
            .horizontally()
            .bottom()

        rootFlexContainer.flex.layout()
    }

    private func setUpLayout() {
        self.addSubview(rootFlexContainer)

        layer.borderColor = Colors.gray01.cgColor
        layer.cornerRadius = 8
        layer.borderWidth = 1
        
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

    private func updateUI(_ isEnabled: Bool) {
        titleLabel.textColor = isEnabled ? Colors.active : Colors.disabled
        iconImageView.tintColor = isEnabled ? Colors.active : Colors.disabled
    }

    func configure(title: String, image: UIImage) {
        titleLabel.text = title
        iconImageView.image = image
    }
}
