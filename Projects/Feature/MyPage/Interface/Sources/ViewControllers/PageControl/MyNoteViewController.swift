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
    func presentErrorAlert(message: String)
    func presentDeleteNoteAlert(_ completionHandler: (() -> Void)?)
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

    enum Row: Hashable {
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
        bindUI()
        bindData()
        bindAction()
    }

    public func indicatorInfo(for pagerTabStripController: FeelinPagerTabViewController) -> IndicatorInfo {
        return IndicatorInfo(title: "작성글")
    }

    private func setUpDefault() {
        view.backgroundColor = Colors.background

        if userInfo != nil {
            viewModel.getFavoriteArtists()
        }
    }

    private func bindUI() {
        viewModel.$error
            .compactMap { $0 }
            .sink { [weak self] error in
                self?.coordinator?.presentErrorAlert(message: error.errorMessageWithCode)
            }
            .store(in: &cancellables)

        viewModel.$refreshState
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { [weak self] refreshState in
                switch refreshState {
                case .failed(let error):
                    self?.coordinator?.presentErrorAlert(message: error.errorMessageWithCode)

                case .completed:
                    self?.noteDetailCollectionView.refreshControl?.endRefreshing()

                default:
                    return
                }
            })
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
                self?.coordinator?.presentDeleteNoteAlert {
                    self?.viewModel.deleteNote(id: noteID)
                }
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

        noteDetailCollectionView.refreshControl?.isRefreshingPublisher
            .filter { $0 }
            .sink(receiveValue: { [weak viewModel] _ in
                viewModel?.getMyNotes(isInitialFetch: true)
            })
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
                self?.updateNotesUI(notes: fetchedNotes)
            }
            .store(in: &cancellables)
    }

    private func createDataSource() -> MyNoteDataSource {
        let emptyNoteCellRegistration = UICollectionView.CellRegistration<EmptyNoteCell, Void> { cell, indexPath, item in }

        let requiredLoginCellRegistration = UICollectionView.CellRegistration<RequiredLoginNoteCell, Void> { cell, indexPath, item in

            cell.loginButton.publisher(for: .touchUpInside)
                .sink { [weak self] _ in
                    self?.coordinator?.didFinish()
                }
                .store(in: &cell.cancellables)
        }

        let artistCategoryCellRegistration = UICollectionView.CellRegistration<ArtistNameCollectionViewCell, FavoriteArtistHavingNote> { cell, indexPath, note in
            cell.configure(model: note.artist)
        }

        let noteCellRegistration = UICollectionView.CellRegistration<NoteCell, Note> { [weak self] cell, indexPath, note in

            cell.configure(with: note)

            cell.likeNoteButton.publisher(for: .touchUpInside)
                .sink { control in
                    self?.viewModel.setNoteLikeState(
                        noteID: note.id,
                        isLiked: control.isSelected
                    )
                }
                .store(in: &cell.cancellables)
            
            cell.commentButton.publisher(for: .touchUpInside)
                .sink { [weak self] _ in
                    self?.coordinator?.pushNoteCommentsViewController(noteID: note.id)
                }
                .store(in: &cell.cancellables)

            cell.bookmarkButton.publisher(for: .touchUpInside)
                .sink { control in
                    self?.viewModel.setNoteBookmarkState(
                        noteID: note.id,
                        isBookmarked: control.isSelected
                    )
                }
                .store(in: &cell.cancellables)

            cell.moreAboutContentButton.publisher(for: .touchUpInside)
                .sink { [unowned self] _ in
                    if let noteMenuViewController = self?.makeNoteMenuViewController(checking: note) {
                        self?.present(noteMenuViewController, animated: false)
                    } else {
                        // TODO: - 비회원 알림을 추후 보여줘야 한다.
                    }
                }
                .store(in: &cell.cancellables)

            cell.playMusicButton.publisher(for: .touchUpInside)
                .throttle(
                    for: .milliseconds(600),
                    scheduler: DispatchQueue.main,
                    latest: false
                )
                .sink { _ in
                    self?.openYouTube(query: "\(note.song.artist.name) \(note.song.name)")
                }
                .store(in: &cell.cancellables)
        }


        let dataSource = MyNoteDataSource(collectionView: self.noteDetailCollectionView) {
            collectionView, indexPath, item in
            return item.dequeueConfiguredReusableCell(
                collectionView: collectionView,
                emptyNoteCellRegistration: emptyNoteCellRegistration,
                noteCellRegistration: noteCellRegistration,
                artistCategoryCellRegistration: artistCategoryCellRegistration,
                requiredLoginCellRegistration: requiredLoginCellRegistration,
                indexPath: indexPath
            )
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

    private func updateNotesUI(notes: [Note]) {
        var snapshot = noteDetailDataSource.snapshot()

        let newItems = notes.map { Row.note($0) }

        // 노트 섹션 업데이트
        if snapshot.sectionIdentifiers.contains(.notes) {
            let currentItems = snapshot.itemIdentifiers(inSection: .notes)

            if newItems.isEmpty {
                snapshot.deleteItems(currentItems)
                snapshot.appendItems([.emptyNote], toSection: .notes)
            } else {
                snapshot.deleteItems(currentItems)
                snapshot.appendItems(newItems, toSection: .notes)
            }

            let isCountDifferent = currentItems.count != newItems.count

            guard let refreshControl = self.noteDetailCollectionView.refreshControl else {
                // pull-to-refresh가 없는 경우 apply snapshot만 적용. 갯수가 달라질때만 animation
                noteDetailDataSource.apply(
                    snapshot,
                    animatingDifferences: isCountDifferent
                )
                return
            }
            // pull-to-refresh 중일 경우 reloadData를 활용하여 apply snapshot에 의해서 생기는 bounce 방지
            if refreshControl.isRefreshing {
                noteDetailDataSource.applySnapshotUsingReloadData(snapshot)
                selectFirstArtistCategory()
            } else {
                // 그 외의 경우 apply snapshot 활용. 기존 데이터와 신규 데이터의 갯수가 달라질 때만 animation
                noteDetailDataSource.apply(
                    snapshot,
                    animatingDifferences: isCountDifferent
                )
            }

        } else {
            // 노트 섹션이 처음 추가될 때
            snapshot.appendSections([.notes])
            let currentItems = snapshot.itemIdentifiers(inSection: .notes)
            if newItems.isEmpty {
                snapshot.deleteItems(currentItems)
                if userInfo != nil {
                    snapshot.appendItems([.emptyNote], toSection: .notes)
                } else {
                    snapshot.appendItems([.requiredLogin], toSection: .notes)
                }
            } else {
                snapshot.deleteItems(currentItems)
                snapshot.appendItems(newItems, toSection: .notes)
            }

            noteDetailDataSource.applySnapshotUsingReloadData(snapshot)
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
                guard let self = self else { return }
                selectFirstArtistCategory()
                viewModel.getMyNotes(isInitialFetch: true)
            }
        } else {
            // 그 외에는 cell 갯수는 변화가 없으나 컨텐츠에 변화가 있다고 판단. reloadData 수행
            noteDetailDataSource.applySnapshotUsingReloadData(snapshot)
        }
    }

    private func selectFirstArtistCategory() {
        let firstIndexPath = IndexPath(item: 0, section: 0)
        noteDetailCollectionView.selectItem(at: firstIndexPath, animated: false, scrollPosition: .top)
    }
}

