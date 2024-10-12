//
//  HomeCoordinatorInterface.swift
//  CoordinatorHomeInterface
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

public final class HomeCoordinator: Coordinator {
    public weak var delegate: CoordinatorDelegate?
    public var navigationController: UINavigationController
    public var childCoordinators: [Coordinator]

    public init(navigationController: UINavigationController) {
        self.navigationController = navigationController
        self.childCoordinators = []
    }

    public func start() {
        registerNetwork()
        registerHomeDI()
        configureHomeController()
    }

    private func registerNetwork() {
        DIContainer.registerNetworkProvider(hasTokenStorage: true)
    }

    private func registerPostNoteDI() {
        DIContainer.registerDependenciesForPostNote()
    }

    private func registerReportNoteService() {
        DIContainer.registerReportNoteService()
    }

    private func registerHomeDI() {
        DIContainer.standard.register(.notePaginationService) { _ in
            return NotePaginationService()
        }

        DIContainer.standard.register(.artistPaginationService) { resolver in
            return ArtistPaginationService()
        }

        DIContainer.standard.register(.noteAPIService.self) { resolver in
            let networkProvider = try resolver.resolve(.networkProvider)

            return NoteAPIService(networkProvider: networkProvider)
        }

        DIContainer.standard.register(.artistAPIService) { resolver in
            let networkProvider = try resolver.resolve(.networkProvider)

            return ArtistAPIService(networkProvider: networkProvider)
        }
    }

    private func registerNoteCommentDI() {
        DIContainer.standard.register(.commentAPIService) { resolver in
            let networkProvider = try resolver.resolve(.networkProvider)
            return CommentAPIService(networkProvider: networkProvider)
        }
    }
}

// MARK: Home

extension HomeCoordinator: HomeViewControllerDelegate,
                           ReportViewControllerDelegate,
                           NoteNotificationContainerViewControllerDelegate,
                           NoteCommentsViewControllerDelegate,
                           MyFavoriteArtistsViewControllerDelegate,
                           CommunityMainViewControllerDelegate {
    private func configureHomeController() {
        let homeViewModel = homeDependencies()
        let homeViewController = HomeViewController(viewModel: homeViewModel)
        homeViewController.coordinator = self
        navigationController.pushViewController(homeViewController, animated: true)
    }

    public func pushEditNoteViewController(noteID: Int) {

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
        registerReportNoteService()

        let viewModel = reportNoteDependencies(noteID: noteID, commentID: commentID)
        let reportViewController = ReportViewController(viewModel: viewModel)
        reportViewController.coordinator = self
        navigationController.tabBarController?.tabBar.isHidden = true
        navigationController.pushViewController(reportViewController, animated: true)
    }

    public func pushMyFavoriteArtistsViewController(artists: [Artist]) {
        let myFavoriteArtistsViewController = MyFavoriteArtistsViewController(artists: artists)
        myFavoriteArtistsViewController.coordinator = self
        myFavoriteArtistsViewController.modalPresentationStyle = .fullScreen
        navigationController.present(myFavoriteArtistsViewController, animated: true)
    }

    public func pushCommunityMainViewController(artist: Artist) {
        let viewModel = communityMainDependencies(artist: artist)
        let viewController = CommunityMainViewController(viewModel: viewModel)
        viewController.coordinator = self
        navigationController.pushViewController(viewController, animated: true)
    }
}

// MARK: 노트작성

