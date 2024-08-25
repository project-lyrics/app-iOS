//
//  SearchBarView.swift
//  FeatureMainInterface
//
//  Created by Derrick kim on 8/25/24.
//

import UIKit

import FlexLayout
import PinLayout
import Shared

final class SearchBarView: UIView {

    // MARK: - UI Components

    private let flexContainer = UIView()

    private lazy var searchIconImageView: UIImageView = {
        let imageView = UIImageView()
        let userInterfaceStyle = traitCollection.userInterfaceStyle
        let image = userInterfaceStyle == .light ? FeelinImages.searchLight : FeelinImages.searchDark
        imageView.image = image

        return imageView
    }()

    let searchTextField: UITextField = {
        let textField = UITextField()
        textField.font = SharedDesignSystemFontFamily.Pretendard.regular.font(size: 14)
        textField.textColor = Colors.gray09
        textField.tintColor = Colors.gray09
        textField.returnKeyType = .search

        let placeholderText = "곡 검색"
        let placeholderAttributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: Colors.gray04
        ]
        textField.attributedPlaceholder = NSAttributedString(string: placeholderText, attributes: placeholderAttributes)

        return textField
    }()

    lazy var xButton: UIButton = {
        let button = UIButton()
        let userInterfaceStyle = traitCollection.userInterfaceStyle
        let image = userInterfaceStyle == .light ? FeelinImages.xCircleLight : FeelinImages.xCircleDark
        button.setImage(image, for: .normal)
        button.isHidden = true

        return button
    }()


    // MARK: - Init

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setUpLayout()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError()
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        flexContainer.pin.all()
        flexContainer.flex.layout()
    }

    private func setUpLayout() {
        self.addSubview(flexContainer)

        flexContainer
            .flex
            .direction(.row)
            .alignItems(.center)
            .padding(8)
            .cornerRadius(8)
            .backgroundColor(Colors.inputField)
            .define { flex in
                flex.addItem(searchIconImageView)
                    .size(20)
                    .marginVertical(12)
                    .marginLeft(12)
                    .marginRight(8)

                flex.addItem(searchTextField)
                    .grow(1)
                    .marginVertical(12)
                    .height(20)

                flex.addItem(xButton)
                    .marginVertical(10)
                    .marginLeft(8)
                    .marginRight(10)
                    .size(24)
            }
            .height(44)
    }
}

#if canImport(SwiftUI)
import SwiftUI

struct SearchBarView_Preview: PreviewProvider {
    static var previews: some View {
        SearchBarView(
            frame: .init(x: 0, y: 0, width: 300, height: 50)
        ).showPreview()
    }
}
#endif
