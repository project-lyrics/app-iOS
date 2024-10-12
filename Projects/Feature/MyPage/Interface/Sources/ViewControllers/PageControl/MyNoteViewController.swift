//
//  MyNoteViewController.swift
//  FeatureMyPageInterface
//
//  Created by Derrick kim on 10/1/24.
//

import Combine
import UIKit

import Domain
import Shared

import FeatureHomeInterface

public protocol MyNoteViewControllerDelegate: AnyObject {
    func pushReportViewController(noteID: Int?, commentID: Int?)
    func presentEditNoteViewController(note: Note)
    func popViewController()
    func pushNoteCommentsViewController(noteID: Int)
    func didFinish()
}

public final class MyNoteViewController: UIViewController,
                                         IndicatorInfoProvider,
                                         NoteMenuHandling,
                                         NoteMusicHandling {
    public weak var coordinator: MyNoteViewControllerDelegate?

    // MARK: - Keychain

    @KeychainWrapper<UserInformation>(.userInfo)
    public var userInfo

    // MARK: - NoteMenu Subjects

    public let onReportNote: PassthroughSubject<Int, Never> = .init()
    public let onEditNote: PassthroughSubject<Note, Never> = .init()
    public let onDeleteNote: PassthroughSubject<Int, Never> = .init()

    // MARK: - Diffable DataSource

    private enum Section {
        case artistCategory
        case notes
    }

    private enum Row: Hashable {
        case artistCategory(FavoriteArtistHavingNote)
        case note(Note)
        case emptyNote
        case requiredLogin
    }

    private typealias MyNoteDataSource = UICollectionViewDiffableDataSource<Section, Row>
    private typealias MyNoteSnapshot = NSDiffableDataSourceSnapshot<Section, Row>
    private lazy var noteDetailDataSource: MyNoteDataSource = createDataSource()

    private let contentView = MyNoteContentView()

    private var cancellables = Set<AnyCancellable>()
    private let viewModel: MyNoteViewModel

    public init(viewModel: MyNoteViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError()
    }

    public override func loadView() {
        self.view = contentView
    }

    public override func viewDidLoad() {
        super.viewDidLoad()

        setUpDefault()
        viewModel.getFavoriteArtists()
        bindUI()
        bindData()
        bindAction()
    }

    public func indicatorInfo(for pagerTabStripController: FeelinPagerTabViewController) -> IndicatorInfo {
        return IndicatorInfo(title: "작성글")
    }

    private func setUpDefault() {
        view.backgroundColor = Colors.background
    }

    private func bindUI() {
        viewModel.$error
            .compactMap { $0 }
            .sink { [weak self] error in
                self?.showAlert(
                    title: error.errorDescription,
                    message: nil,
                    singleActionTitle: "확인"
                )
            }
            .store(in: &cancellables)
    }

    func bindAction() {
        onReportNote.eraseToAnyPublisher()
            .sink { [weak self] noteID in
                self?.coordinator?.pushReportViewController(noteID: noteID, commentID: nil)
            }
            .store(in: &cancellables)

        onEditNote.eraseToAnyPublisher()
            .sink { [weak self] note in
                self?.coordinator?.presentEditNoteViewController(note: note)
            }
            .store(in: &cancellables)

        onDeleteNote.eraseToAnyPublisher()
            .sink { [weak self] noteID in
                self?.showAlert(
                    title: "노트를 삭제하시겠어요?",
                    message: nil,
                    rightActionCompletion: {
                        self?.viewModel.deleteNote(id: noteID)
                    })
            }
            .store(in: &cancellables)

        noteDetailCollectionView.didScrollToBottomPublisher()
            .sink { [weak viewModel] in
                viewModel?.getMyNotes(isInitialFetch: false)
            }
            .store(in: &cancellables)

        noteDetailCollectionView.publisher(for: [.didSelectItem])
            .sink { [weak self] indexPath in
                guard let self = self else { return }

                // 해당 indexPath에 맞는 item을 dataSource에서 가져옴
                guard let item = self.noteDetailDataSource.itemIdentifier(for: indexPath) else { return }

                switch item {
                case .artistCategory(let note):
                    let artistID = note.artist.name == "전체보기" ? nil : note.artist.id
                    viewModel.getMyNotes(isInitialFetch: true, artistID: artistID)

                case .note(let note):
                    coordinator?.pushNoteCommentsViewController(noteID: note.id)

                case .emptyNote:
                    break

                case .requiredLogin:
                    break
                }
            }
            .store(in: &cancellables)
    }

    func bindData() {
        self.viewModel.$fetchedFavoriteArtistNotes
            .sink { [weak self] fetchedFavoriteArtistNotes in
                self?.updateFavoriteArtistHavingNoteSnapshot(notes: fetchedFavoriteArtistNotes)
            }
            .store(in: &cancellables)

        self.viewModel.$fetchedNotes
            .sink { [weak self] fetchedNotes in
                self?.updateNoteSnapshot(notes: fetchedNotes)
            }
            .store(in: &cancellables)
    }

    private func createDataSource() -> MyNoteDataSource {
        let dataSource = MyNoteDataSource(collectionView: self.noteDetailCollectionView) { [weak self] collectionView, indexPath, item in
            guard let self = self else { return nil }

            switch item {
            case .artistCategory(let favoriteArtistNote):
                let cell: ArtistNameCollectionViewCell = collectionView.dequeueReusableCell(for: indexPath)
                cell.configure(model: favoriteArtistNote.artist)

                return cell
            case .note(let note):
                let cell: NoteCell = collectionView.dequeueReusableCell(for: indexPath)
                cell.configure(with: note)

                cell.likeNoteButton.publisher(for: .touchUpInside)
                // 0.6초 사이에 발생한 가장 최신 좋아요 상태만 방출
                    .debounce(
                        for: .milliseconds(600),
                        scheduler: DispatchQueue.main
                    )
                    .sink { control in
                        self.viewModel.setNoteLikeState(
                            noteID: note.id,
                            isLiked: control.isSelected
                        )
                    }
                    .store(in: &self.cancellables)

                cell.bookmarkButton.publisher(for: .touchUpInside)
                    .debounce(
                        for: .milliseconds(600),
                        scheduler: DispatchQueue.main
                    )
                    .sink { control in
                        self.viewModel.setNoteBookmarkState(
                            noteID: note.id,
                            isBookmarked: control.isSelected
                        )
                    }
                    .store(in: &self.cancellables)

                cell.moreAboutContentButton.publisher(for: .touchUpInside)
                    .sink { [weak self] _ in
                        if let noteMenuViewController = self?.makeNoteMenuViewController(checking: note) {
                            self?.present(noteMenuViewController, animated: false)
                        } else {
                            // TODO: - 비회원 알림을 추후 보여줘야 한다.
                        }
                    }
                    .store(in: &self.cancellables)

                cell.playMusicButton.publisher(for: .touchUpInside)
                    .throttle(
                        for: .milliseconds(600),
                        scheduler: DispatchQueue.main,
                        latest: false
                    )
                    .sink { [weak self] _ in
                        self?.openYouTube(query: "\(note.song.artist.name) \(note.song.name)")
                    }
                    .store(in: &self.cancellables)

                return cell

            case .emptyNote:
                let cell = collectionView.dequeueReusableCell(
                    for: indexPath,
                    cellType: EmptyMyNoteCell.self
                )

                return cell

            case .requiredLogin:
                let cell = collectionView.dequeueReusableCell(
                    for: indexPath,
                    cellType: RequiredLoginNoteCell.self
                )

                cell.loginButton.publisher(for: .touchUpInside)
                    .sink { [weak self] _ in
                        self?.coordinator?.didFinish()
                    }
                    .store(in: &self.cancellables)

                return cell
            }
        }
        return dataSource
    }

    private func updateArtistNameSnapshot(notes: [Note]) {
        var snapshot = noteDetailDataSource.snapshot()

        // 섹션이 없을 경우 추가
        if !snapshot.sectionIdentifiers.contains(.notes) {
            snapshot.appendSections([.notes])
        }

        // 기존 섹션의 아이템을 가져오기
        let currentItems = snapshot.itemIdentifiers(inSection: .notes)
        let noteRows = notes.map { Row.note($0) }

        // 새로운 데이터와 기존 데이터를 비교하여 다른 경우에만 업데이트
        if currentItems != noteRows {
            // 기존 아이템 삭제
            snapshot.deleteItems(currentItems)

            // 새로운 데이터 추가
            snapshot.appendItems(noteRows, toSection: .notes)

            // 스냅샷을 적용
            noteDetailDataSource.apply(snapshot, animatingDifferences: true)
        } else {
            // 그 외에는 cell 갯수는 변화가 없으나 컨텐츠에 변화가 있다고 판단. reloadData 수행
            noteDetailDataSource.applySnapshotUsingReloadData(snapshot)
        }
    }

    private func updateNoteSnapshot(notes: [Note]) {
        // TODO: - 정상작동 X, 수정 필요 p1

        var snapshot = noteDetailDataSource.snapshot()

        // notes 섹션이 있는 경우
        if snapshot.sectionIdentifiers.contains(.notes) {
            let currentItems = snapshot.itemIdentifiers(inSection: .notes)

            if notes.isEmpty {
                if userInfo?.userID == nil {
                    snapshot.deleteItems(currentItems)
                    snapshot.appendItems([.requiredLogin], toSection: .notes)
                } else if !currentItems.contains(.emptyNote) {
                    // notes가 비어있으면 Row.emptyNote 추가
                    snapshot.deleteItems(currentItems)
                    snapshot.appendItems([.emptyNote], toSection: .notes)
                }
            } else {
                // notes가 1개 이상이면 Row.emptyNote를 삭제하고 notes를 추가
                let newNoteItems = notes.map { Row.note($0) }

                if currentItems.contains(.emptyNote) {
                    snapshot.deleteItems([.emptyNote])
                }

                // 기존 노트 항목과 새로운 항목이 다를 경우 업데이트
                if currentItems != newNoteItems {
                    snapshot.deleteItems(currentItems)
                    snapshot.appendItems(newNoteItems, toSection: .notes)
                }
            }

            // 애니메이션 적용 여부: 항목 개수가 바뀌었을 때만 애니메이션 적용
            let itemCountChanged = notes.count != currentItems.count
            noteDetailDataSource.apply(snapshot, animatingDifferences: itemCountChanged)

        } else {
            // notes 섹션이 처음 추가될 때
            snapshot.appendSections([.notes])
            if notes.isEmpty {
                if userInfo?.userID == nil {
                    snapshot.appendItems([.requiredLogin], toSection: .notes)
                } else {
                    // notes가 비어있으면 Row.emptyNote 추가
                    snapshot.appendItems([.emptyNote], toSection: .notes)
                }
            } else {
                // notes가 있으면 Row.note 추가
                snapshot.appendItems(notes.map { Row.note($0) }, toSection: .notes)
            }

            noteDetailDataSource.apply(snapshot, animatingDifferences: false)
        }
    }

    private func updateFavoriteArtistHavingNoteSnapshot(notes: [FavoriteArtistHavingNote]) {
        var snapshot = noteDetailDataSource.snapshot()

        if !snapshot.sectionIdentifiers.contains(.artistCategory) {
            snapshot.appendSections([.artistCategory])
        }

        let currentItems = snapshot.itemIdentifiers(inSection: .artistCategory)
        let noteRows = notes.map { Row.artistCategory($0) }

        // 새로운 데이터와 기존 데이터를 비교하여 다른 경우에만 업데이트
        if currentItems != noteRows {
            // 기존 아이템 삭제
            snapshot.deleteItems(currentItems)

            // 새로운 데이터 추가
            snapshot.appendItems(noteRows, toSection: .artistCategory)

            // 스냅샷을 적용
            noteDetailDataSource.apply(snapshot, animatingDifferences: true) { [weak self] in
                // 스냅샷 적용 후 첫 번째 아이템을 자동으로 선택
                guard let self = self, let firstItem = noteRows.first else { return }

                let firstIndexPath = IndexPath(item: 0, section: 0)
                self.noteDetailCollectionView.selectItem(at: firstIndexPath, animated: false, scrollPosition: .top)
                viewModel.getMyNotes(isInitialFetch: true)
            }
        } else {
            // 그 외에는 cell 갯수는 변화가 없으나 컨텐츠에 변화가 있다고 판단. reloadData 수행
            noteDetailDataSource.applySnapshotUsingReloadData(snapshot)
        }
    }
}

private extension MyNoteViewController {
    var noteDetailCollectionView: UICollectionView {
        return contentView.noteDetailCollectionView
    }
}
