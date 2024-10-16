//
//  NoteCommentsViewController.swift
//  FeatureHomeInterface
//
//  Created by 황인우 on 9/8/24.
//


import Combine
import UIKit

import Domain
import Shared

public protocol NoteCommentsViewControllerDelegate: AnyObject {
    func popViewController()
    func pushReportViewController(noteID: Int?, commentID: Int?)
    func presentEditNoteViewController(note: Note)
    func presentUserLinkedWebViewController(url: URL)
}

public final class NoteCommentsViewController: UIViewController, CommentMenuHandling, NoteMenuHandling, NoteMusicHandling {
    private let viewModel: NoteCommentsViewModel
    
    private var cancellables: Set<AnyCancellable> = .init()
    
    @KeychainWrapper(.userInfo)
    public var userInfo: UserInformation?
    
    public weak var coordinator: NoteCommentsViewControllerDelegate?

    // MARK: - Menu Subjects
    
    public var onReportNote: PassthroughSubject<Int, Never> = .init()
    public var onEditNote: PassthroughSubject<Note, Never> = .init()
    public var onDeleteNote: PassthroughSubject<Int, Never> = .init()
    
    public var onReportComment: PassthroughSubject<Int, Never> = .init()
    public var onDeleteComment: PassthroughSubject<Int, Never> = .init()
    
    // MARK: - UI Components
    
    private let noteCommentsView = NoteCommentsView()
    
    // MARK: - DiffableDataSource
    
    private typealias NoteCommentsDataSource = UICollectionViewDiffableDataSource<Section, Row>
    
    enum Section: Int, Hashable {
        case note = 0
        case comments = 1
    }
    
    enum Row: Hashable {
        case note(Note)
        case emptyNote
        case comment(Comment)
        case emptyComment
    }
    
