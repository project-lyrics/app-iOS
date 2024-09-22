//
//  ReportViewController.swift
//  FeatureMainInterface
//
//  Created by Derrick kim on 9/17/24.
//

import Combine
import UIKit

import Domain
import Shared

public protocol ReportViewControllerDelegate: AnyObject {
    func popViewController()
}

public final class ReportViewController: UIViewController {
    private enum Const {
        static let reasonPlaceholder = "신고사유를 작성해주세요."
    }

    private var cancellables = Set<AnyCancellable>()

    private var selectedReportReasonView: ReportReasonView?
    private let reportView = ReportView()
    private let viewModel: ReportViewModel

    public weak var coordinator: ReportViewControllerDelegate?

    public init(viewModel: ReportViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    public required init?(coder: NSCoder) {
        fatalError()
    }

    public override func loadView() {
        self.view = reportView
    }

    public override func viewDidLoad() {
        super.viewDidLoad()

        setUpDefault()
        bind()
    }

    private func setUpDefault() {
        view.backgroundColor = Colors.background
    }

    private func bind() {
        backButton.publisher(for: .touchUpInside)
            .receive(on: DispatchQueue.main)
            .sink { _ in
                self.coordinator?.popViewController()
            }
            .store(in: &cancellables)

        reportReasonView.subviews.forEach { subview in
            if let reasonView = subview as? ReportReasonView {
                reasonView.selectedItemPublisher
                    .sink { [weak self] item in
                        self?.handleSelectedReportReasonView(of: reasonView, with: item)
                    }
                    .store(in: &cancellables)
            }
        }
    }

    private func handleSelectedReportReasonView(
        of selectedView: ReportReasonView,
        with item: ReportReason?
    ) {
        if let previouslySelectedView = self.selectedReportReasonView,
           previouslySelectedView != selectedView {
            previouslySelectedView.setSelected(false, with: item)
            previouslySelectedView.flex.markDirty()
        }

        selectedView.setSelected(true, with: item)
        selectedView.flex.markDirty()
        self.selectedReportReasonView = selectedView

        if item == .other {
            reportReasonView.flex.markDirty()
            reportReasonView.flex.layout(mode: .adjustHeight)
            setUpReportReasonTextView()
        } else {
            view.endEditing(true)
        }

        reportView.contentView.flex.layout(mode: .adjustHeight)
    }

    private func setUpReportReasonTextView() {
        guard let reasonTextView = selectedReportReasonView?.reasonTextView else { return }

        if reasonTextView.text.isEmpty {
            reasonTextView.text = Const.reasonPlaceholder
        }

        reasonTextView.textPublisher(for: [.didChange, .didBeginEditing])
            .receive(on: DispatchQueue.main)
            .sink { [weak self] text in
                self?.adjustTextViewHeight(reasonTextView)
            }
            .store(in: &cancellables)
    }

    private func adjustTextViewHeight(_ textView: UITextView) {
        let numberOfLines = textView.numberOfLine()

        if numberOfLines > 1 && numberOfLines <= 6 {
            let size = textView.sizeThatFits(
                CGSize(
                    width: textView.frame.width,
                    height: .infinity
                )
            )

            textView.flex.height(size.height).markDirty()
            textView.isScrollEnabled = false
        } else if numberOfLines > 6 {
            let maxHeight = textView.frame.height

            textView.flex.height(maxHeight).markDirty()
            textView.isScrollEnabled = true
        } else {
            textView.flex.height(64).markDirty()
            textView.isScrollEnabled = true
        }

        reportView.reportReasonView.flex.layout()
        reportView.contentView.flex.layout()
    }
}

extension ReportViewController {
    var backButton: UIButton {
        return reportView.backButton
    }

    var reportReasonView: UIView {
        return reportView.reportReasonView
    }

    var agreementButton: UIButton {
        return reportView.agreementButton
    }

    var reportButton: UIButton {
        return reportView.reportButton
    }
}
