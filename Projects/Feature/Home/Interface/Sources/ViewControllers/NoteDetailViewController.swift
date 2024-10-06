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
    func pushEditNoteViewController(noteID: Int)
    func popViewController(isHiddenTabBar: Bool)
    func pushNoteCommentsViewController(noteID: Int)
}

public final class NoteDetailViewController: UIViewController, NoteMenuHandling, NoteMusicHandling {
    public weak var coordinator: NoteDetailViewControllerDelegate?

    private var cancellables: Set<AnyCancellable> = .init()
    
    // MARK: - Keychain
    
    @KeychainWrapper<UserInformation>(.userInfo)
    public var userInfo
    
    // MARK: - NoteMenu Subjects
    
    public let onReportNote: PassthroughSubject<Int, Never> = .init()
    public let onEditNote: PassthroughSubject<Int, Never> = .init()
    public let onDeleteNote: PassthroughSubject<Int, Never> = .init()
    
    // MARK: - Diffable DataSource
    
    private enum Section: String, CaseIterable {
        case song
        case note
    }
    
    private enum Row: Hashable {
        case song(SearchedNote)
        case note(Note)
    }
    
    private typealias NoteDetailDataSource = UICollectionViewDiffableDataSource<Section, Row>
    private typealias NoteDetailSnapshot = NSDiffableDataSourceSnapshot<Section, Row>
    
    private lazy var noteDetailDataSource: NoteDetailDataSource = {
        let dataSource = NoteDetailDataSource(collectionView: self.noteDetailCollectionView) { collectionView, indexPath, item in
            switch item {
            case .song(let selectedNote):
                let cell: SongCell = collectionView.dequeueReusableCell(for: indexPath)
                cell.configure(
                    albumImageURL: try? selectedNote.albumImageUrl.asURL(),
                    songName: selectedNote.songName,
                    artistName: selectedNote.artistName
                )
                
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
                    .sink { [unowned self] control in
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
                    .sink { [unowned self] control in
                        self.viewModel.setNoteBookmarkState(
                            noteID: note.id,
                            isBookmarked: control.isSelected
                        )
                    }
                    .store(in: &self.cancellables)
                
                cell.moreAboutContentButton.publisher(for: .touchUpInside)
                    .sink { [unowned self] _ in
                        if let noteMenuViewController = self.makeNoteMenuViewController(checking: note) {
                            self.present(noteMenuViewController, animated: false)
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
                    .sink { [unowned self] _ in
                        self.openYouTube(query: "\(note.song.artist.name) \(note.song.name)")
                    }
                    .store(in: &self.cancellables)
                
                return cell
            }
        }
        
        dataSource.supplementaryViewProvider = { [weak viewModel] (collectionView, kind, indexPath) in
            guard let viewModel = viewModel else {
                return UICollectionReusableView()
            }
            
            switch indexPath.section {
            case NoteDetailView.relatedNoteSectionIndex:
                switch kind {
                case NoteDetailHeaderView.reuseIdentifier:
                    let noteDetailHeaderView = collectionView.dequeueReusableSupplementaryView(
                        ofKind: kind,
                        for: indexPath,
                        viewType: NoteDetailHeaderView.self
                    )
                    
                    noteDetailHeaderView.configureNoteCount(viewModel.selectedNote.noteCount)
                    
                    noteDetailHeaderView.includeNoteButton.publisher(for: .touchUpInside)
                        .map(\.isSelected)
                        .assign(to: &viewModel.$mustHaveLyrics)
                    
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
    }
    
    // MARK: - Init
    
    @available(*, unavailable)
    public required init?(coder: NSCoder) {
        fatalError()
    }
    
    override public func loadView() {
        self.view = noteDetailView
    }

    override public func viewDidLoad() {
        super.viewDidLoad()
        
        self.setUpSongSection()
        self.fetchSongNotes(
            isInitial: true,
            mustHaveLyrics: false
        )
        self.bindUI()
        self.bindData()
        self.bindAction()
    }
    
    private func fetchSongNotes(
        isInitial: Bool,
        mustHaveLyrics: Bool
    ) {
        self.viewModel.getSongNotes(isInitial: isInitial)
    }
    
    private func setUpSongSection() {
        var snapshot = noteDetailDataSource.snapshot()
        snapshot.appendSections([.song])
        
        snapshot.appendItems([.song(viewModel.selectedNote)], toSection: .song)
        
        noteDetailDataSource.apply(snapshot)
    }
    
    private func updateSnapshot(notes: [Note]) {
        var snapshot = noteDetailDataSource.snapshot()
        
        // 섹션이 없을 경우 추가
        if !snapshot.sectionIdentifiers.contains(.note) {
            snapshot.appendSections([.note])
        }
        
        // 기존 섹션의 아이템을 가져오기
        let currentItems = snapshot.itemIdentifiers(inSection: .note)
        let noteRows = notes.map { Row.note($0) }
        
        // 새로운 데이터와 기존 데이터를 비교하여 다른 경우에만 업데이트
        if currentItems != noteRows {
            // 기존 아이템 삭제
            snapshot.deleteItems(currentItems)
            
            // 새로운 데이터 추가
            snapshot.appendItems(noteRows, toSection: .note)
            
            // 스냅샷을 적용
            noteDetailDataSource.apply(snapshot, animatingDifferences: true)
        } else {
            // 그 외에는 cell 갯수는 변화가 없으나 컨텐츠에 변화가 있다고 판단. reloadData 수행
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
                self?.showAlert(
                    title: error.errorDescription,
                    message: nil,
                    singleActionTitle: "확인"
                )
            }
            .store(in: &cancellables)
    }
    
    func bindAction() {
        backButton.publisher(for: .touchUpInside)
            .sink { [weak self] _ in
                self?.coordinator?.popViewController(isHiddenTabBar: false)
            }
            .store(in: &cancellables)

        noteDetailCollectionView.publisher(for: [.didSelectItem])
            .sink { [weak self] indexPath in
                guard let self = self else { return }

                // 해당 indexPath에 맞는 item을 dataSource에서 가져옴
                guard let item = self.noteDetailDataSource.itemIdentifier(for: indexPath) else { return }

                switch item {
                case .song(let searchedNote):
                    break
                case .note(let note):
                    coordinator?.pushNoteCommentsViewController(noteID: note.id)
                }
            }
            .store(in: &cancellables)

        noteDetailCollectionView.didScrollToBottomPublisher()
            .sink { [weak viewModel] in
                viewModel?.getSongNotes(isInitial: false)
            }
            .store(in: &cancellables)
        
        onReportNote.eraseToAnyPublisher()
            .sink { [weak self] noteID in
                self?.coordinator?.pushReportViewController(noteID: noteID, commentID: nil)
            }
            .store(in: &cancellables)
        
        onEditNote.eraseToAnyPublisher()
            .sink { [weak self] noteID in
                self?.coordinator?.pushEditNoteViewController(noteID: noteID)
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
    }
    
    func bindData() {
        self.viewModel.$fetchedNotes
            .sink { [weak self] fetchedNotes in
                self?.updateSnapshot(notes: fetchedNotes)
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
