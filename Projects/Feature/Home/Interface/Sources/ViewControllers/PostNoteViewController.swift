//
//  PostNoteViewController.swift
//  FeatureHomeInterface
//
//  Created by Derrick kim on 8/7/24.
//

import Combine
import UIKit
import Shared
import Domain

public protocol PostNoteViewControllerDelegate: AnyObject {
    func dismissViewController()
    func pushSearchSongViewController(artistID: Int)
}

public final class PostNoteViewController: UIViewController {
    enum Const {
        static let noteMaxTextLength = 1000
        static let lyricsMaxTextLength = 50
        static let maxTextViewHeight: CGFloat = 132
        static let lyricsPlaceholder = "좋아하는 가사를 적어주세요 (선택)"
        static let notePlaceholder = "생각을 남겨보세요."
    }

    private let lyricsBackgroundViewController = LyricsBackgroundViewController(
        bottomSheetHeight: UIScreen.main.bounds.height * 0.77
    )
    private let searchSongWebViewController = SearchSongWebViewController(
        bottomSheetHeight: UIScreen.main.bounds.height * 0.88
    )

    private let postNoteView = WritingNoteView()
    private var cancellables = Set<AnyCancellable>()
    private let viewModel: PostNoteViewModel

    private let selectedSongPublisher = PassthroughSubject<Song, Never>()
    public weak var coordinator: PostNoteViewControllerDelegate?
    
