//
//  
//  SettingsTableViewCell.swift
//  FeatureMyPageInterface
//
//  Created by Derrick kim on 10/12/24.
//

import UIKit

import Shared

final class SettingsTableViewCell: UITableViewCell, Reusable {
    private let flexContainer = UIView()

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = SharedDesignSystemFontFamily.Pretendard.regular.font(size: 16)
        label.textColor = Colors.gray09

        return label
    }()

    private let caretRightImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.image = FeelinImages.caretRight.withRenderingMode(.alwaysTemplate)
        imageView.tintColor = Colors.gray05

        return imageView
    }()

    // MARK: - init

    override init(
        style: UITableViewCell.CellStyle,
        reuseIdentifier: String?
    ) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        self.setUpDefault()
        self.setUpLayout()
    }

    @available(*, unavailable)
    required  init?(coder: NSCoder) {
        fatalError()
    }

    override public func layoutSubviews() {
        super.layoutSubviews()

        flexContainer.pin.all()
        flexContainer.flex.layout()
    }

    private func setUpDefault() {
        self.backgroundColor = Colors.background
    }

    private func setUpLayout() {
        self.addSubview(flexContainer)

        flexContainer.flex
            .paddingHorizontal(20)
            .define { flex in
                flex.addItem()
                    .direction(.row)
                    .define { flex in
                        flex.addItem(titleLabel)
                            .grow(1)
                        
                        flex.addItem(caretRightImageView)
                    }
            }
    }

    func configure(info: String) {
        self.titleLabel.text = info
        self.titleLabel.flex.markDirty()
        self.flexContainer.flex.layout()
    }
}
