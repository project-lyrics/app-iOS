//
//  NoteCommentsViewController.swift
//  FeatureMainInterface
//
//  Created by 황인우 on 9/8/24.
//


import Combine
import UIKit

import Domain
import Shared

public final class NoteCommentsViewController: UIViewController, CommentMenuHandling, NoteMenuHandling, NoteMusicHandling {
    private let viewModel: NoteCommentsViewModel
    
    private var cancellables: Set<AnyCancellable> = .init()
    
    @KeychainWrapper(.userInfo)
    public var userInfo: UserInformation?
    
    // MARK: - Menu Subjects
    
    public var onReportNote: PassthroughSubject<Int, Never> = .init()
    public var onEditNote: PassthroughSubject<Int, Never> = .init()
    public var onDeleteNote: PassthroughSubject<Int, Never> = .init()
    
    public var onReportComment: PassthroughSubject<Int, Never> = .init()
    public var onDeleteComment: PassthroughSubject<Int, Never> = .init()
    
    // MARK: - UI Components
    
    private let noteCommentsView = NoteCommentsView()
    
    // MARK: - DiffableDataSource
    
    private typealias NoteCommentsDataSource = UICollectionViewDiffableDataSource<Section, Row>
    
    private enum Section: Int, Hashable {
        case note = 0
        case comments = 1
    }
    
    private enum Row: Hashable {
        case note(Note)
        case emptyNote
        case comment(Comment)
        case emptyComment
    }
    
