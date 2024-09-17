//
//  ReportReasonTableViewCell.swift
//  FeatureMainInterface
//
//  Created by Derrick kim on 9/17/24.
//

import UIKit

import Domain
import Shared

final class ReportReasonTableViewCell: UITableViewCell, Reusable {
    private let rootFlexContainer = UIView()

    private let contentLabel = {
        let label = UILabel()
        label.font = SharedDesignSystemFontFamily.Pretendard.regular.font(size: 16)
        label.textColor = Colors.gray09
        label.textAlignment = .left

        return label
    }()

    private lazy var reasonButton: UIButton = {
        let subFlexContainer = UIView()

        subFlexContainer.flex.direction(.row).define { flex in
            flex.addItem(self.contentLabel)
                .marginLeft(8)
        }

        return CheckBoxButton(additionalView: subFlexContainer)
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupLayout()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupLayout() {
        contentView.addSubview(rootFlexContainer)

        rootFlexContainer.flex
            .direction(.row)
            .define { flex in
                flex.addItem(reasonButton)
                    .grow(1)
            }
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        rootFlexContainer.pin.all()
        rootFlexContainer.flex.layout()
    }

    func configure(model: String) {
        contentLabel.text = model
        reasonButton.isSelected = isSelected
    }

    func setSelected(_ selected: Bool) {
        reasonButton.isSelected = selected
    }
}
