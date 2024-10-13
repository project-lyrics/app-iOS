//
//  DeleteUserView.swift
//  FeatureMyPageInterface
//
//  Created by Derrick kim on 10/12/24.
//

import UIKit

import Shared

final class DeleteUserView: UIView {
    private let rootFlexContainer = UIView()
    private let navigationBar = NavigationBar()

    private let naviTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "회원 탈퇴"
        label.font = SharedDesignSystemFontFamily.Pretendard.bold.font(size: 18)
        label.textColor = Colors.gray09

        return label
    }()

    let backButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        let image = FeelinImages.back
        button.setImage(image, for: .normal)

        return button
    }()

    private let contentTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "탈퇴하기 전 확인해주세요"
        label.font = SharedDesignSystemFontFamily.Pretendard.bold.font(size: 18)
        label.textColor = Colors.tertiary

        return label
    }()

    let infoConfirmationButton: UIButton = {
        let contentView = SelectableAgreementView()
        contentView.setTitle("안내사항을 확인했습니다.")
        let button = CheckBoxButton(additionalView: contentView)
        return button
    }()

    let deleteUserButton: UIButton = {
        let button = FeelinConfirmButton(title: "탈퇴하기")

        return button
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

        navigationBar.addTitleView(naviTitleLabel)
        navigationBar.addLeftBarView([backButton])

        rootFlexContainer
            .flex
            .direction(.column)
            .define { flex in
                flex.addItem(navigationBar)
                    .height(44)
                    .marginHorizontal(10)
                
                flex.addItem()
                    .marginHorizontal(20)
                    .marginTop(28)
                    .define { flex in
                        flex.addItem(contentTitleLabel)
                    }

                flex.addItem()
                    .marginTop(28)
                    .marginHorizontal(20)
                    .grow(1)
                    .define { flex in
                        contentTexts.forEach { text in
                            flex.addItem(makeContentLabelView(text: text))
                                .marginBottom(20)
                        }
                    }

                flex.addItem()
                    .marginHorizontal(20)
                    .define { flex in
                        flex.addItem(infoConfirmationButton)

                        flex.addItem(deleteUserButton)
                            .height(56)
                            .marginTop(36)
                            .cornerRadius(8)
                    }
            }
    }

    private func makeContentLabelView(text: String) -> UIView {
        let flexContainerView = UIView()
        let emojiLabel = UILabel()
        emojiLabel.text = "•"

        let contentLabel = UILabel()
        contentLabel.text = text
        contentLabel.font = SharedDesignSystemFontFamily.Pretendard.regular.font(size: 16)
        contentLabel.textColor = Colors.gray09
        contentLabel.numberOfLines = 0

        flexContainerView
            .flex
            .direction(.row)
            .alignItems(.baseline)
            .define { flex in
                flex.addItem(emojiLabel)
                    .marginRight(4)

                flex.addItem(contentLabel)
            }

        return flexContainerView
    }
}

extension DeleteUserView {
    private var contentTexts: [String] {
        return [
            "회원가입 시 연동된 SNS 계정은 탈퇴 즉시 Feelin과 연동이 해제됩니다.",
            "탈퇴 후 개인정보, 관심 아티스트 추가 내역 등의 데이터가 삭제되며, 복구할 수 없습니다. 단, [개인정보보호법, 통신비밀보호법] 등 기타 법령에서 요구하는 정보는 해당 법령에서 요구하는 기간동안 보존합니다.",
            "탈퇴 후 작성하신 노트 및 댓글은 삭제되지 않으며, (알수없음)으로 닉네임이 표시됩니다. 삭제를 원하시는 경우, 먼저 해당 글을 삭제하신 후 탈퇴 신청을 부탁드립니다."
        ]
    }
}
