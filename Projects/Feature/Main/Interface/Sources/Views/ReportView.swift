//
//  ReportView.swift
//  FeatureMainInterface
//
//  Created by Derrick kim on 9/17/24.
//

import UIKit

import DomainOAuthInterface
import Shared

import FlexLayout
import PinLayout

final class ReportView: UIView {
    // MARK: - UI Components

    let rootFlexContainer = UIView()
    private let rootScrollView = UIScrollView()

    private let navigationBar = NavigationBar()

    lazy var backButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false

        let userInterfaceStyle = traitCollection.userInterfaceStyle
        let image = userInterfaceStyle == .light ? FeelinImages.backLight : FeelinImages.backDark
        button.setImage(image, for: .normal)

        return button
    }()

    private let naviTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "신고하기"
        label.font = SharedDesignSystemFontFamily.Pretendard.bold.font(size: 18)
        label.textColor = Colors.gray09

        return label
    }()

    private let reportReasonTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "신고사유"
        label.font = SharedDesignSystemFontFamily.Pretendard.bold.font(size: 18)
        label.textColor = Colors.gray09

        return label
    }()

    lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.separatorStyle = .none
        tableView.isScrollEnabled = false
        tableView.allowsMultipleSelection = false
        tableView.register(cellType: ReportReasonTableViewCell.self)

        return tableView
    }()

    private let emailTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "이메일"
        label.font = SharedDesignSystemFontFamily.Pretendard.bold.font(size: 18)
        label.textColor = Colors.gray09

        return label
    }()

    private let emailTextField = {
        let textField = UITextField()
        textField.placeholder = "처리 결과 수신을 원하시면 이메일을 입력해주세요."
        textField.font = SharedDesignSystemFontFamily.Pretendard.regular.font(size: 14)
        textField.textColor = Colors.gray04
        textField.backgroundColor = Colors.inputField

        let leftPaddingView = UIView(frame: CGRect(x: 0, y: 0, width: 12, height: 0))
        textField.leftView = leftPaddingView
        textField.leftViewMode = .always

        return textField
    }()

    private let warningDescriptionLabel: UILabel = {
        let label = UILabel()
        label.text = "*관리자 검토 진행 후 신고가 반려될 수 있으며, 고의적인 허위신고가 반복될 경우 서비스 이용이 제한될 수 있습니다."
        label.font = SharedDesignSystemFontFamily.Pretendard.regular.font(size: 12)
        label.textColor = Colors.gray04
        label.numberOfLines = 0

        return label
    }()

    lazy var agreementButton: UIButton = {
        let contentView = SelectableAgreementView()
        contentView.setTitle(TermEntity.ageAgree.title)
        let button = CheckBoxButton(additionalView: contentView)
        return button
    }()

    let reportButton = FeelinConfirmButton(title: "신고하기")

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

        rootFlexContainer.pin.all(pin.safeArea)
        rootFlexContainer.flex.layout()
    }

    private func setUpLayout() {
        self.addSubview(rootFlexContainer)

        navigationBar.addLeftBarView(backButton)
        navigationBar.addTitleView(naviTitleLabel)

        rootFlexContainer
            .flex
            .direction(.column)
            .marginHorizontal(20)
            .marginBottom(pin.safeArea.bottom + 23)
            .define { flex in
                flex.addItem(rootScrollView)
                    .direction(.column)
                    .define { flex in
                        flex.addItem(navigationBar)
                            .height(44)
                            .marginTop(pin.safeArea.top)

                        flex.addItem()
                            .define { flex in
                                flex.addItem(reportReasonTitleLabel)
                                    .marginTop(24)

                                flex.addItem(tableView)
                                    .marginTop(16)
                                    .grow(1)
                            }

                        flex.addItem()
                            .marginTop(40)
                            .define { flex in
                                flex.addItem(emailTitleLabel)

                                flex.addItem(emailTextField)
                                    .marginTop(12)
                                    .cornerRadius(8)
                                    .height(44)

                                flex.addItem(warningDescriptionLabel)
                                    .marginTop(18)
                            }

                        flex.addItem()
                            .marginTop(65)
                            .define { flex in
                                flex.addItem(agreementButton)
                                    .grow(1)

                                flex.addItem(reportButton)
                                    .marginTop(36)
                                    .cornerRadius(8)
                                    .height(56)
                            }
                    }
            }
    }
}

#if canImport(SwiftUI)
import SwiftUI

struct ReportView_Preview: PreviewProvider {
    static var previews: some View {
        ReportView(
            frame: .init(x: 0, y: 0, width: 350, height: 514)
        ).showPreview()
    }
}
#endif

