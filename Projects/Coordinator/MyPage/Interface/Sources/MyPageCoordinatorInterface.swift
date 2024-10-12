//
//  MyPageCoordinatorInterface.swift
//  CoordinatorMyPageInterface
//
//  Created by Derrick kim on 10/7/24.
//

import UIKit

import CoordinatorAppInterface
import FeatureMyPageInterface
import FeatureHomeInterface

import DependencyInjection
import Domain
import Shared
import Core

public final class MyPageCoordinator: Coordinator {

    public weak var delegate: CoordinatorDelegate?
    public var navigationController: UINavigationController
    public var childCoordinators: [Coordinator]

    public init(navigationController: UINavigationController) {
        self.navigationController = navigationController
        self.childCoordinators = []
    }

    public func start() {
        registerSearchNoteDI()
        configureMyPageViewController()
    }

    private func registerSearchNoteDI() {
        DIContainer.registerNetworkProvider(hasTokenStorage: true)

        DIContainer.standard.register(.noteAPIService) { resolver in
            let networkProvider = try resolver.resolve(.networkProvider)
            return NoteAPIService(networkProvider: networkProvider)
        }

        DIContainer.registerReportNoteService()
        DIContainer.registerDependenciesForPostNote()

        DIContainer.standard.register(.commentAPIService) { resolver in
            let networkProvider = try resolver.resolve(.networkProvider)
            return CommentAPIService(networkProvider: networkProvider)
        }

        DIContainer.registerUserProfileService()
    }

    private func configureMyPageViewController() {
        let viewModel = myPageDependencies()
        let viewController = MyPageViewController(viewModel: viewModel)
        viewController.coordinator = self
        navigationController.pushViewController(viewController, animated: true)
    }
}

// MARK: Search Note

extension MyPageCoordinator: MyPageViewControllerDelegate,
                             NoteNotificationContainerViewControllerDelegate,
                             NoteCommentsViewControllerDelegate,
                             ReportViewControllerDelegate,
                             SettingViewControllerDelegate,
                             EditNoteViewControllerDelegate,
                             SearchSongViewControllerDelegate,
                             ProfileEditViewControllerDelegate,
                             UserInfoViewControllerDelegate {
    public func didFinish() {
        didFinish(childCoordinator: self)
    }

    public func didFinish(childCoordinator: Coordinator) {
        delegate?.didFinish(childCoordinator: self)
    }

    public func popViewController(isHiddenTabBar: Bool) {
        navigationController.tabBarController?.tabBar.isHidden = isHiddenTabBar
        popViewController()
    }

    public func pushSettingViewController() {
        let viewModel = settingDependencies()
        let viewController = SettingViewController(viewModel: viewModel)
        viewController.coordinator = self
        navigationController.pushViewController(viewController, animated: true)
    }

    public func pushNoteNotificationViewController() {
        let noteNotificationContainerViewController = NoteNotificationContainerViewController()
        noteNotificationContainerViewController.coordinator = self
        navigationController.tabBarController?.tabBar.isHidden = true
        navigationController.pushViewController(noteNotificationContainerViewController, animated: true)
    }

    public func pushNoteCommentsViewController(noteID: Int) {
        let viewModel = noteCommentsDependencies(noteID: noteID)
        let noteCommentsViewController = NoteCommentsViewController(viewModel: viewModel)
        noteCommentsViewController.coordinator = self
        navigationController.tabBarController?.tabBar.isHidden = true
        navigationController.pushViewController(noteCommentsViewController, animated: true)
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
        let viewModel = editNoteDependencies(note: note)
        let viewController = EditNoteViewController(viewModel: viewModel)
        viewController.coordinator = self

        let navController = UINavigationController(rootViewController: viewController)
        navController.isNavigationBarHidden = true
        navController.modalPresentationStyle = .fullScreen
        navigationController.present(navController, animated: true)
    }

    public func pushEditProfileViewController(userProfile: UserProfile) {
        let viewModel = profileEditDependencies(userProfile: userProfile)
        let reportViewController = ProfileEditViewController(viewModel: viewModel)
        reportViewController.coordinator = self
        navigationController.tabBarController?.tabBar.isHidden = true
        navigationController.pushViewController(reportViewController, animated: true)
    }

    public func pushSearchSongViewController(artistID: Int) {
        guard let topNavigationController = navigationController.presentedViewController as? UINavigationController else {
            return
        }

        let searchSongViewModel = searchSongDependencies(artistID: artistID)
        let searchSongViewController = SearchSongViewController(viewModel: searchSongViewModel)
        searchSongViewController.coordinator = self

        topNavigationController.tabBarController?.tabBar.isHidden = true
        topNavigationController.pushViewController(searchSongViewController, animated: true)
    }

    public func didFinish(selectedItem: Song) {
        guard let topNavigationController = navigationController.presentedViewController as? UINavigationController else {
            return
        }

        if let editNoteViewController = topNavigationController.viewControllers.first(where: { $0 is EditNoteViewController }) as? EditNoteViewController {
            editNoteViewController.addSelectedSong(selectedItem)
        }

        topNavigationController.popViewController(animated: true)
    }

    public func popRootViewController() {
        guard let topNavigationController = navigationController.presentedViewController as? UINavigationController
        else {
            return
        }

        topNavigationController.popViewController(animated: true)
    }

    public func pushUserInfoViewController() {
        let viewModel = settingDependencies()
        let userInfoViewController = UserInfoViewController(viewModel: viewModel)
        userInfoViewController.coordinator = self
        navigationController.pushViewController(userInfoViewController, animated: true)
    }
}

