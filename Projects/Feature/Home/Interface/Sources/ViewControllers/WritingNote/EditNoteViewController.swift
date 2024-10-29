//
//  EditNoteViewController.swift
//  FeatureHomeInterface
//
//  Created by Derrick kim on 10/11/24.
//

import Combine
import UIKit
import Shared
import Domain

public protocol EditNoteViewControllerDelegate: AnyObject {
    func dismissViewController()
    func didFinishForPresentingViewController()
}

public final class EditNoteViewController: UIViewController {
    enum Const {
        static let noteMaxTextLength = 1000
        static let lyricsMaxTextLength = 50
        static let maxTextViewHeight: CGFloat = 132
        static let lyricsPlaceholder = "좋아하는 가사를 적어주세요 (선택)"
        static let notePlaceholder = "생각을 남겨보세요."
    }
    private var keyboardHeight = 0.0
    private let lyricsBackgroundViewController = LyricsBackgroundViewController(
        bottomSheetHeight: UIScreen.main.bounds.height * 0.77
    )
    private let searchSongWebViewController = SearchSongWebViewController(
        bottomSheetHeight: UIScreen.main.bounds.height * 0.88
    )

    private let editNoteView = WritingNoteView()
    private var cancellables = Set<AnyCancellable>()
    private let viewModel: EditNoteViewModel

    private let selectedSongPublisher = PassthroughSubject<Song, Never>()
    public weak var coordinator: EditNoteViewControllerDelegate?

    public init(viewModel: EditNoteViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    public required init?(coder: NSCoder) {
        fatalError()
    }

    public override func loadView() {
        self.view = editNoteView
    }

    public override func viewDidLoad() {
        super.viewDidLoad()

        bind()
        setUpTextView()
        configure(viewModel.note)
    }

    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        setupLyricsTextviewTextCenterVertically(lyricsTextView)
    }