    private lazy var noteCommentsDataSource: NoteCommentsDataSource = {
        let emptyNoteCellRegistration = UICollectionView.CellRegistration<EmptyNoteCell, Void> { cell, indexPath, item in }
        let noteCellRegistration = UICollectionView.CellRegistration<NoteCell, Note> { [weak self] cell, index, note in
            guard let self = self else { return }
            
            cell.configure(
                with: note,
                showsFullNoteContents: true,
                isHyperLinkTouchable: true
            )
            
            cell.likeNoteButton.publisher(for: .touchUpInside)
                .sink { control in
                    self.viewModel.setNoteLikeState(
                        noteID: note.id,
                        isLiked: control.isSelected
                    )
                }
                .store(in: &cell.cancellables)
            
            cell.bookmarkButton.publisher(for: .touchUpInside)
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
            
            cell.onTapHyperLinkPublisher
                .throttle(
                    for: .milliseconds(600),
                    scheduler: DispatchQueue.main,
                    latest: false
                )
                .sink { [weak self] url in
                    self?.coordinator?.presentUserLinkedWebViewController(url: url)
                }
                .store(in: &cell.cancellables)
        }
        let emptyCommentCellRegistration = UICollectionView.CellRegistration<EmptyCommentCell, Void> { cell, indexPath, item in }
        let commentCellRegistration = UICollectionView.CellRegistration<CommentCell, Comment> { [weak self] cell, indexPath, comment in
            guard let self = self else { return }
            
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
                .store(in: &cell.cancellables)
        }
        
        let dataSource = NoteCommentsDataSource(collectionView: self.noteCommentsCollectionView) { collectionView, indexPath, item in
            return item.dequeueConfiguredReusableCell(
                collectionView: collectionView,
                emptyNoteCellRegistration: emptyNoteCellRegistration,
                noteCellRegistration: noteCellRegistration,
                commentCellRegistration: commentCellRegistration,
                emptyCommentCellRegistration: emptyCommentCellRegistration,
                indexPath: indexPath
            )
        }
        
        let commentHeaderRegistration = UICollectionView.SupplementaryRegistration<CommentHeaderView>(elementKind: CommentHeaderView.reuseIdentifier) { [weak self] commentHeaderView, elementKind, indexPath in
            guard let self = self else { return }
            
            self.viewModel.$commentsCount
                .sink { updatedCommentCount in
                    commentHeaderView.configureCommentCount(updatedCommentCount)
                }
                .store(in: &self.cancellables)
            
        }
        
        dataSource.supplementaryViewProvider = { [weak self] (collectionView, kind, indexPath) in
            switch indexPath.section {
            case NoteCommentsView.commentsSectionIndex:
                if kind == CommentHeaderView.reuseIdentifier {
                    let commentHeaderView = collectionView.dequeueConfiguredReusableSupplementary(
                        using: commentHeaderRegistration,
                        for: indexPath
                    )
                    
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
        
        self.hidesBottomBarWhenPushed = true
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
        
        noteCommentsDataSource.applySnapshotUsingReloadData(snapshot)
    }

    func updateComments(_ comments: [Comment]) {
        var snapshot = noteCommentsDataSource.snapshot()
        
        let newItems = comments.map { Row.comment($0) }
        
        // 노트 섹션 업데이트
        if snapshot.sectionIdentifiers.contains(.comments) {
            let currentItems = snapshot.itemIdentifiers(inSection: .comments)
            
            if newItems.isEmpty {
                snapshot.deleteItems(currentItems)
                snapshot.appendItems([.emptyComment], toSection: .comments)
            } else {
                snapshot.deleteItems(currentItems)
                snapshot.appendItems(newItems, toSection: .comments)
            }
            let isCountDifferent = currentItems.count != newItems.count
            
            guard let refreshControl = self.noteCommentsCollectionView.refreshControl else {
                // pull-to-refresh가 없는 경우 apply snapshot만 적용. 갯수가 달라질때만 animation
                noteCommentsDataSource.apply(
                    snapshot,
                    animatingDifferences: isCountDifferent
                )
                return
            }
            // pull-to-refresh 중일 경우 reloadData를 활용하여 apply snapshot에 의해서 생기는 bounce 방지
            if refreshControl.isRefreshing {
                noteCommentsDataSource.applySnapshotUsingReloadData(snapshot)
            } else {
                // 그 외의 경우 apply snapshot 활용. 기존 데이터와 신규 데이터의 갯수가 달라질 때만 animation
                noteCommentsDataSource.apply(snapshot, animatingDifferences: isCountDifferent)
            }
            
        } else {
            // 노트 섹션이 처음 추가될 때
            snapshot.appendSections([.comments])
            let currentItems = snapshot.itemIdentifiers(inSection: .comments)
            if newItems.isEmpty {
                snapshot.deleteItems(currentItems)
                snapshot.appendItems([.emptyComment], toSection: .comments)
            } else {
                snapshot.deleteItems(currentItems)
                snapshot.appendItems(newItems, toSection: .comments)
            }
            
            noteCommentsDataSource.applySnapshotUsingReloadData(snapshot)
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
            .sink { [weak self] fetchedNotes in
                self?.updateNote(fetchedNotes)
            }
            .store(in: &cancellables)
        
        viewModel.$fetchedComments
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
        
        onReportComment.eraseToAnyPublisher()
            .sink { [weak self] commentID in
                self?.coordinator?.pushReportViewController(noteID: nil, commentID: commentID)
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

        backButton.publisher(for: .touchUpInside)
            .sink { [weak self] _ in
                self?.coordinator?.popViewController()
            }
            .store(in: &cancellables)
    }
}

// MARK: - NoteCommentView

private extension NoteCommentsViewController {
    var writeCommentView: WriteCommentView {
        return self.noteCommentsView.writeCommentView
    }
    
    var noteCommentsCollectionView: UICollectionView {
        return self.noteCommentsView.noteCommentsCollectionView
    }

    var backButton: UIButton {
        return self.noteCommentsView.backButton
    }
}

private extension NoteCommentsViewController.Row {
    func dequeueConfiguredReusableCell(
        collectionView: UICollectionView,
        emptyNoteCellRegistration: UICollectionView.CellRegistration<EmptyNoteCell, Void>,
        noteCellRegistration: UICollectionView.CellRegistration<NoteCell, Note>,
        commentCellRegistration: UICollectionView.CellRegistration<CommentCell, Comment>,
        emptyCommentCellRegistration: UICollectionView.CellRegistration<EmptyCommentCell, Void>,
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
            
        case .comment(let comment):
            return collectionView.dequeueConfiguredReusableCell(
                using: commentCellRegistration,
                for: indexPath,
                item: comment
            )
            
        case .emptyComment:
            return collectionView.dequeueConfiguredReusableCell(
                using: emptyCommentCellRegistration,
                for: indexPath,
                item: ()
            )
        }
    }
}

// MARK: - HyperLink

private extension NoteCommentsViewController {
    
}
