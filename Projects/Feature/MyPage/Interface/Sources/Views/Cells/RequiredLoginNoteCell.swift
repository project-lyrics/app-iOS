//
//  RequiredLoginNoteCell.swift
//  FeatureMyPageInterface
//
//  Created by Derrick kim on 10/9/24.
//

import UIKit

import FlexLayout
import PinLayout
import Shared

public final class RequiredLoginNoteCell: UICollectionViewCell, Reusable {
    private let flexContainer = UIView()

    private var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "로그인 후 이용하실 수 있어요"
        label.font = SharedDesignSystemFontFamily.Pretendard.regular.font(size: 14)
        label.textColor = Colors.gray04

        return label
    }()

    public private (set) var loginButton: UIButton = {
        let button = UIButton()
        button.setTitle("로그인하러 가기", for: .normal)
        button.titleLabel?.font = SharedDesignSystemFontFamily.Pretendard.medium.font(size: 14)
        button.contentEdgeInsets = UIEdgeInsets(top: 10, left: 18, bottom: 10, right: 18)
        button.setTitleColor(Colors.gray09, for: .normal)
        button.backgroundColor = Colors.gray01

        return button
    }()

    public override init(frame: CGRect) {
        super.init(frame: frame)
        self.setUpLayout()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    public override func layoutSubviews() {
        super.layoutSubviews()

        flexContainer.pin.all()
        flexContainer.flex.layout()
    }

    private func setUpLayout() {
        contentView.addSubview(flexContainer)
        contentView.backgroundColor = Colors.background

        flexContainer.flex
            .justifyContent(.center)
            .alignItems(.center)
            .define { flex in
                flex.addItem(titleLabel)

                flex.addItem(loginButton)
                    .marginTop(16)
                    .height(40)
                    .width(130)
                    .cornerRadius(8)
            }
    }
}
