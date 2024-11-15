//
//  NoteDetailViewController.swift
//  FeatureHomeInterface
//
//  Created by 황인우 on 9/7/24.
//

import Combine
import UIKit

import Domain
import Shared

public protocol NoteDetailViewControllerDelegate: AnyObject {
    func pushReportViewController(noteID: Int?, commentID: Int?)
    func presentEditNoteViewController(note: Note)
    func popViewController()
    func pushNoteCommentsViewController(noteID: Int)
    func didFinish()
    func handleError(
        errorCode: String?,
        errorMessage: String,
        errorData: AnyType?
    )
}

public final class NoteDetailViewController: UIViewController, NoteMenuHandling, NoteMusicHandling {
    public weak var coordinator: NoteDetailViewControllerDelegate?

    private var cancellables: Set<AnyCancellable> = .init()
    
    // MARK: - Keychain
    
    @KeychainWrapper<UserInformation>(.userInfo)
    public var userInfo
    
    private var isLoggedIn: Bool {
        return self.userInfo?.userID != nil
    }
    
    // MARK: - NoteMenu Subjects
    
    public let onReportNote: PassthroughSubject<Int, Never> = .init()
    public let onEditNote: PassthroughSubject<Note, Never> = .init()
    public let onDeleteNote: PassthroughSubject<Int, Never> = .init()
    
    // MARK: - Diffable DataSource
    
    enum Section: String, CaseIterable {
        case song
        case notes
    }
    
    enum Row: Hashable {
        case emptySong
        case song(SongDetail)
        case emptyNote
        case note(Note)
    }
    
    private typealias NoteDetailDataSource = UICollectionViewDiffableDataSource<Section, Row>
    private typealias NoteDetailSnapshot = NSDiffableDataSourceSnapshot<Section, Row>
    
    private lazy var noteDetailDataSource: NoteDetailDataSource = {
        let emptySongCellRegistration = UICollectionView.CellRegistration<EmptySongCell, Void> { cell, indexPath, _ in
            
        }
        let songCellRegistration = UICollectionView.CellRegistration<SongCell, SongDetail> { [weak self] cell, index, songDetail in
            cell.configure(
                albumImageURL: try? songDetail.imageURL?.asURL(),
                songName: songDetail.name,
                artistName: songDetail.artist.name
            )
        }
        
        let emptyNoteCellRegistration = UICollectionView.CellRegistration<EmptyNoteCell, Void> { cell, indexPath, _ in }
        
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
        
        let dataSource = NoteDetailDataSource(collectionView: self.noteDetailCollectionView) { collectionView, indexPath, item in
            return item.dequeueConfiguredReusableCell(
                collectionView: collectionView,
                emptySongCellRegistration: emptySongCellRegistration,
                songCellRegistration: songCellRegistration,
                emptyNoteCellRegistration: emptyNoteCellRegistration,
                noteCellRegistration: noteCellRegistration,
                indexPath: indexPath
            )
        }
        
        let relatedNoteHeaderRegistration = UICollectionView.SupplementaryRegistration<NoteDetailHeaderView>(elementKind: NoteDetailHeaderView.reuseIdentifier) { [weak viewModel] noteDetailHeaderView, elementKind, indexPath in
            
            guard let viewModel = viewModel else { return }
            
            viewModel.$songDetail
                .map(\.?.noteCount)
                .sink { fetchedNoteCount in
                    noteDetailHeaderView.configureNoteCount(fetchedNoteCount ?? 0)
                }
                .store(in: &noteDetailHeaderView.cancellables)
            
            noteDetailHeaderView.includeNoteButton.publisher(for: .touchUpInside)
                .map(\.isSelected)
                .sink { isSelected in
                    self.viewModel.mustHaveLyrics = isSelected
                }
                .store(in: &noteDetailHeaderView.cancellables)
        }
        
        dataSource.supplementaryViewProvider = { [weak viewModel] (collectionView, kind, indexPath) in
            guard let viewModel = viewModel else {
                return UICollectionReusableView()
            }
            
            switch indexPath.section {
            case NoteDetailView.relatedNoteSectionIndex:
                switch kind {
                case NoteDetailHeaderView.reuseIdentifier:
                    let noteDetailHeaderView = collectionView.dequeueConfiguredReusableSupplementary(
                        using: relatedNoteHeaderRegistration,
                        for: indexPath
                    )
                    
                    return noteDetailHeaderView
                    
                default:
                    return UICollectionReusableView()
                }
                
            default:
                return UICollectionReusableView()
            }
        }
        
        return dataSource
    }()
    