private extension MyPageCoordinator {
    func noteCommentsDependencies(noteID: Int) -> NoteCommentsViewModel {
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

    func myPageDependencies() -> MyPageViewModel {
        @Injected(.userProfileAPIService) var userProfileAPIService: UserProfileAPIServiceInterface

        let getUserProfileUseCase: GetUserProfileUseCaseInterface = GetUserProfileUseCase(
            userProfileAPIService: userProfileAPIService
        )
        let viewModel = MyPageViewModel(
            getUserProfileUseCase: getUserProfileUseCase
        )

        return viewModel
    }

    func profileEditDependencies(userProfile: UserProfile) -> ProfileEditViewModel {
        @Injected(.userProfileAPIService) var userProfileAPIService: UserProfileAPIServiceInterface

        let patchUserProfileUseCase: PatchUserProfileUseCaseInterface = patchUserProfileUseCase(
            userProfileAPIService: userProfileAPIService
        )

        let viewModel = ProfileEditViewModel(
            patchUserProfileUseCase: patchUserProfileUseCase,
            userProfile: userProfile
        )

        return viewModel
    }

    func settingDependencies() -> SettingViewModel {
        @Injected(.userProfileAPIService) var userProfileAPIService: UserProfileAPIServiceInterface

        let getUserProfileUseCase: GetUserProfileUseCaseInterface = GetUserProfileUseCase(
            userProfileAPIService: userProfileAPIService
        )
        let deleteUserUseCase: DeleteUserUseCaseInterface = DeleteUserUseCase(
            userProfileAPIService: userProfileAPIService
        )

        let viewModel = SettingViewModel(
            getUserProfileUseCase: getUserProfileUseCase,
            deleteUserUseCase: deleteUserUseCase
        )

        return viewModel
    }

    func editNoteDependencies(note: Note) -> EditNoteViewModel {
        @Injected(.noteAPIService) var noteAPIService: NoteAPIServiceInterface
        let editNoteUseCase: PatchNoteUseCaseInterface = PatchNoteUseCase(noteAPIService: noteAPIService)
        let viewModel = EditNoteViewModel(
            editNoteUseCase: editNoteUseCase,
            note: note
        )

        return viewModel
    }

    func searchSongDependencies(artistID: Int) -> SearchSongViewModel {
        @Injected(.noteAPIService) var noteAPIService: NoteAPIServiceInterface
        @Injected(.songPaginationService) var songPaginationService: SongPaginationServiceInterface

        songPaginationService.resetPagination()

        let searchSongUseCase = SearchSongUseCase(
            noteAPIService: noteAPIService,
            songPaginationService: songPaginationService
        )
        let viewModel = SearchSongViewModel(
            searchSongUseCase: searchSongUseCase,
            artistID: artistID
        )

        return viewModel
    }
}
