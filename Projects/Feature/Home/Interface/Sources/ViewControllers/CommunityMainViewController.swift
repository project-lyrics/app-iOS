//
//  CommunityMainViewController.swift
//  FeatureHomeInterface
//
//  Created by 황인우 on 10/1/24.
//

import Domain
import FlexLayout
import Shared

import Combine
import UIKit

public protocol CommunityMainViewControllerDelegate: AnyObject {
    func popViewController()
    func pushReportViewController(noteID: Int?, commentID: Int?)
    func presentEditNoteViewController(note: Note)
    func pushNoteNotificationViewController()
    func pushNoteCommentsViewController(noteID: Int)
    func presentPostNoteViewController(artistID: Int)
}

public final class CommunityMainViewController: UIViewController, NoteMenuHandling, NoteMusicHandling {
    public weak var coordinator: CommunityMainViewControllerDelegate?

    private var viewModel: CommunityMainViewModel

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
        button.setImage(FeelinImages.back, for: .normal)

        return button
    }()

    private let notificationButton: UIButton = {
        let button = UIButton()
        button.setImage(FeelinImages.notificationOff, for: .normal)

        return button
    }()

    private lazy var titleLabel: UILabel = { [unowned self] in
        let label = UILabel()
        label.text = "\(self.viewModel.artist.name) 레코드"
        label.font = SharedDesignSystemFontFamily.Pretendard.bold.font(size: 18)
        label.textColor = Colors.gray09

        return label
    }()

    private let postNoteButton: UIButton = {
        let button = UIButton()
        button.setImage(FeelinImages.writingInactive, for: .normal)

        return button
    }()

    // MARK: - NoteMenu Subjects

    public let onReportNote: PassthroughSubject<Int, Never> = .init()
    public let onEditNote: PassthroughSubject<Note, Never> = .init()
    public let onDeleteNote: PassthroughSubject<Int, Never> = .init()

    // MARK: - DiffableDataSource

    private typealias CommunityMainDataSource = UICollectionViewDiffableDataSource<Section, Row>

    enum Section: Hashable {
        case artist
        case notes
    }

    enum Row: Hashable {
        case artist(Artist)
        case note(Note)
        case emptyNote
    }

    private lazy var communityMainDataSource: CommunityMainDataSource = {
        let communityArtistCellRegistration = UICollectionView.CellRegistration<CommunityArtistCell, Artist> { [weak self] cell, index, artist in
            guard let self = self else { return }
            
            cell.configure(artist)

            cell.favoriteArtistSelectButton.publisher(for: .touchUpInside)
                .sink { control in
                    self.viewModel.setFavoriteArtist(control.isSelected)
                }
                .store(in: &cell.cancellables)
            
        }
        
        let emptyNoteCellRegistration = UICollectionView.CellRegistration<EmptyNoteCell, Void> { cell, indexPath, item in }
        
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
                .sink { _ in
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
        
        let dataSource = CommunityMainDataSource(collectionView: self.communityMainCollectionView) { [weak self] collectionView, indexPath, item in
            guard let self = self else {
                return nil
            }

            return item.dequeueConfiguredReusableCell(
                collectionView: collectionView,
                communityArtistCellRegistration: communityArtistCellRegistration,
                emptyNoteCellRegistration: emptyNoteCellRegistration,
                noteCellRegistration: noteCellRegistration,
                indexPath: indexPath
            )
        }
        
        let communityNoteHeaderRegistration = UICollectionView.SupplementaryRegistration<CommunityNoteHeaderView>(elementKind: CommunityNoteHeaderView.reuseIdentifier) { [weak self] communityNoteHeaderView, elementKind, indexPath in
            guard let self = self else { return }
            communityNoteHeaderView.includeNoteButton.publisher(for: .touchUpInside)
                .map(\.isSelected)
                .sink { isSelected in
                    self.viewModel.mustHaveLyrics = isSelected
                }
                .store(in: &communityNoteHeaderView.cancellables)
        }

        dataSource.supplementaryViewProvider = { [unowned self] (collectionView, kind, indexPath) in
            switch kind {
            case CommunityNoteHeaderView.reuseIdentifier:
                let communityNoteHeaderView = collectionView.dequeueConfiguredReusableSupplementary(
                    using: communityNoteHeaderRegistration,
                    for: indexPath
                )

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
        self.setUpNavigationBar()
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

    private func setUpNavigationBar() {
        self.navigationBar.addLeftBarView([backButton])
        self.navigationBar.addTitleView(titleLabel)
        self.navigationBar.addRightBarView([notificationButton])
        self.navigationBar.changeBackgroundColor(.clear)
        self.navigationBar.hideTitleView(true)
    }

    private func setUpLayout() {
        self.view.backgroundColor = Colors.background
        self.view.addSubview(flexContainer)
        let tabBarHeight = self.tabBarController?.tabBar.frame.height ?? 0
        let postNoteButtonHeight: CGFloat = 56
        
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
                .width(UIScreen.main.bounds.width - 20)
                .marginLeft(10)
                .height(self.navigationBarHeight)
                .top(UIApplication.shared.safeAreaInsets.top)
            
            flex.addItem(postNoteButton)
                .size(postNoteButtonHeight)
                .position(.absolute)
                .bottom(tabBarHeight + 20)
                .right(20)
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

        } else {
            let currentItems = snapshot.itemIdentifiers(inSection: .artist)
            snapshot.deleteItems(currentItems)
            snapshot.appendItems([.artist(artist)], toSection: .artist)
        }
        communityMainDataSource.applySnapshotUsingReloadData(snapshot)
    }

    private var shouldUpdate: Bool = true

    private func updateNotesUI(_ notes: [Note]) {
        var snapshot = communityMainDataSource.snapshot()
        
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
            
            guard let refreshControl = self.communityMainCollectionView.refreshControl else {
                // pull-to-refresh가 없는 경우 apply snapshot만 적용. 갯수가 달라질때만 animation
                communityMainDataSource.apply(
                    snapshot,
                    animatingDifferences: isCountDifferent
                )
                return
            }
            // pull-to-refresh 중일 경우 reloadData를 활용하여 apply snapshot에 의해서 생기는 bounce 방지
            if refreshControl.isRefreshing {
                communityMainDataSource.applySnapshotUsingReloadData(snapshot)
            } else {
                // 그 외의 경우 apply snapshot 활용. 기존 데이터와 신규 데이터의 갯수가 달라질 때만 animation
                communityMainDataSource.apply(
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
            
            communityMainDataSource.applySnapshotUsingReloadData(snapshot)
        }
    }
}

// MARK: - Bindings

private extension CommunityMainViewController {
    func bindUI() {
        self.viewModel.$artist
            .sink { [weak self] updatedArtist in
                self?.updateArtistUI(updatedArtist)
            }
            .store(in: &cancellables)

        self.viewModel.$fetchedNotes
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
                    self?.communityMainCollectionView.refreshControl?.endRefreshing()

                default:
                    return
                }
            })
            .store(in: &cancellables)
        
        viewModel.$artist
            .map(\.isFavorite)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] isFavorite in
                guard let self = self else { return }
                postNoteButton.isEnabled = isFavorite

                let image = isFavorite ? FeelinImages.writingActive : FeelinImages.writingInactive

                postNoteButton.setImage(image, for: .normal)
            }
            .store(in: &cancellables)

        viewModel.$hasUncheckedNotification
            .sink { [weak self] hasUncheckedNotification in
                hasUncheckedNotification
                ? self?.notificationButton.setImage(FeelinImages.notificationOn, for: .normal)
                : self?.notificationButton.setImage(FeelinImages.notificationOff, for: .normal)
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

        communityMainCollectionView.publisher(for: [.didSelectItem])
            .sink { [weak self] indexPath in
                guard let self = self else { return }

                // 해당 indexPath에 맞는 item을 dataSource에서 가져옴
                guard let item = self.communityMainDataSource.itemIdentifier(for: indexPath) else { return }
                
                switch item {
                case .note(let note):
                    coordinator?.pushNoteCommentsViewController(noteID: note.id)

                default:
                    break
                }
            }
            .store(in: &cancellables)

        communityMainCollectionView.refreshControl?.isRefreshingPublisher
            .filter { $0 }
            .sink(receiveValue: { [weak viewModel] _ in
                viewModel?.getArtistNotes(isInitial: true)
            })
            .store(in: &cancellables)

        backButton.publisher(for: .touchUpInside)
            .sink { [weak self] _ in
                self?.coordinator?.popViewController()
            }
            .store(in: &cancellables)

        notificationButton.publisher(for: .touchUpInside)
            .sink { [weak self] _ in
                self?.coordinator?.pushNoteNotificationViewController()
            }
            .store(in: &cancellables)

        postNoteButton.publisher(for: .touchUpInside)
            .sink { [weak self] _ in
                guard let self = self else { return }
                coordinator?.presentPostNoteViewController(artistID: viewModel.artist.id)
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
                    rightActionTitle: "삭제",
                    rightActionCompletion: {
                        self?.viewModel.deleteNote(id: noteID)
                    })
            }
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

private extension CommunityMainViewController.Row {
    func dequeueConfiguredReusableCell(
        collectionView: UICollectionView,
        communityArtistCellRegistration: UICollectionView.CellRegistration<CommunityArtistCell, Artist>,
        emptyNoteCellRegistration: UICollectionView.CellRegistration<EmptyNoteCell, Void>,
        noteCellRegistration: UICollectionView.CellRegistration<NoteCell, Note>,
        indexPath: IndexPath
    ) -> UICollectionViewCell {
        switch self {
        case .artist(let artist):
            return collectionView.dequeueConfiguredReusableCell(
                using: communityArtistCellRegistration,
                for: indexPath,
                item: artist
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
