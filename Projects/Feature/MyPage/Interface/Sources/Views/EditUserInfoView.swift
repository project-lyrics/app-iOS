//
//  EditUserInfoView.swift
//  FeatureMyPageInterface
//
//  Created by Derrick kim on 10/13/24.
//

import UIKit

import Shared
import Combine
import FeatureOnboardingInterface

final class EditUserInfoView: UIView {
    // MARK: - components

    private let flexContainer = UIView()

    private let navigationBar = NavigationBar()

    let backButton: UIButton = {
        let button = UIButton()
        let image = FeelinImages.back
        button.setImage(image, for: .normal)

        return button
    }()

    private let naviTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "회원 정보 수정"
        label.font = SharedDesignSystemFontFamily.Pretendard.bold.font(size: 18)
        label.textColor = Colors.gray09

        return label
    }()

    private lazy var genderTitleLabel = {
        let label = createInformationTitleLabel()
        label.text = "성별"
        return label
    }()

    let genderCollectionView = GenderCollectionView()

    private lazy var birthYearTitleLabel = {
        let label = createInformationTitleLabel()
        label.text = "출생 연도"
        return label
    }()

    let birthYearDropDownButton = FeelinDropDownButton(description: "")

    let saveProfileButton = FeelinConfirmButton(title: "회원 정보 저장")

    // MARK: - init

    override init(frame: CGRect) {
        super.init(frame: frame)

        backgroundColor = Colors.background
        setUpLayout()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - layout

    override func layoutSubviews() {
        super.layoutSubviews()

        flexContainer.pin.all(pin.safeArea)
        flexContainer.flex.layout()
    }

    private func setUpLayout() {
        addSubview(flexContainer)

        navigationBar.addLeftBarView([backButton])
        navigationBar.addTitleView(naviTitleLabel)

        flexContainer
            .flex
            .direction(.column)
            .define { flex in
                flex.addItem(navigationBar)
                    .height(44)
                    .marginLeft(10)
                    .marginRight(20)

                flex.addItem()
                    .direction(.column)
                    .marginHorizontal(20)
                    .marginTop(36)
                    .grow(1)
                    .define { flex in
                        flex.addItem(genderTitleLabel)

                        flex.addItem(genderCollectionView)
                            .height(204)
                            .marginTop(12)

                        flex.addItem(birthYearTitleLabel)
                            .marginTop(24)
                        flex.addItem(birthYearDropDownButton)
                            .minHeight(52)
                            .marginTop(12)
                            .cornerRadius(8)

                        flex.addItem()
                            .grow(1)

                        flex.addItem(saveProfileButton)
                            .minHeight(56)
                            .cornerRadius(8)
                            .marginBottom(23)
                    }
            }
    }
}

private extension EditUserInfoView {
    func createInformationTitleLabel() -> UILabel {
        let label = UILabel()
        label.font = SharedDesignSystemFontFamily.Pretendard.semiBold.font(size: 16)
        label.textColor = Colors.gray05
        return label
    }
}
