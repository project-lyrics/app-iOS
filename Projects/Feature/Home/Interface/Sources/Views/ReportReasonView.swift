//
//  ReportReasonView.swift
//  FeatureHomeInterface
//
//  Created by Derrick kim on 9/21/24.
//

import Combine
import UIKit

import Domain
import Shared

import FlexLayout
import PinLayout

final class ReportReasonView: UIView {
    private enum Const {
        static let reasonPlaceholder = "신고사유를 작성해주세요."
    }

    let selectedItemPublisher = PassthroughSubject<ReportReason, Never>()

    private var cancellables = Set<AnyCancellable>()

    private let rootFlexContainer = UIView()

    private let contentLabel = {
        let label = UILabel()
        label.font = SharedDesignSystemFontFamily.Pretendard.regular.font(size: 16)
        label.textColor = Colors.gray09
        label.textAlignment = .left

        return label
    }()

    private let reasonButton: UIButton = {
        let button = FeelinSelectableImageButton(
            selectedImage: FeelinImages.checkBoxActive,
            unSelectedImage: FeelinImages.checkBoxInactive
        )
        button.isUserInteractionEnabled = false
        return button
    }()

    let reasonTextView: UITextView = {
        let textView = UITextView()
        textView.text = Const.reasonPlaceholder
        textView.textAlignment = .left
        textView.font = SharedDesignSystemFontFamily.Pretendard.regular.font(size: 14)
        textView.tintColor = Colors.gray08
        textView.textColor = Colors.gray04
        textView.backgroundColor = Colors.inputField
        textView.textContainerInset = UIEdgeInsets(top: 12, left: 12, bottom: 12, right: 12)

        return textView
    }()

    private let model: ReportReason

    init(model: ReportReason) {
        self.model = model
        super.init(frame: .zero)

        self.setupLayout()
        self.setUpTextViewText()
        self.setUpTapAction()
        self.configure(model: model)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        rootFlexContainer.pin.all()
        rootFlexContainer.flex.layout()
    }

    private func setupLayout() {
        addSubview(rootFlexContainer)

        rootFlexContainer.flex
            .direction(.column)
            .define { flex in
                flex.addItem()
                    .direction(.row)
                    .define { flex in
                        flex.addItem(reasonButton)
                        flex.addItem(contentLabel).marginLeft(8)
                    }

                flex.addItem(reasonTextView)
                    .marginTop(16)
                    .cornerRadius(8)
                    .height(64)
                    .maxHeight(144)
                    .isIncludedInLayout(false)
            }
    }

    private func setUpTextViewText() {
        reasonTextView.textPublisher(for: [.didBeginEditing])
            .receive(on: DispatchQueue.main)
            .sink { [weak self] text in
                guard let self = self else { return }

                if text == Const.reasonPlaceholder {
                    reasonTextView.setUpTextView(text: "", textColor: Colors.gray08)
                }
            }
            .store(in: &cancellables)

        reasonTextView.textPublisher(for: [.didEndEditing])
            .receive(on: DispatchQueue.main)
            .sink { [weak self] text in
                guard let self = self else { return }

                if text?.isEmpty == true {
                    reasonTextView.setUpTextView(text: Const.reasonPlaceholder, textColor: Colors.gray04)
                }
            }
            .store(in: &cancellables)
    }

    private func setUpTapAction() {
        self.tapPublisher
            .sink { [weak self] in
                guard let self = self else { return }
                selectedItemPublisher.send(model)
            }
            .store(in: &cancellables)
    }

    private func configure(model: ReportReason) {
        contentLabel.text = model.title
    }

    func setSelected(_ selected: Bool, with item: ReportReason?) {
        reasonButton.isSelected = selected

        let shouldShowTextView = item == .other && selected

        reasonTextView.isHidden = !shouldShowTextView
        reasonTextView.flex.isIncludedInLayout(shouldShowTextView)
        reasonTextView.flex.markDirty()

        rootFlexContainer.flex.layout()
    }
}
