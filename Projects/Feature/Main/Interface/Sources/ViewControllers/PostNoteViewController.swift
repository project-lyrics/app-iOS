//
//  PostNoteViewController.swift
//  FeatureMainInterface
//
//  Created by Derrick kim on 8/7/24.
//

import UIKit
import Shared

public final class PostNoteViewController: UIViewController {
    enum Const {
        static let noteMaxTextLength = 1000
        static let lyricsMaxTextLength = 50
        static let maxTextViewHeight: CGFloat = 132
        static let lyricsPlaceholder = "좋아하는 가사를 적어주세요 (선택)"
        static let notePlaceholder = "생각을 남겨보세요."
    }

    private let postNoteView = PostNoteView()
    private let viewModel: PostNoteViewModel

    public init(viewModel: PostNoteViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    deinit {
        removeKeyboardObservers()
    }

    @available(*, unavailable)
    public required init?(coder: NSCoder) {
        fatalError()
    }

    public override func loadView() {
        self.view = postNoteView
    }

    public override func viewDidLoad() {
        super.viewDidLoad()

        setUpDefaults()
        setUpKeyboardEvent()
    }

    public override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        setupLyricsTextviewTextCenterVertically(lyricsTextView)
    }

    private func setUpDefaults() {
        noteTextView.delegate = self
        lyricsTextView.delegate = self
        setupLyricsTextviewTextCenterVertically(lyricsTextView)
    }

    private func setUpKeyboardEvent() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillShow),
            name: UIResponder.keyboardWillShowNotification,
            object: nil
        )
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillHide),
            name: UIResponder.keyboardWillHideNotification,
            object: nil
        )
    }

    private func removeKeyboardObservers() {
        NotificationCenter.default.removeObserver(
            self,
            name: UIResponder.keyboardWillShowNotification,
            object: nil
        )
        NotificationCenter.default.removeObserver(
            self,
            name: UIResponder.keyboardWillHideNotification,
            object: nil
        )
    }

    @objc private func keyboardWillShow(notification: NSNotification) {
        if let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect {
            let keyboardHeight = keyboardFrame.height
            rootScrollView.contentInset.bottom = keyboardHeight
            rootScrollView.verticalScrollIndicatorInsets.bottom = keyboardHeight
            noteCharCountLabel.pin.bottom(keyboardHeight + 12).right(16)
        }
    }

    @objc private func keyboardWillHide(notification: NSNotification) {
        rootScrollView.contentInset.bottom = 0
        rootScrollView.verticalScrollIndicatorInsets.bottom = 0
        noteCharCountLabel.pin.bottom(12).right(16)
    }
}

// MARK: - UITextViewDelegate

extension PostNoteViewController: UITextViewDelegate {
    public func textViewDidBeginEditing(_ textView: UITextView) {
        // 텍스트 뷰가 편집을 시작할 때 기본 값을 빈 문자열로 변경
        if textView == noteTextView && textView.text == Const.notePlaceholder {
            textView.text = ""
            textView.textColor = Colors.gray08
        } else if textView == lyricsTextView && textView.text == Const.lyricsPlaceholder {
            textView.text = ""
            textView.textColor = Colors.gray08
        }
    }

    public func textViewDidEndEditing(_ textView: UITextView) {
        // 텍스트 뷰 편집이 끝나고 텍스트가 비어 있을 때 기본 값을 복원
        if textView == noteTextView && textView.text.isEmpty {
            textView.text = Const.notePlaceholder
            textView.textColor = Colors.gray04
        } else if textView == lyricsTextView && textView.text.isEmpty {
            textView.text = Const.lyricsPlaceholder
            textView.textColor = Colors.gray04
            setupLyricsTextviewTextCenterVertically(textView)
        }
    }

    public func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        // 최대 길이 제한
        let currentText = textView.text ?? ""
        let prospectiveText = (currentText as NSString).replacingCharacters(in: range, with: text)

        if textView == noteTextView {
            return prospectiveText.count <= Const.noteMaxTextLength
        } else { // lyrics TextView의 길이
            return prospectiveText.count <= Const.lyricsMaxTextLength
        }
    }

    public func textViewDidChange(_ textView: UITextView) {
        if textView == noteTextView {
            // 텍스트가 변경될 때마다 FlexLayout을 사용해 높이를 재조정
            textView.flex.markDirty()
            contentView.flex.layout(mode: .adjustHeight)

            // ScrollView의 contentSize를 업데이트하여 스크롤 가능하게 만듦
            rootScrollView.contentSize = contentView.frame.size

            // 텍스트 뷰가 키보드에 의해 가려지는 경우를 방지하기 위해 스크롤 위치를 조정
            guard let end = textView.selectedTextRange?.end else { return }
            let caretRect = textView.caretRect(for: end)
            rootScrollView.scrollRectToVisible(caretRect, animated: true)
        } else { // lyrics TextView
            setupLyricsTextviewTextCenterVertically(textView)
            updateCharacterCountForLyrics()

            // 텍스트 길이 초과 방지
            if textView.text.count > Const.lyricsMaxTextLength {
                textView.text = String(textView.text.prefix(Const.lyricsMaxTextLength))
            }

            // 텍스트 뷰 높이 제한
            let contentHeight = textView.contentSize.height
            textView.isScrollEnabled = contentHeight > Const.maxTextViewHeight
        }
    }

    private func setupLyricsTextviewTextCenterVertically(_ textView: UITextView) {
        let textSize = textView.sizeThatFits(CGSize(width: textView.frame.width, height: CGFloat.greatestFiniteMagnitude))
        let topCorrection = (textView.frame.size.height - textSize.height * textView.zoomScale) / 2.0
        let topInset = max(0, topCorrection)

        if textView.text.isEmpty {
            let lineHeight = textView.font?.lineHeight ?? 0
            textView.textContainerInset = UIEdgeInsets(
                top: (textView.bounds.height / 2) - (lineHeight / 2),
                left: 52,
                bottom: 0,
                right: 52
            )
        } else {
            textView.textContainerInset = UIEdgeInsets(
                top: topInset + 55,
                left: 52,
                bottom: 36,
                right: 52
            )
        }
    }

    private func updateCharacterCountForLyrics() {
        let count = lyricsTextView.text.count
        lyricsCharCountLabel.text = "\(count)/\(Const.lyricsMaxTextLength)"
    }
}

extension PostNoteViewController {
    var rootScrollView: UIScrollView {
        return postNoteView.rootScrollView
    }

    var contentView: UIView {
        return postNoteView.contentView
    }

    var addToPlayButton: UIButton {
        return postNoteView.addToPlayButton
    }

    var lyricsTextView: UITextView {
        return postNoteView.lyricsTextView
    }

    var lyricsCharCountLabel: UILabel {
        return postNoteView.lyricsCharCountLabel
    }

    var selectLyricsBackgroundButton: UIView {
        return postNoteView.selectLyricsBackgroundButton
    }

    var searchLyricsButton: UIView {
        return postNoteView.searchLyricsButton
    }

    var noteTextView: UITextView {
        return postNoteView.noteTextView
    }

    var noteCharCountLabel: UILabel {
        return postNoteView.noteCharCountLabel
    }
}