    private lazy var noteCommentsDataSource: NoteCommentsDataSource = {
        let dataSource = NoteCommentsDataSource(collectionView: self.noteCommentsCollectionView) { collectionView, indexPath, item in
            switch item {
            case .emptyNote:
                let cell = collectionView.dequeueReusableCell(
                    for: indexPath,
                    cellType: EmptyNoteCell.self
                )
                
                return cell
                
            case .note(let note):
                let cell = collectionView.dequeueReusableCell(
                    for: indexPath,
                    cellType: NoteCell.self
                )
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
                
            case .comment(let comment):
                let cell = collectionView.dequeueReusableCell(for: indexPath, cellType: CommentCell.self)
                
                // 내부에 저장되어있는 유저id값과 댓글 저자의 id 값을 비교하여 신고 or 삭제 bottomSheet을 보여주는 로직
                if let userInfo = self.userInfo {
                    let commentBackgroundColor = userInfo.userID == comment.writer.id
                    ? Colors.backgroundTertiary
                    : Colors.background
                    cell.configureBackgroundColor(commentBackgroundColor)
                }
                
                cell.configure(with: comment)
                
                cell.moreAboutContentButton.publisher(for: .touchUpInside)
                    .sink { [unowned self] _ in
                        if let commentMenuViewController = self.makeCommentMenuViewController(checking: comment) {
                            self.present(commentMenuViewController, animated: false)
                        } else {
                            // TODO: - 비회원 알림을 추후 보여줘야 한다.
                        }
                    }
                    .store(in: &self.cancellables)
                
                return cell
                
            case .emptyComment:
                let cell = collectionView.dequeueReusableCell(for: indexPath, cellType: EmptyCommentCell.self)
                
                return cell
            }
        }
        
        dataSource.supplementaryViewProvider = { [weak self] (collectionView, kind, indexPath) in
            switch indexPath.section {
            case NoteCommentsView.commentsSectionIndex:
                if kind == CommentHeaderView.reuseIdentifier {
                    let commentHeaderView = collectionView.dequeueReusableSupplementaryView(
                        ofKind: kind,
                        for: indexPath,
                        viewType: CommentHeaderView.self
                    )
                    
                    guard let self = self else {
                        return UICollectionReusableView()
                    }
                    
                    self.viewModel.$commentsCount
                        .sink { updatedCommentCount in
                            commentHeaderView.configureCommentCount(updatedCommentCount)
                        }
                        .store(in: &self.cancellables)
                    
                    return commentHeaderView
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
    
    public init(viewModel: NoteCommentsViewModel) {
        self.viewModel = viewModel
        
        super.init(nibName: nil, bundle: .main)
    }
    
    @available(*, unavailable)
    required public init?(coder: NSCoder) {
        fatalError()
    }
    
    public override func loadView() {
        self.view = noteCommentsView
    }
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        self.fetchNoteWithComments()
        self.bindUI()
        self.bindAction()
    }
    
    private func fetchNoteWithComments() {
        self.viewModel.fetchNoteWithComments()
    }
}

// MARK: - CollectionView Snapshot

private extension NoteCommentsViewController {
    func updateNote(_ notes: [Note]) {
        var snapshot = noteCommentsDataSource.snapshot()
        
        if !snapshot.sectionIdentifiers.contains(.note) {
            snapshot.appendSections([.note])
        }
        
        let currentItems = snapshot.itemIdentifiers(inSection: .note)
        
        let noteItems = notes.map { Row.note($0) }
        
        if noteItems.isEmpty {
            snapshot.deleteItems(currentItems)
            snapshot.appendItems([.emptyNote], toSection: .note)
        } else {
            snapshot.deleteItems(snapshot.itemIdentifiers(inSection: .note)) // 기존 항목 삭제
            snapshot.appendItems(noteItems, toSection: .note)
        }
        
        noteCommentsDataSource.apply(snapshot, animatingDifferences: false)
    }

    
    func updateComments(_ comments: [Comment]) {
        var snapshot = noteCommentsDataSource.snapshot()
        
        if snapshot.sectionIdentifiers.contains(.comments) {
            let currentItems = snapshot.itemIdentifiers(inSection: .comments)
            
            if comments.isEmpty {
                if !currentItems.contains(.emptyComment) {
                    snapshot.deleteItems(currentItems)
                    snapshot.appendItems([.emptyComment], toSection: .comments)
                }
            } else {
                let newCommentItems = comments.map { Row.comment($0) }
                
                if currentItems.contains(.emptyComment) {
                    snapshot.deleteItems([.emptyComment])
                }
                
                if currentItems != newCommentItems {
                    snapshot.deleteItems(currentItems)
                    snapshot.appendItems(newCommentItems, toSection: .comments)
                }
            }
            
            // 애니메이션 적용 여부: 항목 개수가 바뀌었을 때만 애니메이션 적용
            let itemCountChanged = comments.count != currentItems.count
            noteCommentsDataSource.apply(snapshot, animatingDifferences: itemCountChanged)
            
        } else {
            // comment 섹션이 처음 추가될 때
            snapshot.appendSections([.comments])
            
            if comments.isEmpty {
                snapshot.appendItems([.emptyComment], toSection: .comments)
            } else {
                snapshot.appendItems(comments.map { Row.comment($0)}, toSection: .comments)
            }
            
            noteCommentsDataSource.apply(snapshot, animatingDifferences: false)
        }
    }
}


// MARK: - Bindigs

private extension NoteCommentsViewController {
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
        
        viewModel.$fetchedNotes
            .receive(on: DispatchQueue.main)
            .sink { [weak self] fetchedNotes in
                self?.updateNote(fetchedNotes)
            }
            .store(in: &cancellables)
        
        viewModel.$fetchedComments
            .receive(on: DispatchQueue.main)
            .sink { [weak self] fetchedComments in
                self?.updateComments(fetchedComments)
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
                    self?.noteCommentsCollectionView.refreshControl?.endRefreshing()
                    
                default:
                    return
                }
            })
            .store(in: &cancellables)
    }
    
    func bindAction() {
        noteCommentsCollectionView.refreshControl?.isRefreshingPublisher
            .filter { $0 }
            .sink(receiveValue: { [weak viewModel] _ in
                viewModel?.refreshNoteWithComments()
            })
            .store(in: &cancellables)
        
        writeCommentView.didTapSendPublisher
            .sink { [weak viewModel] commentToWrite in
                viewModel?.writeComment(comment: commentToWrite)
            }
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
        
        onReportComment.eraseToAnyPublisher()
            .sink { commentID in
                // TODO: - 추후 신고화면으로 이동
            }
            .store(in: &cancellables)
        
        onDeleteComment.eraseToAnyPublisher()
            .sink { [weak self] commentID in
                self?.showAlert(
                    title: "댓글을 삭제하시겠어요?",
                    message: nil,
                    rightActionTitle: "삭제",
                    rightActionCompletion: {
                        self?.viewModel.deleteComment(id: commentID)
                    })
            }
            .store(in: &cancellables)
    }
}

private extension NoteCommentsViewController {
    var writeCommentView: WriteCommentView {
        return self.noteCommentsView.writeCommentView
    }
    
    var noteCommentsCollectionView: UICollectionView {
        return self.noteCommentsView.noteCommentsCollectionView
    }
}
