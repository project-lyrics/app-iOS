//
//  HomeViewController.swift
//  FeatureHomeInterface
//
//  Created by 황인우 on 8/11/24.
//

import Domain
import Shared

import Combine
import UIKit

public protocol HomeViewControllerDelegate: AnyObject {
    func pushReportViewController(noteID: Int?, commentID: Int?)
    func presentEditNoteViewController(note: Note)
    func pushNoteNotificationViewController()
    func pushMyFavoriteArtistsViewController(artists: [Artist])
    func pushCommunityMainViewController(artist: Artist)
    func pushNoteCommentsViewController(noteID: Int)
    func presentInitialArtistSelectViewController()
    func presentSearchMoreFavoriteArtistViewController()
}

public class HomeViewController: UIViewController, NoteMenuHandling, NoteMusicHandling {

    public weak var coordinator: HomeViewControllerDelegate?

    private var viewModel: HomeViewModel

    private var cancellables: Set<AnyCancellable> = .init()

    // MARK: - Keychain

    @KeychainWrapper<UserInformation>(.userInfo)
    public var userInfo

    // MARK: - UI Components

    private var homeView: HomeView = .init()

    // MARK: - NoteMenu Subjects

    public let onReportNote: PassthroughSubject<Int, Never> = .init()
    public let onEditNote: PassthroughSubject<Note, Never> = .init()
    public let onDeleteNote: PassthroughSubject<Int, Never> = .init()

    // MARK: - DiffableDataSource

    private typealias HomeDataSource = UICollectionViewDiffableDataSource<CollectionContent.Section, CollectionContent.Item>
    
