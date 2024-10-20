//
//  MyPageView.swift
//  FeatureMyPageInterface
//
//  Created by Derrick kim on 10/9/24.
//

import UIKit

import Shared

final class MyPageView: UIView {
    let rootFlexContainer = UIView()
    private let navigationBar = NavigationBar()

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "마이페이지"
        label.font = SharedDesignSystemFontFamily.Pretendard.bold.font(size: 18)
        label.textColor = Colors.gray09

        return label
    }()

    let settingBarButton: UIButton = {
        let button = UIButton()
        button.setImage(FeelinImages.setting, for: .normal)
        return button
    }()

    let notificationButton: UIButton = {
        let button = UIButton()
        button.setImage(FeelinImages.notificationOff, for: .normal)
        return button
    }()

    private let myIconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.image = ProfileCharacterType.defaultImage

        return imageView
    }()

    let userNicknameContainerView = UIView()

    let userNicknameLabel: UILabel = {
        let label = UILabel()
        label.text = "로그인"
        label.font = SharedDesignSystemFontFamily.Pretendard.bold.font(size: 18)
        label.textColor = Colors.gray09

        return label
    }()

    private let caretRightImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.image = FeelinImages.caretRight

        return imageView
    }()

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

        navigationBar.addLeftBarView([])
        navigationBar.addTitleView(titleLabel)
        navigationBar.addRightBarView([settingBarButton, notificationButton])

        rootFlexContainer
            .flex
            .direction(.column)
            .define { flex in
                flex.addItem(navigationBar)
                    .height(44)
                    .marginHorizontal(10)

                flex.addItem()
                    .direction(.column)
                    .alignItems(.center)
                    .marginTop(24)
                    .define { flex in
                        flex.addItem(myIconImageView)
                            .size(100)

                        flex.addItem(userNicknameContainerView)
                            .marginTop(12)
                            .grow(1)
                            .direction(.row)
                            .alignItems(.center)
                            .define { flex in
                                flex.addItem(userNicknameLabel)
                                    .marginRight(4)
                                    .grow(1)

                                flex.addItem(caretRightImageView)
                                    .size(18)
                            }
                    }
            }
    }
}