    // MARK: - ViewModel
    
    var viewModel: NoteDetailViewModel
    
    // MARK: - UI Components
    
    private var noteDetailView: NoteDetailView = .init()
    
    public init(viewModel: NoteDetailViewModel) {
        self.viewModel = viewModel
        
        super.init(nibName: nil, bundle: .main)
        
        self.hidesBottomBarWhenPushed = true
    }
    
    // MARK: - Init
    
    @available(*, unavailable)
    public required init?(coder: NSCoder) {
        fatalError()
    }
    
    // MARK: - View LifeCycle
    
    override public func loadView() {
        self.view = noteDetailView
    }

    override public func viewDidLoad() {
        super.viewDidLoad()

        self.bindUI()
        self.bindData()
        self.bindAction()
    }

    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.fetchSongDetailAndNotes()
    }

    public func fetchSongDetailAndNotes() {
        self.viewModel.getSongDetailAndNotes()
    }
    
    private func setUpSongSection(with songDetail: SongDetail?) {
        var snapshot = noteDetailDataSource.snapshot()
        
        guard let existingSongDetail = songDetail else {
            snapshot.appendSections([.song])
            let currentItems = snapshot.itemIdentifiers(inSection: .song)
            snapshot.deleteItems(currentItems)
            snapshot.appendItems([.emptySong])
            noteDetailDataSource.apply(snapshot)
            return
        }
        
        
        if !snapshot.sectionIdentifiers.contains(.song) {
            snapshot.appendSections([.song])
        }
        
        let currentItem = snapshot.itemIdentifiers(inSection: .song)
        snapshot.deleteItems(currentItem)
        snapshot.appendItems([.song(existingSongDetail)], toSection: .song)
        
        guard let refreshControl = self.noteDetailCollectionView.refreshControl else {
            noteDetailDataSource.apply(
                snapshot,
                animatingDifferences: false
            )
            return
        }
        
        if refreshControl.isRefreshing {
            noteDetailDataSource.applySnapshotUsingReloadData(snapshot)
        } else {
            noteDetailDataSource.apply(
                snapshot,
                animatingDifferences: false
            )
        }
    }
    
    private func updateSnapshot(notes: [Note]) {
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
            
            guard let refreshControl = self.noteDetailCollectionView.refreshControl else {
                let isCountDifferent = currentItems.count != newItems.count
                noteDetailDataSource.apply(
                    snapshot,
                    animatingDifferences: isCountDifferent
                )
                return
            }
            // pull-to-refresh 중일 경우 reloadData를 활용하여 apply snapshot에 의해서 생기는 bounce 방지
            if refreshControl.isRefreshing {
                noteDetailDataSource.applySnapshotUsingReloadData(snapshot)
            } else {
                // 그 외의 경우 apply snapshot 활용. 기존 데이터와 신규 데이터의 갯수가 달라질 때만 animation
                let isCountDifferent = currentItems.count != newItems.count
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
                snapshot.appendItems([.emptyNote], toSection: .notes)
            } else {
                snapshot.deleteItems(currentItems)
                snapshot.appendItems(newItems, toSection: .notes)
            }
            
            noteDetailDataSource.applySnapshotUsingReloadData(snapshot)
        }
        
    }
}

// MARK: - Bindings

