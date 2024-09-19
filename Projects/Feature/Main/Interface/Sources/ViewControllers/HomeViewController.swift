//
//  HomeViewController.swift
//  FeatureMainInterface
//
//  Created by 황인우 on 8/11/24.
//

import Domain
import Shared

import Combine
import UIKit

public class HomeViewController: UIViewController, NoteMenuHandling, NoteMusicHandling {
    var viewModel: HomeViewModel
    
    private var cancellables: Set<AnyCancellable> = .init()
    
    // MARK: - Keychain
    
    @KeychainWrapper<UserInformation>(.userInfo)
    public var userInfo
    
    // MARK: - UI Components
    
    private var homeView: HomeView = .init()
    
    // MARK: - NoteMenu Subjects
    
    public let onReportNote: PassthroughSubject<Int, Never> = .init()
    public let onEditNote: PassthroughSubject<Int, Never> = .init()
    public let onDeleteNote: PassthroughSubject<Int, Never> = .init()
    
    // MARK: - DiffableDataSource
    
    private typealias HomeDataSource = UICollectionViewDiffableDataSource<Section, Row>
    
    private enum Section: Hashable {
        case banner
        case favoriteArtists
        case notes
    }
    
    private enum Row: Hashable {
        case banner
        case favoriteArtist(Artist)
        case searchArtist
        case note(Note)
        case emptyNote
    }
    