    public init(viewModel: PostNoteViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
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
        bind()
        setUpTextView()
    }

    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        setupLyricsTextviewTextCenterVertically(lyricsTextView)
    }

    public func addSelectedSong(_ item: Song) {
        selectedSongPublisher.send(item)
    }

    private func setUpDefaults() {
        noteTextView.delegate = self
        lyricsTextView.delegate = self
    }

    private func bind() {
        addToPlayButton.publisher(for: .touchUpInside)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                guard let self = self else { return }
                coordinator?.pushSearchSongViewController(artistID: viewModel.artistID)
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
                self?.postNoteView.configure(song)
                self?.postNoteView.flex.layout()
            }
            .store(in: &cancellables)

        searchLyricsButton.tapPublisher
            .receive(on: DispatchQueue.main)
            .flatMap { [weak self] _ -> AnyPublisher<Void, Never> in
                guard let self = self else { return Empty().eraseToAnyPublisher() }

                if !self.searchLyricsButton.isEnabled {
                    self.showAlert(title: "곡을 추가한 후,\n가사를 검색할 수 있어요.", message: nil, singleActionTitle: "확인")
                    return Empty().eraseToAnyPublisher()
                }

                return Just(()).eraseToAnyPublisher()
            }
            .sink { _ in
                self.searchSongWebViewController.modalPresentationStyle = .overFullScreen
                self.present(self.searchSongWebViewController, animated: false)
            }
            .store(in: &cancellables)

        let lyricsTextViewTypePublisher = lyricsTextView.textPublisher(for: [ .didChange])
            .map { [weak self] _ in self?.lyricsTextView.text }
            .prepend(nil)
            .eraseToAnyPublisher()

        let lyricsBackgroundSelectPublisher = lyricsBackgroundViewController.backgroundPublisher.eraseToAnyPublisher()

        selectLyricsBackgroundButton.tapPublisher
            .receive(on: DispatchQueue.main)
            .flatMap { [weak self] _ -> AnyPublisher<Void, Never> in
                guard let self = self else { return Empty().eraseToAnyPublisher() }

                if !self.selectLyricsBackgroundButton.isEnabled {
                    self.showAlert(
                        title: "곡을 추가한 후,\n가사배경을 추가할 수 있어요.",
                        message: nil,
                        singleActionTitle: "확인"
                    )
                    return Empty().eraseToAnyPublisher()
                }

                return Just(()).eraseToAnyPublisher()
            }
            .sink { [weak self] _ in
                guard let self = self else { return }
                self.lyricsBackgroundViewController.modalPresentationStyle = .overFullScreen
                self.present(self.lyricsBackgroundViewController, animated: false)
            }
            .store(in: &cancellables)

        let noteTextViewTypePublisher = noteTextView.textPublisher(for: [.didChange])
            .compactMap { [weak self] _ in self?.noteTextView.text }
            .eraseToAnyPublisher()

        let completeButtonTapPublisher = completeButton.publisher(for: .touchUpInside)
            .eraseToAnyPublisher()

        let postNoteStatusPublisher = Just(NoteStatus.draft)
            .eraseToAnyPublisher()

        let input = PostNoteViewModel.Input(
            songTapPublisher: selectedSongPublisher.eraseToAnyPublisher(),
            lyricsTextViewTypePublisher: lyricsTextViewTypePublisher,
            lyricsBackgroundSelectPublisher: lyricsBackgroundSelectPublisher,
            noteTextViewTypePublisher: noteTextViewTypePublisher,
            completeButtonTapPublisher: completeButtonTapPublisher,
            postNoteStatusPublisher: postNoteStatusPublisher
        )

        let output = viewModel.transform(input: input)

        // 완료 버튼 활성화 상태 바인딩
        output.isEnabledCompleteButton
            .assign(to: \.isEnabled, on: completeButton)
            .store(in: &cancellables)

        output.isSelectedSong
            .assign(to: \.isEnabled, on: searchLyricsButton)
            .store(in: &cancellables)

        output.isEnabledLyricsBackgroundButton
            .assign(to: \.isEnabled, on: selectLyricsBackgroundButton)
            .store(in: &cancellables)

        output.isSelectedLyricsBackground
            .receive(on: DispatchQueue.main)
            .sink { [weak self] background in
                let backgroundImage = background?.image ?? LyricsBackground.default.image
                self?.lyricsTextView.backgroundColor = UIColor(patternImage: backgroundImage)
            }
            .store(in: &cancellables)

        output.postNoteResult
            .receive(on: DispatchQueue.main)
            .sink { [weak self] result in
                switch result {
                case .success:
                    self?.coordinator?.dismissViewController()
                case .failure(let error):
                    self?.showAlert(title: "노트 작성에 실패했어요. \n\(error.localizedDescription)", message: nil, singleActionTitle: "확인")
                }
            }
            .store(in: &cancellables)

        lyricsTextView.setAllowEditingPublisher(output.isSelectedSong)
    }

    private func setUpTextView() {
        noteTextView.textPublisher(for: [.didBeginEditing, .didEndEditing])
            .sink { [weak self] text in
                guard let self = self else { return }

                if text?.isEmpty == true {
                    noteTextView.setUpTextView(text: Const.notePlaceholder, textColor: Colors.gray04)
                } else if text == Const.notePlaceholder {
                    noteTextView.setUpTextView(text: "", textColor: Colors.gray08)
                } else {
                    // 텍스트 작성 중 상태
                }
            }
            .store(in: &cancellables)

        noteTextView.textPublisher(for: [.didChange])
            .sink { [weak self] text in
                guard let self = self else { return }

                // 텍스트가 변경될 때마다 FlexLayout을 사용해 높이를 재조정
                noteTextView.flex.markDirty()
                contentView.flex.layout(mode: .adjustHeight)

                // ScrollView의 contentSize를 업데이트하여 스크롤 가능하게 만듦
                rootScrollView.contentSize = contentView.frame.size

                // 텍스트 뷰가 키보드에 의해 가려지는 경우를 방지하기 위해 스크롤 위치를 조정
                guard let end = noteTextView.selectedTextRange?.end else { return }
                let caretRect = noteTextView.caretRect(for: end)
                rootScrollView.scrollRectToVisible(caretRect, animated: true)
                updateCharacterCountForNote()
            }
            .store(in: &cancellables)

        lyricsTextView.textPublisher(for: [.didBeginEditing, .didEndEditing])
            .sink { [weak self] text in
                guard let self = self else {
                    return
                }

                if text?.isEmpty == true {
                    lyricsTextView.setUpTextView(text: Const.lyricsPlaceholder, textColor: Colors.gray04)
                } else if text == Const.lyricsPlaceholder {
                    lyricsTextView.setUpTextView(text: "", textColor: Colors.gray08)
                    setupLyricsTextviewTextCenterVertically(lyricsTextView)
                }
            }
            .store(in: &cancellables)

        lyricsTextView.textPublisher(for: [.didChange])
            .sink { [weak self] text in
                guard let self = self else { return }

                setupLyricsTextviewTextCenterVertically(lyricsTextView)
                updateCharacterCountForLyrics()

                // 텍스트 길이 초과 방지
                if lyricsTextView.text.count > Const.lyricsMaxTextLength {
                    lyricsTextView.text = String(lyricsTextView.text.prefix(Const.lyricsMaxTextLength))
                }

                let contentHeight = lyricsTextView.contentSize.height
                lyricsTextView.isScrollEnabled = contentHeight > Const.maxTextViewHeight
            }
            .store(in: &cancellables)

        lyricsTextView.shouldBeginEditingPublisher
            .sink { [weak self] _ in
                if self?.searchLyricsButton.isEnabled == false {
                    self?.showAlert(
                        title: "곡을 추가한 후,\n가사를 작성하실 수 있어요.",
                        message: nil,
                        singleActionTitle: "확인",
                        actionCompletion: {
                            self?.lyricsTextView.resignFirstResponder()
                        }
                    )
                } else {
                    /// 가사 작성 가능
                }
            }
            .store(in: &cancellables)
    }

    private func updateCharacterCountForLyrics() {
        let count = lyricsTextView.text.count <= 50 ? lyricsTextView.text.count : 50
        lyricsCharCountLabel.text = "\(count)/\(Const.lyricsMaxTextLength)"
    }

    private func updateCharacterCountForNote() {
        let count = noteTextView.text.count <= 1000 ? noteTextView.text.count : 1000
        noteCharCountLabel.text = "\(count)/\(Const.noteMaxTextLength)"
    }
}