private extension NoteDetailViewController {
    func bindUI() {
        viewModel.$error
            .compactMap { $0 }
            .sink { [weak self] error in
                if case let .feelinAPIError(feelinAPIError) = error,
                   feelinAPIError.type == .tokenNotFound {
                    self?.showAlert(
                        title: "로그인 후 이용할 수 있어요.",
                        message: nil,
                        rightActionTitle: "로그인",
                        rightActionCompletion: {
                            self?.viewModel.logout()
                        }
                    )
                } else {
                    self?.coordinator?.handleError(
                        errorCode: error.errorCode,
                        errorMessage: error.userMessage,
                        errorData: error.data
                    )
                }
            }
            .store(in: &cancellables)
        
        viewModel.$logoutResult
            .sink { [weak self] result in
                switch result {
                case .success:
                    self?.coordinator?.didFinish()
                    
                case .failure(let error):
                    self?.coordinator?.handleError(
                        errorCode: error.errorCode,
                        errorMessage: error.userMessage,
                        errorData: error.data
                    )
                    
                default:
                    break
                }
            }
            .store(in: &cancellables)
        
        viewModel.$refreshState
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { [weak self] refreshState in
                switch refreshState {
                case .failed(let error):
                    self?.coordinator?.handleError(
                        errorCode: error.errorCode,
                        errorMessage: error.userMessage,
                        errorData: error.data
                    )

                case .completed:
                    self?.noteDetailCollectionView.refreshControl?.endRefreshing()

                default:
                    return
                }
            })
            .store(in: &cancellables)
    }
    
    func bindAction() {
        backButton.publisher(for: .touchUpInside)
            .sink { [weak self] _ in
                self?.coordinator?.popViewController()
            }
            .store(in: &cancellables)

        noteDetailCollectionView.publisher(for: [.didSelectItem])
            .sink { [weak self] indexPath in
                guard let self = self else { return }

                // 해당 indexPath에 맞는 item을 dataSource에서 가져옴
                guard let item = self.noteDetailDataSource.itemIdentifier(for: indexPath) else { return }

                switch item {
                case .note(let note):
                    coordinator?.pushNoteCommentsViewController(noteID: note.id)
                    
                default:
                    return
                }
            }
            .store(in: &cancellables)

        noteDetailCollectionView.didScrollToBottomPublisher()
            .sink { [weak viewModel] in
                viewModel?.getMoreSongNotes()
            }
            .store(in: &cancellables)
        
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
        
        noteDetailCollectionView.refreshControl?.isRefreshingPublisher
            .filter { $0 }
            .sink(receiveValue: { [weak self] _ in
                self?.fetchSongDetailAndNotes()
            })
            .store(in: &cancellables)
    }
    
    func bindData() {
        self.viewModel.$songDetail
            .sink { [weak self] songDetail in
                self?.setUpSongSection(with: songDetail)
            }
            .store(in: &cancellables)
        
        self.viewModel.$fetchedNotes
            .sink { [weak self] fetchedNotes in
                self?.updateSnapshot(notes: fetchedNotes)
            }
            .store(in: &cancellables)

        self.viewModel.$deleteNoteResult
            .receive(on: DispatchQueue.main)
            .sink { [weak self] result in
                switch result {
                case .success:
                    self?.fetchSongDetailAndNotes()

                case .failure(let error):
                    self?.coordinator?.handleError(
                        errorCode: error.errorCode,
                        errorMessage: error.userMessage,
                        errorData: error.data
                    )

                default:
                    return
                }
            }
            .store(in: &cancellables)
    }
}

private extension NoteDetailViewController {
    var noteDetailCollectionView: UICollectionView {
        return self.noteDetailView.noteDetailCollectionView
    }   

    var backButton: UIButton {
        return self.noteDetailView.backButton
    }
}

private extension NoteDetailViewController.Row {
    func dequeueConfiguredReusableCell(
        collectionView: UICollectionView,
        emptySongCellRegistration: UICollectionView.CellRegistration<EmptySongCell, Void>,
        songCellRegistration: UICollectionView.CellRegistration<SongCell, SongDetail>,
        emptyNoteCellRegistration: UICollectionView.CellRegistration<EmptyNoteCell, Void>,
        noteCellRegistration: UICollectionView.CellRegistration<NoteCell, Note>,
        indexPath: IndexPath
    ) -> UICollectionViewCell {
        switch self {
        case .emptySong:
            return collectionView.dequeueConfiguredReusableCell(
                using: emptySongCellRegistration,
                for: indexPath,
                item: ()
            )
            
        case .song(let songDetail):
            return collectionView.dequeueConfiguredReusableCell(
                using: songCellRegistration,
                for: indexPath,
                item: songDetail
            )
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
        }
    }
}