    private lazy var homeDataSource: HomeDataSource = {
        let dataSource = HomeDataSource(collectionView: self.homeCollectionView) { collectionView, indexPath, item in
            switch item {
            case .banner:
                let cell = collectionView.dequeueReusableCell(for: indexPath, cellType: BannerCell.self)
                return cell
                
            case .searchArtist:
                let cell = collectionView.dequeueReusableCell(for: indexPath, cellType: SearchArtistCell.self)
                return cell
                
            case .favoriteArtist(let artist):
                let cell = collectionView.dequeueReusableCell(for: indexPath, cellType: FeelinArtistCell.self)
                cell.configure(artistName: artist.name, artistImageURL: try? artist.imageSource?.asURL())
                return cell
                
            case .emptyNote:
                let cell = collectionView.dequeueReusableCell(for: indexPath, cellType: EmptyNoteCell.self)
                
                return cell
                
            case .note(let note):
                let cell = collectionView.dequeueReusableCell(for: indexPath, cellType: NoteCell.self)
                cell.configure(with: note)
                
                cell.likeNoteButton.publisher(for: .touchUpInside)
                    .debounce(for: .milliseconds(600), scheduler: DispatchQueue.main)
                    .sink { [weak self] control in
                        self?.viewModel.setNoteLikeState(noteID: note.id, isLiked: control.isSelected)
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
        
        dataSource.supplementaryViewProvider = { [unowned self] (collectionView, kind, indexPath) in
            switch indexPath.section {
            case HomeView.favoriteArtistSectionIndex:
                switch kind {
                case FavoriteArtistsHeaderView.reuseIdentifier:
                    let favoriteArtistsHeaderView = collectionView.dequeueReusableSupplementaryView(
                        ofKind: kind,
                        for: indexPath,
                        viewType: FavoriteArtistsHeaderView.self
                    )
                    
                    viewModel.$fetchedFavoriteArtists
                        .map { !$0.isEmpty }
                        .assign(to: \.isEnabled, on: favoriteArtistsHeaderView.viewAllButton)
                        .store(in: &cancellables)
                    
                    return favoriteArtistsHeaderView
                    
                case SectionDividerView.reuseIdentifier:
                    let sectionDividerView = collectionView.dequeueReusableSupplementaryView(
                        ofKind: kind,
                        for: indexPath,
                        viewType: SectionDividerView.self
                    )
                    
                    return sectionDividerView
                    
                default:
                    return UICollectionReusableView()
                }
                
            case HomeView.notesSectionIndex:
                if kind == NotesHeaderView.reuseIdentifier {
                    let notesHeaderView = collectionView.dequeueReusableSupplementaryView(
                        ofKind: kind,
                        for: indexPath,
                        viewType: NotesHeaderView.self
                    )
                    
                    return notesHeaderView
                } else {
                    return UICollectionReusableView()
                }
                
            default:
                return UICollectionReusableView()
            }
        }
        
        return dataSource
    }()
    
    // MARK: - Init
    
    public init(viewModel: HomeViewModel) {
        self.viewModel = viewModel
        
        super.init(nibName: nil, bundle: .main)
    }
    
    @available(*, unavailable)
    required public init?(coder: NSCoder) {
        fatalError()
    }
    
    public override func loadView() {
        self.view = homeView
    }
    
    private func updateBanner() {
        var snapshot = homeDataSource.snapshot()
        
        // banner 섹션을 추가 (초기 로드만)
        if !snapshot.sectionIdentifiers.contains(.banner) {
            snapshot.appendSections([.banner])
            snapshot.appendItems([.banner], toSection: .banner)
        }
        homeDataSource.apply(snapshot, animatingDifferences: true)
    }
    
    private func updateFavoriteArtists(_ favoriteArtists: [Artist]) {
        var snapshot = homeDataSource.snapshot()
        
        // favoriteArtists 섹션을 업데이트
        if snapshot.sectionIdentifiers.contains(.favoriteArtists) {
            let currentItems = snapshot.itemIdentifiers(inSection: .favoriteArtists)
            let newArtistItems = favoriteArtists.map { Row.favoriteArtist($0) }
            if currentItems != newArtistItems {
                snapshot.deleteItems(currentItems)
                snapshot.appendItems(newArtistItems, toSection: .favoriteArtists)
            }
        } else {
            snapshot.appendSections([.favoriteArtists])
            snapshot.appendItems(favoriteArtists.map { Row.favoriteArtist($0) }, toSection: .favoriteArtists)
        }
        homeDataSource.apply(snapshot, animatingDifferences: true)
    }
    
    private func updateNotes(_ notes: [Note]) {
        var snapshot = homeDataSource.snapshot()
        
        // notes 섹션이 있는 경우
        if snapshot.sectionIdentifiers.contains(.notes) {
            let currentItems = snapshot.itemIdentifiers(inSection: .notes)
            
            if notes.isEmpty {
                // notes가 비어있으면 Row.emptyNote를 추가
                if !currentItems.contains(.emptyNote) {
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
            homeDataSource.apply(snapshot, animatingDifferences: itemCountChanged)

        } else {
            // notes 섹션이 처음 추가될 때
            snapshot.appendSections([.notes])
            
            if notes.isEmpty {
                // notes가 비어있으면 Row.emptyNote 추가
                snapshot.appendItems([.emptyNote], toSection: .notes)
            } else {
                // notes가 있으면 Row.note 추가
                snapshot.appendItems(notes.map { Row.note($0) }, toSection: .notes)
            }

            homeDataSource.apply(snapshot, animatingDifferences: false)
        }
    }
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        self.viewModel.fetchNotes(isInitialFetch: true)
        self.viewModel.fetchFavoriteArtists(isInitialFetch: true)
        self.bindUI()
        self.bindAction()
    }
}

private extension HomeViewController {
    
    // MARK: - Bindings
    
    func bindUI() {
        self.updateBanner()
        
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
        
        viewModel.$refreshState
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { [weak self] refreshState in
                switch refreshState {
                case .failed(let error):
                    self?.showAlert(
                        title: error.errorDescription,
                        message: nil,
                        singleActionTitle: "확인"
                    )
                    
                case .completed:
                    self?.homeCollectionView.refreshControl?.endRefreshing()
                    
                default:
                    return
                }
            })
            .store(in: &cancellables)
        
        viewModel.$fetchedFavoriteArtists
            .sink { [weak self] fetchedArtists in
                self?.updateFavoriteArtists(fetchedArtists)
            }
            .store(in: &cancellables)
        
        viewModel.$fetchedNotes
            .sink { [weak self] fetchedNotes in
                self?.updateNotes(fetchedNotes)
            }
            .store(in: &cancellables)
    }
    
    func bindAction() {
        homeCollectionView.didScrollToBottomPublisher()
            .sink { [weak viewModel] in
                viewModel?.fetchNotes(isInitialFetch: false)
            }
            .store(in: &cancellables)
        
        homeCollectionView.refreshControl?.isRefreshingPublisher
            .filter { $0 }
            .sink(receiveValue: { [weak viewModel] _ in
                viewModel?.refreshAllData()
            })
            .store(in: &cancellables)
        
        onReportNote.eraseToAnyPublisher()
            .sink { noteID in
                // TODO: - 추후 신고화면으로 이동
            }
            .store(in: &cancellables)
        
        onEditNote.eraseToAnyPublisher()
            .sink { noteID in
                // TODO: - 추후 게시글 수정화면으로 이동
            }
            .store(in: &cancellables)
        
        onDeleteNote.eraseToAnyPublisher()
            .sink { [weak self] noteID in
                self?.showAlert(
                    title: "노트를 삭제하시겠어요?",
                    message: nil,
                    rightActionTitle: "삭제",
                    rightActionCompletion: {
                        self?.viewModel.deleteNote(id: noteID)
                    })
            }
            .store(in: &cancellables)
    }
}

private extension HomeViewController {
    var homeCollectionView: UICollectionView {
        return self.homeView.homeCollectionView
    }
}
