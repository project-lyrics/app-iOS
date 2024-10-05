//
//  CommunityMainViewController.swift
//  FeatureMainInterface
//
//  Created by 황인우 on 10/1/24.
//

import Domain
import FlexLayout
import Shared

import Combine
import UIKit

public final class CommunityMainViewController: UIViewController, NoteMenuHandling, NoteMusicHandling {
    var viewModel: CommunityMainViewModel
    
    private var cancellables: Set<AnyCancellable> = .init()
    private let navigationBarHeight: CGFloat = 44
    
    // MARK: - Keychain
    
    @KeychainWrapper<UserInformation>(.userInfo)
    public var userInfo
    
    // MARK: - UI Components
    
    private let flexContainer = UIView()
    private let communityMainView: CommunityMainView = .init()
    private let navigationBar = NavigationBar()
    
    private let navigationBackgroundView = UIView()
    
    private let backButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(FeelinImages.backLight, for: .normal)

        return button
    }()
    
    private let notificationButton: UIButton = {
        let button = UIButton()
        button.setImage(FeelinImages.notificationLightOff, for: .normal)
        
        return button
    }()
    
    private lazy var titleLabel: UILabel = { [unowned self] in
        let label = UILabel()
        label.text = "\(self.viewModel.artist.name) 레코드"
        label.font = SharedDesignSystemFontFamily.Pretendard.bold.font(size: 18)
        label.textColor = Colors.gray09
        
        return label
    }()
    
    // MARK: - NoteMenu Subjects
    
    public let onReportNote: PassthroughSubject<Int, Never> = .init()
    public let onEditNote: PassthroughSubject<Int, Never> = .init()
    public let onDeleteNote: PassthroughSubject<Int, Never> = .init()
    
    // MARK: - DiffableDataSource
    
    private typealias CommunityMainDataSource = UICollectionViewDiffableDataSource<Section, Row>
    
    private enum Section: Hashable {
        case artist
        case notes
    }
    
    private enum Row: Hashable {
        case artist(Artist)
        case note(Note)
        case emptyNote
    }
    
    private lazy var communityMainDataSource: CommunityMainDataSource = {
        let dataSource = CommunityMainDataSource(collectionView: self.communityMainCollectionView) { [weak self] collectionView, indexPath, item in
            guard let self = self else {
                return nil
            }
            
            switch item {
            case .artist(let artist):
                let cell = collectionView.dequeueReusableCell(
                    for: indexPath,
                    cellType: CommunityArtistCell.self
                )
                
                cell.configure(self.viewModel.artist)
                
                cell.favoriteArtistSelectButton.publisher(for: .touchUpInside)
                    .debounce(
                        for: .milliseconds(600),
                        scheduler: DispatchQueue.main
                    )
                    .sink { control in
                        self.viewModel.setFavoriteArtist(control.isSelected)
                    }
                    .store(in: &cancellables)
                
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
                        self?.viewModel.setNoteLikeState(
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
                    .sink { _ in
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
                    .sink { _ in
                        self.openYouTube(query: "\(note.song.artist.name) \(note.song.name)")
                    }
                    .store(in: &self.cancellables)
                
                return cell
            }
        }
        
        dataSource.supplementaryViewProvider = { [unowned self] (collectionView, kind, indexPath) in
            switch kind {
            case CommunityNoteHeaderView.reuseIdentifier:
                let communityNoteHeaderView = collectionView.dequeueReusableSupplementaryView(
                    ofKind: kind,
                    for: indexPath,
                    viewType: CommunityNoteHeaderView.self
                )
                
                communityNoteHeaderView.includeNoteButton.publisher(for: .touchUpInside)
                    .map(\.isSelected)
                    .assign(to: &viewModel.$mustHaveLyrics)
                
                return communityNoteHeaderView
                
            default:
                return UICollectionReusableView()
            }
        }
        
        return dataSource
    }()

    // MARK: - Init
    
    public init(viewModel: CommunityMainViewModel) {
        self.viewModel = viewModel
        
        super.init(nibName: nil, bundle: .main)
    }
    
    @available(*, unavailable)
    required public init?(coder: NSCoder) {
        fatalError()
    }
    
    // MARK: - View Lifecycle
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        self.setUpNagivationBar()
        self.setUpLayout()
        self.bindUI()
        self.bindAction()
    }
    
    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    public override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        flexContainer.pin.all()
        flexContainer.flex.layout()
    }
    
    // MARK: - SetUp
    
    private func setUpNagivationBar() {
        self.navigationBar.addLeftBarView(backButton)
        self.navigationBar.addTitleView(titleLabel)
        self.navigationBar.addRightBarView(notificationButton)
        self.navigationBar.changeBackgroundColor(.clear)
        self.navigationBar.hideTitleView(true)
    }
    
    private func setUpLayout() {
        self.view.backgroundColor = Colors.background
        self.view.addSubview(flexContainer)
        
        flexContainer.flex.define { flex in
            flex.addItem(communityMainView)
                .top(-UIApplication.shared.safeAreaInsets.top)
                .grow(1)
            
            flex.addItem(navigationBackgroundView)
                .backgroundColor(Colors.background)
                .position(.absolute)
                .width(100%)
                .height(UIApplication.shared.safeAreaInsets.top)
            
            flex.addItem(navigationBar)
                .position(.absolute)
                .width(100%)
                .height(self.navigationBarHeight)
                .top(UIApplication.shared.safeAreaInsets.top)
        }
    }
    
    // MARK: - CollectionView Snapshot
    
    private func updateArtistUI(_ artist: Artist) {
        var snapshot = communityMainDataSource.snapshot()
        
        if !snapshot.sectionIdentifiers.contains(.artist) {
            snapshot.appendSections([.artist])
            snapshot.appendItems(
                [.artist(artist)],
                toSection: .artist
            )
            communityMainDataSource.apply(snapshot)
            
        } else {
            let currentItems = snapshot.itemIdentifiers(inSection: .artist)
            snapshot.deleteItems(currentItems)
            snapshot.appendItems([.artist(artist)], toSection: .artist)
            let newItems = snapshot.itemIdentifiers(inSection: .artist)
            snapshot.reconfigureItems(newItems)
            communityMainDataSource.apply(snapshot, animatingDifferences: false)
        }
    }
    
    private var shouldUpdate: Bool = true
    
    private func updateNotesUI(_ notes: [Note]) {
        // TODO: - 정상작동 X, 수정 필요 p1
        var snapshot = communityMainDataSource.snapshot()
        let newNoteItems = notes.map { Row.note($0) }
        
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
                if currentItems.contains(.emptyNote) {
                    snapshot.deleteItems([.emptyNote])
                }

                // 기존 노트 항목과 새로운 항목이 다를 경우 업데이트
                if currentItems != newNoteItems {
                    snapshot.deleteItems(currentItems)
                    snapshot.appendItems(newNoteItems, toSection: .notes)
                }
            }
            
            let itemCountChanged = notes.count != currentItems.count
            if !itemCountChanged {
                snapshot.reconfigureItems(newNoteItems)
            }
            
            communityMainDataSource.apply(snapshot, animatingDifferences: false)
            

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

            communityMainDataSource.apply(snapshot, animatingDifferences: false)
        }
        
        if self.communityMainCollectionView.refreshControl!.isRefreshing {
            self.communityMainCollectionView.refreshControl?.endRefreshing()
        }
        
    }
}

