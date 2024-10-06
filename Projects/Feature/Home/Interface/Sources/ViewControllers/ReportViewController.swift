//
//  ReportViewController.swift
//  FeatureHomeInterface
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
    private let selectedReportReasonPublisher = PassthroughSubject<ReportReason, Never>()
    private let reportReasonDescriptionPublisher = CurrentValueSubject<String?, Never>(nil)

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

    public override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }

    private func setUpDefault() {
        view.backgroundColor = Colors.background
        navigationController?.tabBarController?.tabBar.isHidden = true
    }

    private func bind() {
        backButton.publisher(for: .touchUpInside)
            .receive(on: DispatchQueue.main)
            .sink { _ in
                self.coordinator?.popViewController()
            }
            .store(in: &cancellables)

        reportReasonView.subviews
            .map { $0 as? ReportReasonView }
            .forEach { reasonView in
                reasonView?.selectedItemPublisher
                    .sink { [weak self] item in
                        self?.selectedReportReasonPublisher.send(item)
                        self?.handleSelectedReportReasonView(of: reasonView, with: item)
                    }
                    .store(in: &cancellables)
            }

        let agreementTapPublisher = agreementButton.publisher(for: .touchUpInside).eraseToAnyPublisher()
        let reportButtonTapPublisher = reportButton.publisher(for: .touchUpInside).eraseToAnyPublisher()

        let input = ReportViewModel.Input(
            selectedReportReasonPublisher: selectedReportReasonPublisher.eraseToAnyPublisher(),
            reportReasonDescriptionPublisher: reportReasonDescriptionPublisher.eraseToAnyPublisher(),
            agreementTapPublisher: agreementTapPublisher,
            reportButtonTapPublisher: reportButtonTapPublisher
        )

        let output = viewModel.transform(input: input)

        output.isEnabledReportButton
            .assign(to: \.isEnabled, on: reportButton)
            .store(in: &cancellables)

        output.reportNoteResult
            .receive(on: DispatchQueue.main)
            .sink { [weak self] result in
                switch result {
                case .success:
                    self?.showAlert(title: "신고가 접수되었어요.", message: nil, singleActionTitle: "확인", actionCompletion: {
                        self?.coordinator?.popViewController()
                    })
                case .failure(let error):
                    self?.showAlert(title: error.errorDescription, message: nil, singleActionTitle: "확인", actionCompletion: {
                        self?.coordinator?.popViewController()
                    })
                }
            }
            .store(in: &cancellables)

        CombineKeyboard.keyboardHeightPublisher
            .sink { [weak self] keyboardHeight in
                self?.rootScrollView.contentInset.bottom = keyboardHeight
                self?.rootScrollView.verticalScrollIndicatorInsets.bottom = keyboardHeight

                // 스크롤 위치 조정을 위해 caretRect를 사용
                guard let textView = self?.selectedReportReasonView?.reasonTextView,
                      let end = textView.selectedTextRange?.end else { return }
                let caretRect = textView.caretRect(for: end)

                // caret 위치로 스크롤 조정
                self?.rootScrollView.scrollRectToVisible(caretRect, animated: true)

                UIView.animate(withDuration: 0.3) {
                    self?.view.layoutIfNeeded()
                }
            }
            .store(in: &cancellables)
    }

    private func handleSelectedReportReasonView(
        of selectedView: ReportReasonView?,
        with item: ReportReason?
    ) {
        if let previouslySelectedView = self.selectedReportReasonView,
           previouslySelectedView != selectedView {
            previouslySelectedView.setSelected(false, with: item)
            previouslySelectedView.flex.markDirty()
        }

        selectedView?.setSelected(true, with: item)
        selectedView?.flex.markDirty()
        self.selectedReportReasonView = selectedView

        if item == .other {
            reportReasonView.flex.markDirty()
            reportReasonView.flex.layout(mode: .adjustHeight)
            setUpTextView()

            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                self.scrollToTextView(textView: selectedView?.reasonTextView)
            }
        } else {
            view.endEditing(true)
        }

        reportView.contentView.flex.layout(mode: .adjustHeight)
    }

    private func scrollToTextView(textView: UITextView?) {
        guard let textView = textView,
              let end = textView.selectedTextRange?.end else { return }

        let caretRect = textView.caretRect(for: end)
        rootScrollView.scrollRectToVisible(caretRect, animated: true)
    }

    private func setUpTextView() {
        guard let reasonTextView = selectedReportReasonView?.reasonTextView else { return }

        if reasonTextView.text.isEmpty {
            reasonTextView.setUpTextView(text: Const.reasonPlaceholder, textColor: Colors.gray04)
        }

        reasonTextView.textPublisher(for: [.didChange, .didBeginEditing])
            .receive(on: DispatchQueue.main)
            .sink { [weak self] text in
                self?.adjustTextViewHeight(reasonTextView)

                guard text != "", text != Const.reasonPlaceholder else { return }
                self?.reportReasonDescriptionPublisher.send(text)
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
        contentView.flex.layout(mode: .adjustHeight)

        // rootScrollView의 contentSize를 업데이트
        rootScrollView.contentSize = contentView.frame.size

        // 스크롤 위치 조정을 위해 caretRect를 사용
        scrollToTextView(textView: textView)
    }
}

extension ReportViewController {
    var backButton: UIButton {
        return reportView.backButton
    }

    var rootScrollView: UIScrollView {
        return reportView.rootScrollView
    }

    var reportReasonView: UIView {
        return reportView.reportReasonView
    }

    var contentView: UIView {
        return reportView.contentView
    }

    var agreementButton: UIButton {
        return reportView.agreementButton
    }

    var reportButton: UIButton {
        return reportView.reportButton
    }
}
