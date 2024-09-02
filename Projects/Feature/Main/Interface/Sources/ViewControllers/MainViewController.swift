//
//  MainViewController.swift
//  FeatureMainInterface
//
//  Created by 황인우 on 8/11/24.
//

import Domain
import Shared

import Combine
import UIKit

public class MainViewController: UIViewController {
    var viewModel: MainViewModel
    
    private var cancellables: Set<AnyCancellable> = .init()
    
    // MARK: - Keychain
    @KeychainWrapper<UserInformation>(.userInfo)
    var userInfo
    
    // MARK: - UI Components
    
    private var mainView: MainView = .init()
    
    
    // MARK: - NoteMenu Subjects
    
    let onReportNote: PassthroughSubject<Int, Never> = .init()
    let onEditNote: PassthroughSubject<Int, Never> = .init()
    let onDeleteNote: PassthroughSubject<Int, Never> = .init()
    
    // MARK: - Init
    
    public init(viewModel: MainViewModel) {
        self.viewModel = viewModel
        
        super.init(nibName: nil, bundle: .main)
    }
    
    @available(*, unavailable)
    required public init?(coder: NSCoder) {
        fatalError()
    }
    
    public override func loadView() {
        self.view = mainView
    }
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        
        self.setUpDelegates()
        self.viewModel.fetchNotes(isInitialFetch: true)
        self.viewModel.fetchFavoriteArtists(isInitialFetch: true)
        
        self.bindUI()
        self.bindAction()
    }
    
    private func setUpDelegates() {
        mainView.mainCollectionView.delegate = self
        mainView.mainCollectionView.dataSource = self
    }
}

private extension MainViewController {
    
    // MARK: - Bindings
    
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
                    self?.mainCollectionView.refreshControl?.endRefreshing()
                    
                default:
                    return
                }
            })
            .store(in: &cancellables)
        
        Publishers.CombineLatest(
            viewModel.$fetchedNotes,
            viewModel.$fetchedFavoriteArtists
        )
        .sink { [weak self] _ in
            self?.mainCollectionView.reloadData()
        }
        .store(in: &cancellables)
    }
    
    func bindAction() {
        mainCollectionView.didScrollToBottomPublisher()
            .sink { [viewModel] in
                viewModel.fetchNotes(isInitialFetch: false)
            }
            .store(in: &cancellables)
        
        mainCollectionView.refreshControl?.isRefreshingPublisher
            .filter { $0 == true }
            .sink(receiveValue: { [viewModel] _ in
                viewModel.refreshAllData()
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
                    rightActionCompletion: {
                        self?.viewModel.deleteNote(id: noteID)
                    })
            }
            .store(in: &cancellables)
    }
}

private extension MainViewController {
    var mainCollectionView: UICollectionView {
        return self.mainView.mainCollectionView
    }
}

extension MainViewController: UICollectionViewDelegate {
    
}

extension MainViewController: UICollectionViewDataSource {
    public func numberOfSections(in collectionView: UICollectionView) -> Int {
        let totalSectionIndice = [
            MainView.bannerSectionIndex,
            MainView.favoriteArtistSectionIndex,
            MainView.notesSectionIndex
        ]
        
        return totalSectionIndice.count
    }
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch section {
        case MainView.bannerSectionIndex:
            return 1
            
        case MainView.favoriteArtistSectionIndex:
            // 찾아보기 cell 포함한 갯수이기에 1을 더한다.
            return viewModel.fetchedFavoriteArtists.count + 1
            
        case MainView.notesSectionIndex:
            return viewModel.fetchedNotes.isEmpty
            ? 1     // EmptyNoteCell
            : viewModel.fetchedNotes.count
            
        default:
            return 0
        }
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch indexPath.section {
        case MainView.bannerSectionIndex:
            let cell = collectionView.dequeueReusableCell(
                for: indexPath,
                cellType: BannerCell.self
            )
            
            return cell
            
        case MainView.favoriteArtistSectionIndex:
            let searchArtistItemIndex = 0
            let searchArtistItemCount = 1
            
            if indexPath.item == searchArtistItemIndex {
                let cell = collectionView.dequeueReusableCell(
                    for: indexPath,
                    cellType: SearchArtistCell.self
                )
                
                return cell
                
            } else {
                let cell = collectionView.dequeueReusableCell(
                    for: indexPath,
                    cellType: FeelinArtistCell.self
                )
                let artist = self.viewModel.fetchedFavoriteArtists[indexPath.item - searchArtistItemCount]
                cell.configure(
                    artistName: artist.name,
                    artistImageURL: try? artist.imageSource?.asURL()
                )
                
                return cell
            }
            
        case MainView.notesSectionIndex:
            if viewModel.fetchedNotes.isEmpty {
                let cell = collectionView.dequeueReusableCell(
                    for: indexPath,
                    cellType: EmptyNoteCell.self
                )
                
                return cell
                
            } else {
                let cell = collectionView.dequeueReusableCell(
                    for: indexPath,
                    cellType: NoteCell.self
                )
                let note = viewModel.fetchedNotes[indexPath.item]
                cell.configure(with: note)
                
                cell.likeNoteButton.publisher(for: .touchUpInside)
                    // 0.6초 사이에 발생한 가장 최신 좋아요 상태만 방출
                    .debounce(
                        for: .milliseconds(600),
                        scheduler: DispatchQueue.main
                    )
                    .sink { [weak viewModel] control in
                        viewModel?.setNoteLikeState(
                            noteID: note.id,
                            isLiked: control.isSelected
                        )
                    }
                    .store(in: &cancellables)
                
                cell.bookmarkButton.publisher(for: .touchUpInside)
                    .debounce(
                        for: .milliseconds(600),
                        scheduler: DispatchQueue.main
                    )
                    .sink { [weak viewModel] control in
                        viewModel?.setNoteBookmarkState(
                            noteID: note.id,
                            isBookmarked: control.isSelected
                        )
                    }
                    .store(in: &cancellables)
                
                cell.moreAboutContentButton.publisher(for: .touchUpInside)
                    .sink { [weak self] _ in
                        if let noteMenuViewController = self?.makeNoteMenuViewController(checking: note) {
                            self?.present(noteMenuViewController, animated: false)
                        } else {
                            // TODO: - 비회원 알림을 추후 보여줘야 한다.
                        }
                    }
                    .store(in: &cancellables)
                
                return cell
            }
            
        default:
            return UICollectionViewCell()
        }
    }
    
    public func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        switch indexPath.section {
        case MainView.favoriteArtistSectionIndex:
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
            
        case MainView.notesSectionIndex:
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
}

// MARK: - Note Menu

private extension MainViewController {
    func makeNoteMenuViewController(checking note: Note) -> NoteMenuViewConroller? {
        if let userId = self.userInfo?.userID {
            let bottomSheetHeight: CGFloat = userId == note.publisher.id
            ? 180
            : 130
            
            let menuType = userId == note.publisher.id
            ? NoteMenuType.me
            : NoteMenuType.other
            
            let noteMenuViewController = NoteMenuViewConroller(
                noteID: note.id,
                bottomSheetHeight: bottomSheetHeight,
                bottomSheetView: NoteMenuView(menuType: menuType),
                onReport: self.onReportNote,
                onEdit: self.onEditNote,
                onDelete: self.onDeleteNote
            )
            noteMenuViewController.modalPresentationStyle = .overFullScreen
            
            return noteMenuViewController
        }
        
        return nil
    }
}