// MARK: - Bindings

private extension CommunityMainViewController {
    func bindUI() {
        self.viewModel.$artist
            .receive(on: DispatchQueue.main)
            .sink { [weak self] updatedArtist in
                self?.updateArtistUI(updatedArtist)
            }
            .store(in: &cancellables)
        
        self.viewModel.$fetchedNotes
            .receive(on: DispatchQueue.main)
            .sink { [weak self] updatedNotes in
                self?.updateNotesUI(updatedNotes)
            }
            .store(in: &cancellables)
        
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
        self.communityMainCollectionView.contentOffsetPublisher
            .removeDuplicates()
            .sink { [weak self] scrollOffset in
                self?.navigationBarOnScroll(yOffset: scrollOffset.y)
            }
            .store(in: &cancellables)
        
        communityMainCollectionView.didScrollToBottomPublisher()
            .sink { [weak viewModel] in
                viewModel?.getArtistNotes(isInitial: false)
            }
            .store(in: &cancellables)
        
        communityMainCollectionView.refreshControl?.isRefreshingPublisher
            .filter { $0 }
            .sink(receiveValue: { [weak viewModel] _ in
                viewModel?.getArtistNotes(isInitial: true)
                
            })
            .store(in: &cancellables)
    }
    
    private func navigationBarOnScroll(yOffset: CGFloat) {
        let artistSectionMaxYOffset = CommunityMainView.artistSectionHeight - UIApplication.shared.safeAreaInsets.top
        
        // 아티스트 섹션보다 더 스크롤 할 경우
        if yOffset >= artistSectionMaxYOffset {
            self.navigationBar.changeBackgroundColor(Colors.background)
            self.navigationBackgroundView.flex.backgroundColor(Colors.background)
            self.navigationBar.hideTitleView(false)
            self.navigationBar.hideRightBarView(true)
        } else {
            self.navigationBar.changeBackgroundColor(.clear)
            self.navigationBackgroundView.flex.backgroundColor(.clear)
            self.navigationBar.hideTitleView(true)
            self.navigationBar.hideRightBarView(false)
        }
    }
}

private extension CommunityMainViewController {
    var communityMainCollectionView: UICollectionView {
        return self.communityMainView.communityMainCollectionView
    }
}
