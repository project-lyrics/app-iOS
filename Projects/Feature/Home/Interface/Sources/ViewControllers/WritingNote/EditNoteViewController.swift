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
    func handleError(
        errorCode: String?,
        errorMessage: String,
        errorData: AnyType?
    )
}

public final class EditNoteViewController: UIViewController {
    enum Const {
        static let noteMaxTextLength = 1000
        static let lyricsMaxTextLength = 50
        static let maxTextViewHeight: CGFloat = 132
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

        editNoteView.naviTitleLabel.text = "노트 수정"
        setUpDefault()
        bind()
        setUpTextView()
        configure(viewModel.note)
    }

    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

    }

    public override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        updateNoteSpacerView()
    }

    public func addSelectedSong(_ item: Song) {
        selectedSongPublisher.send(item)
    }
    
    private func setUpDefault() {
        self.lyricsTextPlaceholder.isHidden = self.viewModel.note.lyrics?.content.isNotEmpty ?? false
        self.noteTextPlaceholder.isHidden = self.viewModel.note.content.isNotEmpty
        self.setupLyricsTextviewTextCenterVertically(lyricsTextView)
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
            .map { text -> String in return text ?? "" }
            .prepend(viewModel.note.lyrics?.content ?? "")
            .eraseToAnyPublisher()

        let lyricsBackgroundSelectPublisher = lyricsBackgroundViewController.backgroundImageSubject.prepend(viewModel.note.lyrics?.background).eraseToAnyPublisher()

        selectLyricsBackgroundButton.tapPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                guard let self = self else { return }
                self.lyricsBackgroundViewController.modalPresentationStyle = .overFullScreen
                self.present(self.lyricsBackgroundViewController, animated: false)
            }
            .store(in: &cancellables)

        let noteTextViewTypePublisher = noteTextView.textPublisher(for: [.didBeginEditing, .didChange])
            .map { $0 ?? "" }
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

                guard let text = self?.lyricsTextView.text, !text.isEmpty else { return }

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
                    self?.coordinator?.dismissViewController()

                case .failure(let error):
                    self?.coordinator?.handleError(
                        errorCode: error.errorCode,
                        errorMessage: error.userMessage,
                        errorData: error.data
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
                updateNoteSpacerView()
            }
            .store(in: &cancellables)
    }

    private func setUpTextView() {
        noteTextView.textPublisher(for: [.didBeginEditing])
            .sink { [weak self] text in
                guard let text = text else {
                    self?.updateNoteSpacerView()
                    return
                }
                self?.noteTextPlaceholder.isHidden = true
                if text.isEmpty {
                    self?.updateNoteSpacerView()
                }
            }
            .store(in: &cancellables)
        
        noteTextView.textPublisher(for: [.didEndEditing])
            .sink { [weak self] text in
                guard let text = text else {
                    self?.updateNoteSpacerView()
                    return
                }
                self?.noteTextPlaceholder.isHidden = !text.isEmpty
                if text.isEmpty {
                    self?.updateNoteSpacerView()
                }
            }
            .store(in: &cancellables)

        noteTextView.textPublisher(for: [.didChange])
            .sink { [weak self] text in
                guard let self = self, let text = text else { return }
                
                self.noteTextPlaceholder.isHidden = true

                self.noteTextView.flex.markDirty()

                // contentView 레이아웃 재배치
                self.contentView.flex.layout(mode: .adjustHeight)
                self.rootScrollView.contentSize = self.contentView.frame.size

                // 텍스트 뷰가 키보드에 의해 가려지는 경우를 방지하기 위해 스크롤 위치를 조정
                guard let end = noteTextView.selectedTextRange?.end else { return }
                let caretRect = noteTextView.caretRect(for: end)
                rootScrollView.scrollRectToVisible(caretRect, animated: true)

                if text.count > Const.noteMaxTextLength {
                    noteTextView.text = String(text.prefix(Const.noteMaxTextLength))
                } else {
                    updateCharacterCountForNote()
                    updateNoteSpacerView()
                }
            }
            .store(in: &cancellables)

        lyricsTextView.textPublisher(for: [.didBeginEditing])
            .combineLatest(lyricsBackgroundViewController.backgroundImageSubject)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] (text, background) in
                guard let self = self else {
                    return
                }
                
                lyricsTextPlaceholder.isHidden = true
                var textViewColor: UIColor
                
                switch background {
                case .red, .black:
                    textViewColor = Colors.fixedModal.resolvedColor(with: UITraitCollection(userInterfaceStyle: .light))
                default:
                    textViewColor = Colors.gray08.resolvedColor(with: UITraitCollection(userInterfaceStyle: .light))
                }
                
                lyricsTextView.textColor = textViewColor
            }
            .store(in: &cancellables)
        
        lyricsTextView.textPublisher(for: [.didEndEditing])
            .receive(on: DispatchQueue.main)
            .sink { [weak self] text in
                guard let text = text else { return }
                self?.lyricsTextPlaceholder.isHidden = !text.isEmpty
            }
            .store(in: &cancellables)

        lyricsTextView.textPublisher(for: [.didChange])
            .receive(on: DispatchQueue.main)
            .sink { [weak self] text in
                guard let self = self,
                      let text = text,
                      searchLyricsButton.isEnabled else {
                    self?.lyricsTextPlaceholder.isHidden = false
                    self?.lyricsTextView.resignFirstResponder()
                    return
                }
                
                // 만약 가사값이 비어있는 경우 lyricsBackgroundImage .default세팅
                if text.isEmpty {
                    self.lyricsBackgroundViewController.backgroundImageSubject.send(.default)
                }
                
                let maxLineCount = 3
                let lines = text.components(separatedBy: .newlines)
                let numberOfLines = lines.count
                
                if (text.count == 0 || text.count < Const.lyricsMaxTextLength) && numberOfLines > maxLineCount {
                    let truncatedText = lines.dropLast().joined(separator: "\n")
                    lyricsTextView.text = truncatedText
                    updateCharacterCountForLyrics()
                    
                } else if text.count > Const.lyricsMaxTextLength {
                    lyricsTextView.text = String(text.prefix(Const.lyricsMaxTextLength))
                    
                } else if lyricsTextView.isThirdLineExceedingWidth() {
                    lyricsTextView.text = String(text.dropLast(2))
                    
                } else {
                    updateCharacterCountForLyrics()
                }
                
                setupLyricsTextviewTextCenterVertically(lyricsTextView)
            }
            .store(in: &cancellables)
        
        setupLyricsTextviewTextCenterVertically(lyricsTextView)
    }

    private func updateCharacterCountForLyrics() {
        let count = lyricsTextView.text.count <= 50 ? lyricsTextView.text.count : 50
        lyricsCharCountLabel.text = "\(count)/\(Const.lyricsMaxTextLength)"
        if count < 1 {
            lyricsCharCountLabel.textColor = Colors.gray04
        } else {
            lyricsCharCountLabel.textColor = Colors.gray08.resolvedColor(with: UITraitCollection(userInterfaceStyle: .light))
        }
    }

    private func updateNoteSpacerView() {
        let screenHeight = UIScreen.main.bounds.height

        let requiredHeight = editNoteView.calculateNoteCharCountContainerHeight(
            screenHeight: screenHeight,
            keyboardHeight: keyboardHeight
        )
        noteCharCountContainerView.flex.height(requiredHeight).markDirty()
        contentView.flex.layout(mode: .adjustHeight)
        contentView.layoutIfNeeded()

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
        selectedSongPublisher.send(model.song)
        if let lyrics = model.lyrics {
            lyricsTextView.setUpTextView(
                text: lyrics.content,
                textColor: Colors.gray08
            )
            
            lyricsBackgroundViewController.backgroundImageSubject.send(lyrics.background)
        }
        noteTextView.setUpTextView(text: model.content, textColor: Colors.gray08)
        searchLyricsButton.isEnabled = true
        
        updateCharacterCountForLyrics()
        updateCharacterCountForNote()
    }

    private func setupLyricsTextviewTextCenterVertically(_ textView: UITextView) {
        let defaultInsets = UIEdgeInsets(
            top: 56,
            left: 52,
            bottom: 0,
            right: 52
        )
        
        guard !textView.text.isEmpty,
              textView.numberOfLine() > 1 else {
            textView.textContainerInset = defaultInsets
            return
        }
        
        let multilineInsets = UIEdgeInsets(
            top: 30,
            left: 52,
            bottom: 0,
            right: 52
        )
        
        textView.textContainerInset = multilineInsets
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
    
    var lyricsTextPlaceholder: UILabel {
        return editNoteView.lyricsTextPlaceholder
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
    
    var noteTextPlaceholder: UILabel {
        return editNoteView.noteTextPlaceholder
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
