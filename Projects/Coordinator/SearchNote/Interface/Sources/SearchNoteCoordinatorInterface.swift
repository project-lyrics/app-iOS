//
//  SearchNoteCoordinatorInterface.swift
//  CoordinatorSearchNoteInterface
//
//  Created by Derrick kim on 10/6/24.
//

import UIKit

import CoordinatorAppInterface
import FeatureHomeInterface
import DependencyInjection
import Domain
import Shared
import Core

public final class SearchNoteCoordinator: Coordinator {
    public weak var delegate: CoordinatorDelegate?
    public var navigationController: UINavigationController
    public var childCoordinators: [Coordinator]

    public init(navigationController: UINavigationController) {
        self.navigationController = navigationController
        self.childCoordinators = []
    }

    public func start() {
        registerSearchNoteDI()
        configureSearchNoteViewController()
    }

    private func registerSearchNoteDI() {
        DIContainer.registerNetworkProvider(hasTokenStorage: true)

        DIContainer.standard.register(.noteAPIService) { resolver in
            let networkProvider = try resolver.resolve(.networkProvider)
            return NoteAPIService(networkProvider: networkProvider)
        }

        DIContainer.registerReportNoteService()
    }

    private func configureSearchNoteViewController() {
        @KeychainWrapper<UserInformation>(.userInfo)
        var userInfo
        // 테스트용 유저 아이디
        userInfo = .init(userID: 1)

        let searchNoteViewModel = searchNoteDependencies()
        let viewController = SearchNoteViewController(viewModel: searchNoteViewModel)
        viewController.coordinator = self
        navigationController.pushViewController(viewController, animated: true)
    }
}

// MARK: Search Note

extension SearchNoteCoordinator: SearchNoteViewControllerDelegate,
                                 NoteDetailViewControllerDelegate,
                                 ReportViewControllerDelegate,
                                 NoteCommentsViewControllerDelegate {
    public func popViewController(isHiddenTabBar: Bool) {
        navigationController.tabBarController?.tabBar.isHidden = isHiddenTabBar
        popViewController()
    }

    public func pushNoteDetailViewController(selectedNote: SearchedNote) {
        let viewModel = noteDetailDependencies(selectedNote: selectedNote)
        let viewController = NoteDetailViewController(viewModel: viewModel)
        viewController.coordinator = self

        navigationController.tabBarController?.tabBar.isHidden = true
        navigationController.pushViewController(viewController, animated: true)
    }

    public func pushReportViewController(noteID: Int?, commentID: Int?) {
        DIContainer.registerReportNoteService()

        let viewModel = reportNoteDependencies(noteID: noteID, commentID: commentID)
        let reportViewController = ReportViewController(viewModel: viewModel)
        reportViewController.coordinator = self
        navigationController.tabBarController?.tabBar.isHidden = true
        navigationController.pushViewController(reportViewController, animated: true)
    }

    public func presentEditNoteViewController(note: Note) {

    }

    public func pushNoteCommentsViewController(noteID: Int) {
        let viewModel = noteCommentsDependencies(noteID: noteID)
        let noteCommentsViewController = NoteCommentsViewController(viewModel: viewModel)
        noteCommentsViewController.coordinator = self
        navigationController.tabBarController?.tabBar.isHidden = true
        navigationController.pushViewController(noteCommentsViewController, animated: true)
    }
}

private extension SearchNoteCoordinator {
    func searchNoteDependencies() -> SearchNoteViewModel {
        @Injected(.noteAPIService) var noteAPiService: NoteAPIServiceInterface

        let getSearchedNoteUseCase = GetSearchedNotesUseCase(
            noteAPIService: noteAPiService,
            searchedNotePaginationService: SearchedNotePaginationService()
        )

        let viewModel = SearchNoteViewModel(getSearchedNotesUseCase: getSearchedNoteUseCase)
        return viewModel
    }

    func noteDetailDependencies(selectedNote: SearchedNote) -> NoteDetailViewModel {
        @Injected(.noteAPIService) var noteAPIService: NoteAPIServiceInterface

        let getSongNotesUseCase = GetSongNotesUseCase(
            noteAPIService: noteAPIService,
            notePaginationService: NotePaginationService()
        )

        let setNoteLikeUseCase = SetNoteLikeUseCase(noteAPIService: noteAPIService)

        let setBookmarkUseCase = SetBookmarkUseCase(noteAPIService: noteAPIService)

        let deleteNoteUseCase = DeleteNoteUseCase(noteAPIService: noteAPIService)

        let viewModel = NoteDetailViewModel(
            selectedNote: selectedNote,
            getSongNotesUseCase: getSongNotesUseCase,
            setNoteLikeUseCase: setNoteLikeUseCase,
            setBookmarkUseCase: setBookmarkUseCase,
            deleteNoteUseCase: deleteNoteUseCase
        )

        return viewModel
    }

    func reportNoteDependencies(noteID: Int?, commentID: Int?) -> ReportViewModel {
        @Injected(.reportAPIService) var reportNoteService: ReportAPIServiceInterface
        let reportNoteUseCase: ReportNoteUseCaseInterface = ReportNoteUseCase(reportAPIService: reportNoteService)

        let viewModel = ReportViewModel(
            noteID: noteID,
            commentID: commentID,
            reportNoteUseCase: reportNoteUseCase
        )

        return viewModel
    }

    func noteCommentsDependencies(noteID: Int) -> NoteCommentsViewModel {
        DIContainer.standard.register(.commentAPIService) { resolver in
            let networkProvider = try resolver.resolve(.networkProvider)
            return CommentAPIService(networkProvider: networkProvider)
        }

        @Injected(.noteAPIService) var noteAPIService: NoteAPIServiceInterface
        @Injected(.commentAPIService) var commentAPIService: CommentAPIServiceInterface

        let setNoteLikeUseCase = SetNoteLikeUseCase(noteAPIService: noteAPIService)
        let setBookmarkUseCase = SetBookmarkUseCase(noteAPIService: noteAPIService)
        let deleteNoteUseCase = DeleteNoteUseCase(noteAPIService: noteAPIService)
        let getNoteWithCommentsUseCase = GetNoteWithCommentsUseCase(commentAPIService: commentAPIService)
        let writeCommentUseCase = WriteCommentUseCase(commentAPIService: commentAPIService)
        let deleteCommentUseCase = DeleteCommentUseCase(commentAPIService: commentAPIService)

        let viewModel = NoteCommentsViewModel(
            noteID: noteID,
            setNoteLikeUseCase: setNoteLikeUseCase,
            setBookmarkUseCase: setBookmarkUseCase,
            deleteNoteUseCase: deleteNoteUseCase,
            getNoteWithCommentsUseCase: getNoteWithCommentsUseCase,
            writeCommentUseCase: writeCommentUseCase,
            deleteCommentUseCase: deleteCommentUseCase
        )

        return viewModel
    }
}