    private lazy var homeDataSource: HomeDataSource = {
        let bannerCellRegistration = UICollectionView.CellRegistration<BannerCell, Void> { cell, indexPath, item in }
        let searchArtistCellRegistration = UICollectionView.CellRegistration<SearchArtistCell, Void> { cell, indexPath, item in }
        let favoriteArtistCellRegistration = UICollectionView.CellRegistration<FeelinArtistCell, Artist> { cell, indexPath, artist in
            cell.configure(artistName: artist.name, artistImageURL: try? artist.imageSource?.asURL())
        }
        let emptyNoteCellRegistration = UICollectionView.CellRegistration<EmptyNoteCell, Void> { cell, indexPath, _ in }
        
        let noteCellRegistration = UICollectionView.CellRegistration<NoteCell, Note> { [weak self] cell, indexPath, note in
            guard let self = self else { return }
            cell.configure(with: note)
            
            cell.likeNoteButton.publisher(for: .touchUpInside)
                .sink { [weak self] control in
                    self?.viewModel.setNoteLikeState(noteID: note.id, isLiked: control.isSelected)
                }
                .store(in: &cell.cancellables)
            
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
                .store(in: &cell.cancellables)
            
            cell.moreAboutContentButton.publisher(for: .touchUpInside)
                .sink { _ in
                    if let noteMenuViewController = self.makeNoteMenuViewController(checking: note) {
                        self.present(noteMenuViewController, animated: false)
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
                    self.openYouTube(query: "\(note.song.artist.name) \(note.song.name)")
                }
                .store(in: &cell.cancellables)
        }
        
        let favoriteArtistHeaderRegistraion = UICollectionView.SupplementaryRegistration<FavoriteArtistsHeaderView>(elementKind: FavoriteArtistsHeaderView.reuseIdentifier) { [weak self] favoriteArtistsHeaderView, elementKind, indexPath in
            guard let self = self else { return }
            
            viewModel.$fetchedFavoriteArtists
                .map { !$0.isEmpty }
                .assign(to: \.isEnabled, on: favoriteArtistsHeaderView.viewAllButton)
                .store(in: &cancellables)
            
            favoriteArtistsHeaderView.viewAllButton.publisher(for: .touchUpInside)
                .sink { _ in
                    self.coordinator?.pushMyFavoriteArtistsViewController(artists: self.viewModel.fetchedFavoriteArtists)
                }
                .store(in: &favoriteArtistsHeaderView.cancellables)
        }
        let sectionDividerRegistration = UICollectionView.SupplementaryRegistration<SectionDividerView>(elementKind: SectionDividerView.reuseIdentifier) { sectionDividerView, elementKind, indexPath in
            
        }
        let noteHeaderRegistration = UICollectionView.SupplementaryRegistration<NotesHeaderView>(elementKind: NotesHeaderView.reuseIdentifier) { noteHeaderView, elementKind, indexPath in }
        
        let dataSource = HomeDataSource(collectionView: self.homeCollectionView) { [weak self] collectionView, indexPath, item in
            guard let self = self else { return nil }
            
            return item.dequeueConfiguredReusableCell(
                collectionView: collectionView,
                bannerCellRegistration: bannerCellRegistration,
                searchArtistCellRegistration: searchArtistCellRegistration,
                favoriteArtistCellRegistration: favoriteArtistCellRegistration,
                emptyNoteCellRegistration: emptyNoteCellRegistration,
                noteCellRegistration: noteCellRegistration,
                indexPath: indexPath
            )
        }
        
        dataSource.supplementaryViewProvider = { [unowned self] (collectionView, kind, indexPath) in
            switch indexPath.section {
            case HomeView.favoriteArtistSectionIndex:
                switch kind {
                case FavoriteArtistsHeaderView.reuseIdentifier:
                    let favoriteArtistsHeaderView = collectionView.dequeueConfiguredReusableSupplementary(
                        using: favoriteArtistHeaderRegistraion,
                        for: indexPath
                    )
                    
                    return favoriteArtistsHeaderView
                    
                case SectionDividerView.reuseIdentifier:
                    let sectionDividerView = collectionView.dequeueConfiguredReusableSupplementary(
                        using: sectionDividerRegistration,
                        for: indexPath
                    )
                    
                    return sectionDividerView
                    
                default:
                    return UICollectionReusableView()
                }
                
            case HomeView.notesSectionIndex:
                if kind == NotesHeaderView.reuseIdentifier {
                    let notesHeaderView = collectionView.dequeueConfiguredReusableSupplementary(
                        using: noteHeaderRegistration,
                        for: indexPath
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

        // 배너 섹션이 없는 경우 추가
        if !snapshot.sectionIdentifiers.contains(.banner) {
            snapshot.appendSections([.banner])
            snapshot.appendItems([.banner], toSection: .banner)
        }
        homeDataSource.apply(snapshot, animatingDifferences: false)
    }

    private func updateFavoriteArtists(_ favoriteArtists: [Artist]) {
        var snapshot = homeDataSource.snapshot()
        
        let newItems = favoriteArtists.map { CollectionContent.Item.favoriteArtist($0) }
        
        // favoriteArtists 섹션이 이미 있는지 확인 후 업데이트
        if snapshot.sectionIdentifiers.contains(.favoriteArtists) {
            let currentItems = snapshot.itemIdentifiers(inSection: .favoriteArtists)

            // 기존 아이템과 새 아이템 비교 후 변경 사항 있을 때만 업데이트
            if currentItems != newItems {
                snapshot.deleteItems(currentItems)
                snapshot.appendItems([.searchArtist], toSection: .favoriteArtists)
                snapshot.appendItems(newItems, toSection: .favoriteArtists)
            }
            
            // 갯수를 비교할 때 새롭게 추가된 아티스트 cell + 찾아보기 cell과 기존 cell 갯수를 비교 해야 한다.
            let searchItemButtonCount = 1
            let isCountDifferent = currentItems.count != (newItems.count + searchItemButtonCount)
            
            guard let refreshControl = self.homeCollectionView.refreshControl else {
                // pull-to-refresh가 없는 경우 apply snapshot만 적용. 갯수가 달라질때만 animation
                homeDataSource.apply(
                    snapshot,
                    animatingDifferences: isCountDifferent
                )
                return
            }
            // pull-to-refresh 중일 경우 reloadData를 활용하여 apply snapshot에 의해서 생기는 bounce 방지
            if refreshControl.isRefreshing {
                homeDataSource.applySnapshotUsingReloadData(snapshot)
            } else {
                // 그 외의 경우 apply snapshot 활용. 기존 데이터와 신규 데이터의 갯수가 달라질 때만 animation
                homeDataSource.apply(
                    snapshot,
                    animatingDifferences: isCountDifferent
                )
            }
            
        } else {
            // 섹션이 없다면 새로 추가
            snapshot.appendSections([.favoriteArtists])
            snapshot.appendItems([.searchArtist], toSection: .favoriteArtists)
            snapshot.appendItems(newItems, toSection: .favoriteArtists)
            homeDataSource.applySnapshotUsingReloadData(snapshot)
        }

    }

    private func updateNotes(_ notes: [Note]) {
        var snapshot = homeDataSource.snapshot()

        // 노트 섹션 업데이트
        if snapshot.sectionIdentifiers.contains(.notes) {
            let currentItems = snapshot.itemIdentifiers(inSection: .notes)
            let newItems = notes.map { CollectionContent.Item.note($0) }
            
            if newItems.isEmpty {
                snapshot.deleteItems(currentItems)
                snapshot.appendItems([.emptyNote], toSection: .notes)
            } else {
                snapshot.deleteItems(currentItems)
                snapshot.appendItems(newItems, toSection: .notes)
            }
            
            let isCountDifferent = currentItems.count != newItems.count
            
            guard let refreshControl = self.homeCollectionView.refreshControl else {
                // pull-to-refresh가 없는 경우 apply snapshot만 적용. 갯수가 달라질때만 animation
                homeDataSource.apply(
                    snapshot,
                    animatingDifferences: isCountDifferent
                )
                return
            }
            // pull-to-refresh 중일 경우 reloadData를 활용하여 apply snapshot에 의해서 생기는 bounce 방지
            if refreshControl.isRefreshing {
                homeDataSource.applySnapshotUsingReloadData(snapshot)
            } else {
                // 그 외의 경우 apply snapshot 활용. 기존 데이터와 신규 데이터의 갯수가 달라질 때만 animation
                homeDataSource.apply(
                    snapshot,
                    animatingDifferences: isCountDifferent
                )
            }
            
        } else {
            // 노트 섹션이 처음 추가될 때
            snapshot.appendSections([.notes])
            snapshot.appendItems([.emptyNote], toSection: .notes)
            
            homeDataSource.applySnapshotUsingReloadData(snapshot)
        }
    }
    
    // MARK: - View LifeCycle

    override public func viewDidLoad() {
        super.viewDidLoad()
        self.showSelectArtistListIfNeeded()
        self.bindUI()
        self.bindAction()
    }
    
    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.updateInitialHomeData()
        
    }
    
    // MARK: - Favorite Artists
    
    public func updateInitialHomeData() {
        self.viewModel.fetchArtistsThenNotes()
    }
    
    private func showSelectArtistListIfNeeded() {
        if let userInfo = userInfo,
           !userInfo.didEnterFirstFavoriteArtistsListPage {
            self.coordinator?.presentInitialArtistSelectViewController()
        }
    }
}

private extension HomeViewController {

    // MARK: - Bindings

    func bindUI() {
        self.updateBanner()

        viewModel.$error
            .compactMap { $0 }
            .sink { [weak self] error in
                //
                if let userID = self?.userInfo?.userID {
                    self?.showAlert(
                        title: error.errorDescription,
                        message: nil,
                        singleActionTitle: "확인"
                    )
                }
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

        homeCollectionView.publisher(for: [.didSelectItem])
            .sink { [weak self] indexPath in
                guard let self = self else { return }
                // 해당 indexPath에 맞는 item을 dataSource에서 가져옴
                guard let item = self.homeDataSource.itemIdentifier(for: indexPath) else { return }

                switch item {
                case .banner:
                    self.openWebBrowser(urlStr: "https://docs.google.com/forms/d/1ottTpPuoiDfQnZaMYwwi75WXdEInq6KHN8jY4L9Qc00/edit")

                case .searchArtist:
                    coordinator?.presentSearchMoreFavoriteArtistViewController()

                case .favoriteArtist(let artist):
                    coordinator?.pushCommunityMainViewController(artist: artist)

                case .note(let note):
                    coordinator?.pushNoteCommentsViewController(noteID: note.id)

                case .emptyNote:
                    break
                }
            }
            .store(in: &cancellables)

        homeCollectionView.refreshControl?.isRefreshingPublisher
            .filter { $0 }
            .sink(receiveValue: { [weak viewModel] _ in
                viewModel?.refreshAllData()
            })
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
                    rightActionTitle: "삭제",
                    rightActionCompletion: {
                        self?.viewModel.deleteNote(id: noteID)
                    })
            }
            .store(in: &cancellables)

        notificationButton.publisher(for: .touchUpInside)
            .sink { [weak self] _ in
                self?.coordinator?.pushNoteNotificationViewController()
            }
            .store(in: &cancellables)
    }
    
    private func openWebBrowser(urlStr: String) {
        guard let url = URL(string: urlStr) else {
            return
        }
        if UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url)
        }
    }
}

private extension HomeViewController {
    var homeCollectionView: UICollectionView {
        return self.homeView.homeCollectionView
    }

