//
//  UserProfileView.swift
//  FeatureMyPageInterface
//
//  Created by Derrick kim on 10/12/24.
//

import UIKit

import Shared
import Domain

final class UserProfileView: UIView {
    private let rootFlexContainer = UIView()
    private let navigationBar = NavigationBar()

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "회원 정보"
        label.font = SharedDesignSystemFontFamily.Pretendard.bold.font(size: 18)
        label.textColor = Colors.gray09

        return label
    }()

    let backButton: UIButton = {
        let button = UIButton()
        let image = FeelinImages.back
        button.setImage(image, for: .normal)

        return button
    }()

    private let loginInfoTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "로그인 정보"
        label.font = SharedDesignSystemFontFamily.Pretendard.medium.font(size: 14)
        label.textColor = Colors.gray04

        return label
    }()

    private let loginIconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = FeelinImages.kakaoBadge
        imageView.contentMode = .scaleAspectFit

        return imageView
    }()

    private let loginInfoLabel: UILabel = {
        let label = UILabel()
        label.font = SharedDesignSystemFontFamily.Pretendard.medium.font(size: 14)
        label.textColor = Colors.gray09

        return label
    }()

    private let userIDTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "유저 ID"
        label.font = SharedDesignSystemFontFamily.Pretendard.medium.font(size: 14)
        label.textColor = Colors.gray04

        return label
    }()

    private let userIDInfoLabel: UILabel = {
        let label = UILabel()
        label.font = SharedDesignSystemFontFamily.Pretendard.medium.font(size: 14)
        label.textColor = Colors.gray09

        return label
    }()

    let copyButton: UIButton = {
        let button = UIButton()
        button.setTitle("복사", for: .normal)
        button.titleLabel?.font = SharedDesignSystemFontFamily.Pretendard.medium.font(size: 14)
        button.contentEdgeInsets = UIEdgeInsets(top: 4, left: 8, bottom: 4, right: 8)
        button.setTitleColor(Colors.active, for: .normal)
        button.backgroundColor = Colors.pressedBrand

        return button
    }()

    let otherInfoContainerView = UIView()

    let otherInfoTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "성별 및 출생연도"
        label.font = SharedDesignSystemFontFamily.Pretendard.medium.font(size: 14)
        label.textColor = Colors.gray04

        return label
    }()

    private let otherInfoLabel: UILabel = {
        let label = UILabel()
        label.font = SharedDesignSystemFontFamily.Pretendard.medium.font(size: 14)
        label.textColor = Colors.gray09
        label.text = "정보를 입력해주세요"

        return label
    }()

    private let caretRightImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = FeelinImages.caretRight.withRenderingMode(.alwaysTemplate)
        imageView.contentMode = .scaleAspectFit
        imageView.tintColor = Colors.gray05

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

        navigationBar.addLeftBarView([backButton])
        navigationBar.addTitleView(titleLabel)

        rootFlexContainer
            .flex
            .direction(.column)
            .define { flex in
                flex.addItem(navigationBar)
                    .height(44)
                    .marginHorizontal(10)

                flex.addItem()
                    .marginTop(40)
                    .marginHorizontal(20)
                    .define { flex in
                        flex.addItem(loginInfoTitleLabel)

                        flex.addItem()
                            .marginTop(16)
                            .direction(.row)
                            .define { flex in
                                flex.addItem(loginIconImageView)
                                    .size(24)
                                    .marginRight(6)

                                flex.addItem(loginInfoLabel)
                                    .shrink(1)
                            }
                    }

                flex.addItem()
                    .marginTop(22)
                    .height(1)
                    .backgroundColor(Colors.gray01)

                flex.addItem()
                    .marginTop(24)
                    .marginHorizontal(20)
                    .define { flex in
                        flex.addItem(userIDTitleLabel)

                        flex.addItem()
                            .marginTop(16)
                            .direction(.row)
                            .define { flex in
                                flex.addItem(userIDInfoLabel)
                                    .marginRight(18)
                                    .grow(1)

                                flex.addItem(copyButton)
                                    .width(41)
                                    .height(28)
                                    .shrink(1)
                                    .cornerRadius(4)
                            }
                    }

                flex.addItem()
                    .marginTop(22)
                    .height(1)
                    .backgroundColor(Colors.gray01)

                flex.addItem(otherInfoContainerView)
                    .marginTop(24)
                    .marginHorizontal(20)
                    .define { flex in
                        flex.addItem(otherInfoTitleLabel)

                        flex.addItem()
                            .marginTop(16)
                            .direction(.row)
                            .define { flex in
                                flex.addItem(otherInfoLabel)
                                    .marginRight(18)
                                    .grow(1)

                                flex.addItem(caretRightImageView)
                            }
                    }
            }
    }

    func configure(_ model: UserProfile?) {
        guard let model = model else { return }

        let loginType = OAuthType(rawValue: model.authProvider)
        let loginIcon = loginType == .apple ? FeelinImages.appleBadge : FeelinImages.kakaoBadge
        let otherInfo = model.gender == nil ? "정보를 입력해주세요" : "\(model.gender?.description ?? "")ㆍ\(model.birthYear ?? 0)년"
        loginIconImageView.image = loginIcon
        loginInfoLabel.text = loginType?.info
        userIDInfoLabel.text = model.feedbackID
        otherInfoLabel.text = otherInfo

        loginInfoLabel.flex.markDirty()
        userIDInfoLabel.flex.markDirty()
        otherInfoLabel.flex.markDirty()

        rootFlexContainer.flex.layout()
    }
}
