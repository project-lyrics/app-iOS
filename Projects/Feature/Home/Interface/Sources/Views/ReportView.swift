//
//  ReportView.swift
//  FeatureHomeInterface
//
//  Created by Derrick kim on 9/17/24.
//

import UIKit

import Domain
import Shared

import FlexLayout
import PinLayout

final class ReportView: UIView {
    // MARK: - UI Components

    let rootFlexContainer = UIView()
    let rootScrollView = UIScrollView()
    let contentView = UIView()

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

    lazy var reportReasonView = createReportReasonView()

    private let warningDescriptionTextView: UITextView = {
        let textView = UITextView()
        textView.text = "*관리자 검토 진행 후 신고가 반려될 수 있으며, 고의적인 허위신고가 반복될 경우 서비스 이용이 제한될 수 있습니다."
        textView.font = SharedDesignSystemFontFamily.Pretendard.regular.font(size: 12)
        textView.textColor = Colors.gray04
        textView.textAlignment = .left
        textView.isEditable = false
        textView.isScrollEnabled = false

        return textView
    }()

    let agreementButton: UIButton = {
        let contentView = SelectableAgreementView()
        contentView.setTitle("개인정보 수집에 동의합니다.")
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

        rootScrollView.pin
            .below(of: navigationBar)
            .left()
            .right()
            .bottom()

        contentView.pin.top().left().right()
        contentView.flex.layout(mode: .adjustHeight)

        rootScrollView.contentSize = contentView.frame.size
    }

    private func setUpLayout() {
        self.addSubview(rootFlexContainer)
        
        navigationBar.addLeftBarView([backButton])
        navigationBar.addTitleView(naviTitleLabel)

        rootFlexContainer
            .flex
            .direction(.column)
            .define { rootFlex in
                rootFlex.addItem(navigationBar)
                    .height(44)
                    .marginHorizontal(10)

                rootFlex.addItem(rootScrollView)
                    .direction(.column)
                    .define { scrollFlex in
                        scrollFlex.addItem(contentView)
                            .marginHorizontal(20)
                            .direction(.column)
                            .define { contentFlex in
                                contentFlex.addItem(reportReasonTitleLabel)
                                    .marginTop(24)

                                contentFlex.addItem(reportReasonView)
                                    .width(100%)
                                    .marginTop(16)

                                contentFlex.addItem(warningDescriptionTextView)
                                    .marginTop(24)
                                    .shrink(0)

                                contentFlex.addItem()
                                    .height(38)
                                    .grow(1)
                                    .shrink(0)
                            }
                    }

                rootFlex.addItem()
                    .position(.absolute)
                    .bottom(pin.safeArea.bottom)
                    .left(0)
                    .right(0)
                    .marginHorizontal(20)
                    .define { bottomFlex in
                        bottomFlex.addItem(agreementButton)

                        bottomFlex.addItem(reportButton)
                            .marginTop(36)
                            .cornerRadius(8)
                            .height(56)
                    }
            }
    }
}

private extension ReportView {
    func createReportReasonView() -> UIView {
        let containerView = UIView()

        containerView.flex
            .direction(.column)
            .define { flex in
                ReportReason.allCases.forEach {
                    let reportReasonView = ReportReasonView(model: $0)
                    flex.addItem(reportReasonView)
                        .marginBottom($0 != .other ? 16 : 0)
                }
            }

        return containerView
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