extension HomeCoordinator: CoordinatorDelegate,
                           PostNoteViewControllerDelegate,
                           SearchSongViewControllerDelegate {
    /// 1. HomeVC > 커뮤니티 > 알림 > 노트 상세
    /// 노트 상세의 뒤로가기 액션에서, isHiddenTabBar default는 false이다.
    /// 그래서 아래 guard let으로 hidden false를 하지 않도록한다.
    /// 2. HomeVC > 노트 상세의 경우 false
    public func popViewController(isHiddenTabBar: Bool) {
        popViewController()

        guard navigationController.viewControllers.filter({ $0 is NoteNotificationContainerViewController }).isEmpty else {
            return
        }

        navigationController.tabBarController?.tabBar.isHidden = isHiddenTabBar
    }

    public func popRootViewController() {
        guard let topNavigationController = navigationController.presentedViewController as? UINavigationController 
        else {
            return
        }

        topNavigationController.popViewController(animated: true)
    }

    public func didFinish(selectedItem: Song) {
        guard let topNavigationController = navigationController.presentedViewController as? UINavigationController,
              let postNoteViewController = topNavigationController.viewControllers.first(where: { $0 is PostNoteViewController }) as? PostNoteViewController else {
            return
        }
        
        postNoteViewController.addSelectedSong(selectedItem)
        topNavigationController.popViewController(animated: true)
    }

    public func didFinish() {

    }

    public func pushPostNoteViewController(artistID: Int) {
        registerPostNoteDI()
        let viewModel = postNoteDependencies(artistID: artistID)
        let postNoteViewController = PostNoteViewController(viewModel: viewModel)
        postNoteViewController.coordinator = self
        
        let navController = UINavigationController(rootViewController: postNoteViewController)
        navController.isNavigationBarHidden = true
        navController.modalPresentationStyle = .fullScreen
        navigationController.present(navController, animated: true)
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

    public func didFinish(childCoordinator: Coordinator) {

    }
}

// MARK: - 최초 좋아하는 아티스트 선택

extension HomeCoordinator: ArtistSelectViewControllerDelegate {
    public func presentInitialArtistSelectViewController() {
        let artistSelectViewModel = self.InitialArtistSelectDependencies()
        let artistSelectViewController = ArtistSelectViewController(viewModel: artistSelectViewModel)
        artistSelectViewController.coordinator = self
        artistSelectViewController.modalPresentationStyle = .fullScreen
        navigationController.present(artistSelectViewController, animated: true)
    }
    
    public func didFinishSelectingInitialFavoriteArtists() {
        guard let homeViewController = navigationController.viewControllers.first(where: { $0 is HomeViewController }) as? HomeViewController else {
            return
        }
        // TODO: - 추후 HomeViewController의 ViewWillAppear 시점에서 아래 메서드가 호출되도록 수정해야 한다. 현재는 ArtistSelectViewController가 fullScreen present상태에서 dismiss가 되어도 homeViewController의 viewWillAppear가 호출되지 않아서 직접 updateInitialHomeData()를 여기서 호출하는 방향으로 진행하였다.
        homeViewController.updateInitialHomeData()
    }
}


extension HomeCoordinator {
    private func homeDependencies() -> HomeViewModel {
        @Injected(.artistAPIService) var artistAPIService: ArtistAPIServiceInterface
        @Injected(.noteAPIService) var noteAPIService: NoteAPIServiceInterface
        @Injected(.notePaginationService) var notePaginationService: NotePaginationServiceInterface
        @Injected(.artistPaginationService) var artistPaginationService: KeywordPaginationServiceInterface

        @KeychainWrapper<UserInformation>(.userInfo)
        var userInfo

        // TODO: 제거필요
        // 테스트용 유저 아이디
        // userInfo = .init(userID: 1)

        let getNoteUseCase = GetFavoriteArtistsRelatedNotesUseCase(
            noteAPIService: noteAPIService,
            notePaginationService: notePaginationService
        )

        let getFavoriteArtistsUseCase = GetFavoriteArtistsUseCase(
            artistAPIService: artistAPIService,
            artistPaginationService: artistPaginationService
        )

        let setNoteLikeUseCase = SetNoteLikeUseCase(noteAPIService: noteAPIService)
        let setBookmarkUseCase = SetBookmarkUseCase(noteAPIService: noteAPIService)
        let deleteNoteUseCase = DeleteNoteUseCase(noteAPIService: noteAPIService)

        let viewModel =  HomeViewModel(
            getNotesUseCase: getNoteUseCase,
            setNoteLikeUseCase: setNoteLikeUseCase,
            getFavoriteArtistsUseCase: getFavoriteArtistsUseCase,
            setBookmarkUseCase: setBookmarkUseCase,
            deleteNoteUseCase: deleteNoteUseCase
        )

        return viewModel
    }

    private func reportNoteDependencies(noteID: Int?, commentID: Int?) -> ReportViewModel {
        @Injected(.reportAPIService) var reportNoteService: ReportAPIServiceInterface
        let reportNoteUseCase: ReportNoteUseCaseInterface = ReportNoteUseCase(reportAPIService: reportNoteService)

        let viewModel = ReportViewModel(
            noteID: noteID,
            commentID: commentID,
            reportNoteUseCase: reportNoteUseCase
        )

        return viewModel
    }

    func postNoteDependencies(artistID: Int) -> PostNoteViewModel {
        @Injected(.noteAPIService) var noteAPIService: NoteAPIServiceInterface
        let postNoteUseCase: PostNoteUseCaseInterface = PostNoteUseCase(noteAPIService: noteAPIService)
        let viewModel = PostNoteViewModel(postNoteUseCase: postNoteUseCase, artistID: artistID)

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

    func noteCommentsDependencies(noteID: Int) -> NoteCommentsViewModel {
        registerNoteCommentDI()

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

    func communityMainDependencies(artist: Artist) -> CommunityMainViewModel {
        @Injected(.noteAPIService) var noteAPIService: NoteAPIServiceInterface
        @Injected(.notePaginationService) var notePaginationService: NotePaginationServiceInterface
        @Injected(.artistAPIService) var artistAPIService: ArtistAPIServiceInterface

        let getArtistNotesUseCase = GetArtistNotesUseCase(
            noteAPIService: noteAPIService,
            notePaginationService: notePaginationService
        )
        let setNoteLikeUseCase = SetNoteLikeUseCase(noteAPIService: noteAPIService)
        let setBookmarkUseCase = SetBookmarkUseCase(noteAPIService: noteAPIService)
        let deleteNoteUseCase = DeleteNoteUseCase(noteAPIService: noteAPIService)
        let setFavoriteArtistUseCase = SetFavoriteArtistUseCase(artistAPIService: artistAPIService)

        let viewModel = CommunityMainViewModel(
            artist: artist,
            getArtistNotesUseCase: getArtistNotesUseCase,
            setNoteLikeUseCase: setNoteLikeUseCase,
            setBookmarkUseCase: setBookmarkUseCase,
            deleteNoteUseCase: deleteNoteUseCase,
            setFavoriteArtistUseCase: setFavoriteArtistUseCase
        )
        return viewModel
    }
    
    private func InitialArtistSelectDependencies() -> ArtistSelectViewModel {
        self.registerNetwork()
        
        @Injected(.artistAPIService) var artistAPIService: ArtistAPIServiceInterface
        let artistPaginationService = ArtistPaginationService()
        
        let getArtistsUseCase = GetArtistsUseCase(
            artistAPIService: artistAPIService,
            artistPaginationService: artistPaginationService
        )
        
        let searchArtistsUseCase = SearchArtistsUseCase(
            artistAPIService: artistAPIService,
            artistPaginationService: artistPaginationService
        )
        
        let postFavoriteArtistsUseCase = PostFavoriteArtistsUseCase(
            artistAPIService: artistAPIService
        )
        
        let viewModel = ArtistSelectViewModel(
            getArtistsUseCase: getArtistsUseCase,
            searchArtistsUseCase: searchArtistsUseCase,
            postFavoriteArtistsUseCase: postFavoriteArtistsUseCase
        )
        
        return viewModel
    }
}