// MARK: - UITextViewDelegate

extension PostNoteViewController: UITextViewDelegate {
    public func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        let currentText = textView.text ?? ""
        let prospectiveText = (currentText as NSString).replacingCharacters(in: range, with: text)

        if textView == noteTextView {
            return prospectiveText.count <= Const.noteMaxTextLength
        } else { // lyrics TextView의 길이
            let maxLineCount = 3
            let numberOfLines = prospectiveText.components(separatedBy: .newlines).count
            let numberOfLineBreaks = currentText.components(separatedBy: "\n").count - 1

            if textView.text.count == 0 && numberOfLines > 2 {
                return false
            } else if prospectiveText.count > Const.lyricsMaxTextLength || numberOfLines > maxLineCount {
                return false
            } else if text == "\n" && numberOfLineBreaks > maxLineCount {
                return false
            }

            return true
        }
    }

    private func setupLyricsTextviewTextCenterVertically(_ textView: UITextView) {
        let textSize = textView.sizeThatFits(CGSize(width: textView.frame.width, height: CGFloat.greatestFiniteMagnitude))
        let topCorrection = (textView.frame.size.height - textSize.height * textView.zoomScale) / 2.0
        let topInset = max(0, topCorrection)

        let lineCount = lyricsTextView.numberOfLine()

        if lineCount <= 1 || lyricsTextView.text.isEmpty {
            textView.textContainerInset = UIEdgeInsets(
                top: 56,
                left: 20,
                bottom: 0,
                right: 20
            )
        } else {
            textView.textContainerInset = UIEdgeInsets(
                top: topInset + 30,
                left: 20,
                bottom: 0,
                right: 20
            )
        }
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

    var selectLyricsBackgroundButton: PostSelectButton {
        return postNoteView.selectLyricsBackgroundButton
    }

    var searchLyricsButton: PostSelectButton {
        return postNoteView.searchLyricsButton
    }

    var noteTextView: UITextView {
        return postNoteView.noteTextView
    }

    var noteCharCountLabel: UILabel {
        return postNoteView.noteCharCountLabel
    }

    var closeButton: UIButton {
        return postNoteView.closeButton
    }

    var completeButton: FeelinConfirmButton {
        return postNoteView.completeButton
    }
}