private extension MyNoteViewController.Row {
    func dequeueConfiguredReusableCell(
        collectionView: UICollectionView,
        emptyNoteCellRegistration: UICollectionView.CellRegistration<EmptyNoteCell, Void>,
        noteCellRegistration: UICollectionView.CellRegistration<NoteCell, Note>,
        artistCategoryCellRegistration: UICollectionView.CellRegistration<ArtistNameCollectionViewCell, FavoriteArtistHavingNote>,
        requiredLoginCellRegistration: UICollectionView.CellRegistration<RequiredLoginNoteCell, Void>,
        indexPath: IndexPath
    ) -> UICollectionViewCell {
        switch self {
        case .note(let note):
            return collectionView.dequeueConfiguredReusableCell(
                using: noteCellRegistration,
                for: indexPath,
                item: note
            )
        case .emptyNote:
            return collectionView.dequeueConfiguredReusableCell(
                using: emptyNoteCellRegistration,
                for: indexPath,
                item: ()
            )
        case .artistCategory(let note):
            return collectionView.dequeueConfiguredReusableCell(
                using: artistCategoryCellRegistration,
                for: indexPath,
                item: note
            )
        case .requiredLogin:
            return collectionView.dequeueConfiguredReusableCell(
                using: requiredLoginCellRegistration,
                for: indexPath,
                item: ()
            )
        }
    }
}

private extension MyNoteViewController {
    var noteDetailCollectionView: UICollectionView {
        return contentView.noteDetailCollectionView
    }
}