    public override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        updateNoteSpacerView(text: noteTextView.text)
    }

    public func addSelectedSong(_ item: Song) {
        selectedSongPublisher.send(item)
    }

    private func bind() {
        noteCharCountContainerView.tapPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.noteTextView.becomeFirstResponder()
            }
            .store(in: &cancellables)

        rootScrollView.tapPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.lyricsTextView.resignFirstResponder()
                self?.noteTextView.resignFirstResponder()
            }
            .store(in: &cancellables)

        closeButton.publisher(for: .touchUpInside)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.coordinator?.dismissViewController()
            }
            .store(in: &cancellables)

        selectedSongPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] song in
                self?.editNoteView.configure(song)
                self?.editNoteView.flex.layout()
            }
            .store(in: &cancellables)

        searchLyricsButton.tapPublisher
            .receive(on: DispatchQueue.main)
            .sink { _ in
                self.searchSongWebViewController.modalPresentationStyle = .overFullScreen
                self.present(self.searchSongWebViewController, animated: false)
            }
            .store(in: &cancellables)

        let lyricsTextViewTypePublisher = lyricsTextView.textPublisher(for: [.didBeginEditing, .didChange])
            .compactMap { [weak self] _ in self?.lyricsTextView.text }
            .prepend(viewModel.note.lyrics?.content ?? "")
            .eraseToAnyPublisher()

        let lyricsBackgroundSelectPublisher = lyricsBackgroundViewController.backgroundPublisher.prepend(viewModel.note.lyrics?.background).eraseToAnyPublisher()

        selectLyricsBackgroundButton.tapPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                guard let self = self else { return }
                self.lyricsBackgroundViewController.modalPresentationStyle = .overFullScreen
                self.present(self.lyricsBackgroundViewController, animated: false)
            }
            .store(in: &cancellables)

        let noteTextViewTypePublisher = noteTextView.textPublisher(for: [.didBeginEditing, .didChange])
            .compactMap { [weak self] _ in self?.noteTextView.text }
            .prepend(viewModel.note.content)
            .eraseToAnyPublisher()

        let completeButtonTapPublisher = completeButton.publisher(for: .touchUpInside)
            .eraseToAnyPublisher()

        let editNoteStatusPublisher = Just(viewModel.note.status)
            .eraseToAnyPublisher()

        let input = EditNoteViewModel.Input(
            lyricsTextViewTypePublisher: lyricsTextViewTypePublisher,
            lyricsBackgroundSelectPublisher: lyricsBackgroundSelectPublisher,
            noteTextViewTypePublisher: noteTextViewTypePublisher,
            completeButtonTapPublisher: completeButtonTapPublisher,
            editNoteStatusPublisher: editNoteStatusPublisher
        )

        let output = viewModel.transform(input: input)

        // 완료 버튼 활성화 상태 바인딩
        output.isEnabledCompleteButton
            .assign(to: \.isEnabled, on: completeButton)
            .store(in: &cancellables)

        output.isEnabledLyricsBackgroundButton
            .assign(to: \.isEnabled, on: selectLyricsBackgroundButton)
            .store(in: &cancellables)

        output.isSelectedLyricsBackground
            .receive(on: DispatchQueue.main)
            .sink { [weak self] background in
                let backgroundImage = background?.image ?? LyricsBackground.default.image
                self?.lyricsTextView.backgroundColor = UIColor(patternImage: backgroundImage)

                guard let text = self?.lyricsTextView.text, !text.isEmpty, text != Const.lyricsPlaceholder else { return }

                var textViewColor: UIColor

                switch background {
                case .red, .black:
                    textViewColor = Colors.fixedModal.resolvedColor(with: UITraitCollection(userInterfaceStyle: .light))
                default:
                    textViewColor = Colors.gray08.resolvedColor(with: UITraitCollection(userInterfaceStyle: .light))
                }
                let defaultCountLabelTextColor = Colors.gray06.resolvedColor(with: UITraitCollection(userInterfaceStyle: .light))

                self?.updateTextViewAndCountLabelTextColor(
                    text: text,
                    textViewTextColor: textViewColor,
                    labelTextColor: defaultCountLabelTextColor
                )
            }
            .store(in: &cancellables)

        output.editNoteResult
            .receive(on: DispatchQueue.main)
            .sink { [weak self] result in
                self?.lyricsTextView.resignFirstResponder()
                self?.noteTextView.resignFirstResponder()

                switch result {
                case .success:
                    self?.coordinator?.didFinishForPresentingViewController()
                case .failure(let error):
                    self?.showAlert(
                        title: "노트 수정에 실패했어요. \n\(error.localizedDescription)",
                        message: nil,
                        singleActionTitle: "확인"
                    )
                }
            }
            .store(in: &cancellables)

        CombineKeyboard.keyboardHeightPublisher
            .sink { [weak self] keyboardHeight in
                guard let self = self else { return }
                self.keyboardHeight = keyboardHeight

                if keyboardHeight > 0 {
                    let noSafeArea = safeAreaBottomInset == 0
                    let additionalBottomInset: CGFloat = noSafeArea ? 33 : 0

                    rootScrollView.contentInset.bottom = keyboardHeight + additionalBottomInset
                    rootScrollView.verticalScrollIndicatorInsets.bottom = noSafeArea ? keyboardHeight + additionalBottomInset : keyboardHeight
                } else {
                    rootScrollView.contentInset.bottom = 0
                    rootScrollView.verticalScrollIndicatorInsets.bottom = 0
                }
                updateNoteSpacerView(text: noteTextView.text)
            }
            .store(in: &cancellables)
    }

    private func setUpTextView() {
        noteTextView.textPublisher(for: [.didBeginEditing, .didEndEditing])
            .sink { [weak self] text in
                guard let self = self else { return }

                if text?.isEmpty == true {
                    noteTextView.setUpTextView(text: Const.notePlaceholder, textColor: Colors.gray04)
                    noteCharCountLabel.textColor = Colors.gray04
                    updateNoteSpacerView(text: Const.notePlaceholder)
                } else if text == Const.notePlaceholder {
                    noteTextView.setUpTextView(text: "", textColor: Colors.gray08)
                } else {
                    // 텍스트 작성 중 상태
                }
            }
            .store(in: &cancellables)

        noteTextView.textPublisher(for: [.didChange])
            .sink { [weak self] text in
                guard let self = self, let text = text else { return }

                self.noteTextView.flex.markDirty()

                // contentView 레이아웃 재배치
                contentView.flex.layout(mode: .adjustHeight)
                self.rootScrollView.contentSize = self.contentView.frame.size

                // 텍스트 뷰가 키보드에 의해 가려지는 경우를 방지하기 위해 스크롤 위치를 조정
                guard let end = self.noteTextView.selectedTextRange?.end else { return }
                let caretRect = self.noteTextView.caretRect(for: end)
                self.rootScrollView.scrollRectToVisible(caretRect, animated: true)

                self.updateCharacterCountForNote()
                self.updateNoteSpacerView(text: text)
            }
            .store(in: &cancellables)

        lyricsTextView.textPublisher(for: [.didBeginEditing, .didEndEditing])
            .receive(on: DispatchQueue.main)
            .sink { [weak self] text in
                guard let self = self else {
                    return
                }

                let background = lyricsBackgroundViewController.backgroundPublisher.value

                let defaultCountLabelTextColor = Colors.gray02.resolvedColor(with: UITraitCollection(userInterfaceStyle: .light))

                if text?.isEmpty == true {
                    let textViewColor = Colors.gray02.resolvedColor(with: UITraitCollection(userInterfaceStyle: .light))

                    updateTextViewAndCountLabelTextColor(
                        text: Const.lyricsPlaceholder,
                        textViewTextColor: textViewColor,
                        labelTextColor: defaultCountLabelTextColor
                    )
                } else if text == Const.lyricsPlaceholder {
                    var textViewColor: UIColor

                    switch background {
                    case .red, .black:
                        textViewColor = Colors.fixedModal.resolvedColor(with: UITraitCollection(userInterfaceStyle: .light))
                    default:
                        textViewColor = Colors.gray08.resolvedColor(with: UITraitCollection(userInterfaceStyle: .light))
                    }
                    let defaultCountLabelTextColor = Colors.gray06.resolvedColor(with: UITraitCollection(userInterfaceStyle: .light))
                    updateTextViewAndCountLabelTextColor(
                        text: "",
                        textViewTextColor: textViewColor,
                        labelTextColor: defaultCountLabelTextColor
                    )
                    setupLyricsTextviewTextCenterVertically(lyricsTextView)
                }
            }
            .store(in: &cancellables)

        lyricsTextView.textPublisher(for: [.didChange])
            .sink { [weak self] text in
                guard let self = self, let text = text else { return }

                let maxLineCount = 3
                let lines = text.components(separatedBy: .newlines)
                let numberOfLines = lines.count

                if (text.count == 0 || text.count < Const.lyricsMaxTextLength) && numberOfLines > maxLineCount {
                    let truncatedText = lines.dropLast().joined(separator: "\n")
                    lyricsTextView.text = truncatedText
                } else if text.count > Const.lyricsMaxTextLength {
                    lyricsTextView.text = String(text.prefix(Const.lyricsMaxTextLength))
                } else if lyricsTextView.isThirdLineExceedingWidth() {
                    lyricsTextView.text = String(text.dropLast(2))
                } else {
                    setupLyricsTextviewTextCenterVertically(lyricsTextView)
                    updateCharacterCountForLyrics()
                }
            }
            .store(in: &cancellables)

        setupLyricsTextviewTextCenterVertically(lyricsTextView)
    }

    private func updateCharacterCountForLyrics() {
        let count = lyricsTextView.text.count <= 50 ? lyricsTextView.text.count : 50
        lyricsCharCountLabel.text = "\(count)/\(Const.lyricsMaxTextLength)"
        lyricsCharCountLabel.textColor = Colors.gray06.resolvedColor(with: UITraitCollection(userInterfaceStyle: .light))
    }

    private func updateNoteSpacerView(text: String) {
        let lines = text.components(separatedBy: .newlines)
        let numberOfLines = lines.count
        let screenHeight = UIScreen.main.bounds.height
        let noSafeArea = safeAreaBottomInset == 0
        let ratio = noSafeArea ? 0.38 : 0.435
        let spacerHeight = (screenHeight * ratio) + 17

        let keyboardScreenRatio = keyboardHeight / screenHeight

        if numberOfLines == 1 {
            if text != Const.notePlaceholder {
                if keyboardHeight > 0 {
                    if keyboardScreenRatio >= 0.392 {
                        noteCharCountContainerView.flex.height(66).markDirty()
                    } else {
                        noteCharCountContainerView.flex.height(33).markDirty()
                    }
                } else {
                    noteCharCountContainerView.flex.height(spacerHeight).markDirty()
                }
            } else {
                noteCharCountContainerView.flex.height(spacerHeight).markDirty()
            }
        } else if numberOfLines == 2 {
            noteCharCountContainerView.flex.height(33.33).markDirty()
        } else if numberOfLines > 2 && keyboardHeight > 0 {
            noteCharCountContainerView.flex.height(24).markDirty()
        } else if numberOfLines > 2 {
            noteCharCountContainerView.flex.height(spacerHeight - ((CGFloat(numberOfLines) * 33.33) * ratio) + 17).markDirty()
        }

        contentView.flex.layout(mode: .adjustHeight)
        rootScrollView.contentSize = contentView.frame.size
    }

    private func updateCharacterCountForNote() {
        let count = noteTextView.text.count <= 1000 ? noteTextView.text.count : 1000
        noteCharCountLabel.text = "\(count)/\(Const.noteMaxTextLength)"
        noteCharCountLabel.textColor = Colors.gray06
    }

    private func updateTextViewAndCountLabelTextColor(
        text: String,
        textViewTextColor: UIColor,
        labelTextColor: UIColor
    ) {
        lyricsTextView.setUpTextView(text: text, textColor: textViewTextColor)
        lyricsCharCountLabel.textColor = labelTextColor
    }

    private func configure(_ model: Note) {
        guard let lyricsBackground = model.lyrics?.background,
              let lyricsContent = model.lyrics?.content
        else { return }

        selectedSongPublisher.send(model.song)
        lyricsTextView.setUpTextView(text: lyricsContent, textColor: Colors.gray08)
        lyricsBackgroundViewController.backgroundPublisher.send(lyricsBackground)
        noteTextView.setUpTextView(text: model.content, textColor: Colors.gray08)
        searchLyricsButton.isEnabled = true
        
        updateCharacterCountForLyrics()
        updateCharacterCountForNote()
    }

    private func setupLyricsTextviewTextCenterVertically(_ textView: UITextView) {
        let textSize = textView.sizeThatFits(CGSize(width: textView.frame.width, height: CGFloat.greatestFiniteMagnitude))
        let topCorrection = (textView.frame.size.height - textSize.height * textView.zoomScale) / 2.0
        let topInset = max(0, topCorrection)

        let lineCount = textView.numberOfLine()

        if lineCount <= 1 || textView.text.isEmpty {
            textView.textContainerInset = UIEdgeInsets(
                top: 56,
                left: 52,
                bottom: 0,
                right: 52
            )
        } else {
            textView.textContainerInset = UIEdgeInsets(
                top: topInset + 30,
                left: 52,
                bottom: 0,
                right: 52
            )
        }
    }
}

extension EditNoteViewController {
    var rootFlexContainer: UIView {
        return editNoteView.rootFlexContainer
    }

    var rootScrollView: UIScrollView {
        return editNoteView.rootScrollView
    }

    var contentView: UIView {
        return editNoteView.contentView
    }

    var lyricsTextView: UITextView {
        return editNoteView.lyricsTextView
    }

    var lyricsCharCountLabel: UILabel {
        return editNoteView.lyricsCharCountLabel
    }

    var selectLyricsBackgroundButton: PostSelectButton {
        return editNoteView.selectLyricsBackgroundButton
    }

    var searchLyricsButton: PostSelectButton {
        return editNoteView.searchLyricsButton
    }

    var noteTextView: UITextView {
        return editNoteView.noteTextView
    }

    var noteCharCountContainerView: UIView {
        return editNoteView.noteCharCountContainerView
    }

    var noteCharCountLabel: UILabel {
        return editNoteView.noteCharCountLabel
    }

    var closeButton: UIButton {
        return editNoteView.closeButton
    }

    var completeButton: FeelinConfirmButton {
        return editNoteView.completeButton
    }
}
