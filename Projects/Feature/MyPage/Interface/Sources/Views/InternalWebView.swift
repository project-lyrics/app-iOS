//
//  InternalWebView.swift
//  FeatureMyPageInterface
//
//  Created by Derrick kim on 10/12/24.
//

import UIKit
import WebKit

import Shared

final class InternalWebView: UIView {
    private let rootFlexContainer = UIView()
    private let navigationBar = NavigationBar()

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "notion.so"
        label.font = SharedDesignSystemFontFamily.Pretendard.bold.font(size: 18)
        label.textColor = Colors.gray09

        return label
    }()

    let cancelButton: UIButton = {
        let button = UIButton()
        button.setImage(FeelinImages.x, for: .normal)
        return button
    }()

    let refreshButton: UIButton = {
        let button = UIButton()
        button.setImage(FeelinImages.refresh, for: .normal)
        return button
    }()

    let webView = WKWebView()

    override init(frame: CGRect = .zero) {
        super.init(frame: frame)
        setUpDefaults()
        setUpLayouts()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError()
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        rootFlexContainer.pin.all(pin.safeArea)
        rootFlexContainer.flex.layout()
    }

    private func setUpDefaults() {
        backgroundColor = Colors.background
    }

    private func setUpLayouts() {
        addSubview(rootFlexContainer)

        navigationBar.addTitleView(titleLabel)
        navigationBar.addLeftBarView([cancelButton])
        navigationBar.addRightBarView([refreshButton])

        rootFlexContainer
            .flex
            .direction(.column)
            .define { flex in
                flex.addItem(navigationBar)
                    .height(44)
                    .marginHorizontal(10)
                flex.addItem(webView)
                    .grow(1)
            }
    }

}