    var notificationButton: UIButton {
        return self.homeView.notificationButton
    }
}

// MARK: - CollectionContent

struct CollectionContent {
    enum Section: Hashable {
        case banner
        case favoriteArtists
        case notes
    }
    
    enum Item: Hashable {
        case banner
        case favoriteArtist(Artist)
        case searchArtist
        case note(Note)
        case emptyNote
    }
}

extension CollectionContent.Item {
    func dequeueConfiguredReusableCell(
        collectionView: UICollectionView,
        bannerCellRegistration: UICollectionView.CellRegistration<BannerCell, Void>,
        searchArtistCellRegistration: UICollectionView.CellRegistration<SearchArtistCell, Void>,
        favoriteArtistCellRegistration: UICollectionView.CellRegistration<FeelinArtistCell, Artist>,
        emptyNoteCellRegistration: UICollectionView.CellRegistration<EmptyNoteCell, Void>,
        noteCellRegistration: UICollectionView.CellRegistration<NoteCell, Note>,
        indexPath: IndexPath
    ) -> UICollectionViewCell {
        switch self {
        case .banner:
            return collectionView.dequeueConfiguredReusableCell(
                using: bannerCellRegistration,
                for: indexPath,
                item: ()
            )
        case .favoriteArtist(let artist):
            return collectionView.dequeueConfiguredReusableCell(
                using: favoriteArtistCellRegistration,
                for: indexPath,
                item: artist
            )
        case .searchArtist:
            return collectionView.dequeueConfiguredReusableCell(
                using: searchArtistCellRegistration,
                for: indexPath,
                item: ()
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
