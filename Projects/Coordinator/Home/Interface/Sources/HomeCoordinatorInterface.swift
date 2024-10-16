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
        DIContainer.standard.register(.songPaginationService) { _ in
            return SongPaginationService()
        }
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

    private func configureHomeController() {
        let homeViewModel = homeDependencies()
        let homeViewController = HomeViewController(viewModel: homeViewModel)
        homeViewController.coordinator = self
        navigationController.pushViewController(homeViewController, animated: true)
    }
}

// MARK: Home

extension HomeCoordinator: HomeViewControllerDelegate,
                           ReportViewControllerDelegate,
                           NoteNotificationContainerViewControllerDelegate,
                           NoteCommentsViewControllerDelegate,
                           MyFavoriteArtistsViewControllerDelegate,
                           CommunityMainViewControllerDelegate,
                           UserLinkedWebViewControllerDelegate,
                           SearchMoreFavoriteArtistDelegate {
    public func pushNoteNotificationViewController() {
        let noteNotificationContainerViewController = NoteNotificationContainerViewController()
        noteNotificationContainerViewController.coordinator = self
        navigationController.pushViewController(noteNotificationContainerViewController, animated: true)
    }

    public func pushNoteCommentsViewController(noteID: Int) {
        let viewModel = noteCommentsDependencies(noteID: noteID)
        let noteCommentsViewController = NoteCommentsViewController(viewModel: viewModel)
        noteCommentsViewController.coordinator = self
        navigationController.pushViewController(noteCommentsViewController, animated: true)
    }

    public func pushReportViewController(noteID: Int?, commentID: Int?) {
        registerReportNoteService()

        let viewModel = reportNoteDependencies(noteID: noteID, commentID: commentID)
        let reportViewController = ReportViewController(viewModel: viewModel)
        reportViewController.coordinator = self
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
    
    public func presentUserLinkedWebViewController(url: URL) {
        let viewController = UserLinkedWebViewController(url: url)
        viewController.coordinator = self
        viewController.modalPresentationStyle = .fullScreen
        navigationController.present(viewController, animated: true)
    }
    
    public func presentSearchMoreFavoriteArtistViewController() {
        let viewModel = searchMoreFavoriteArtistsDependencies()
        let viewController = SearchMoreFavoriteArtistViewController(viewModel: viewModel)
        viewController.coordinator = self
        viewController.modalPresentationStyle = .fullScreen
        navigationController.present(viewController, animated: true)
    }
}

// MARK: 노트작성

extension HomeCoordinator: CoordinatorDelegate,
                           PostNoteViewControllerDelegate,
                           EditNoteViewControllerDelegate,
                           SearchSongViewControllerDelegate {

    public func popRootViewController() {
        guard let topNavigationController = navigationController.presentedViewController as? UINavigationController 
        else {
            return
        }

        topNavigationController.popViewController(animated: true)
    }

    public func didFinish(selectedItem: Song) {
        guard let topNavigationController = navigationController.presentedViewController as? UINavigationController else {
            return
        }

        if let postNoteViewController = topNavigationController.viewControllers.first(where: { $0 is PostNoteViewController }) as? PostNoteViewController {
            postNoteViewController.addSelectedSong(selectedItem)
        } else if let editNoteViewController = topNavigationController.viewControllers.first(where: { $0 is EditNoteViewController }) as? EditNoteViewController {
            editNoteViewController.addSelectedSong(selectedItem)
        }

        topNavigationController.popViewController(animated: true)
    }
    
    public func presentPostNoteViewController(artistID: Int) {
        registerPostNoteDI()
        let viewModel = postNoteDependencies(artistID: artistID)
        let postNoteViewController = PostNoteViewController(viewModel: viewModel)
        postNoteViewController.coordinator = self
        
        let navController = UINavigationController(rootViewController: postNoteViewController)
        navController.isNavigationBarHidden = true
        navController.modalPresentationStyle = .fullScreen
        navigationController.present(navController, animated: true)
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

    public func pushSearchSongViewController(artistID: Int) {
        guard let topNavigationController = navigationController.presentedViewController as? UINavigationController else {
            return
        }

        let searchSongViewModel = searchSongDependencies(artistID: artistID)
        let searchSongViewController = SearchSongViewController(viewModel: searchSongViewModel)
        searchSongViewController.coordinator = self
        
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

    func editNoteDependencies(note: Note) -> EditNoteViewModel {
        @Injected(.noteAPIService) var noteAPIService: NoteAPIServiceInterface
        let editNoteUseCase: PatchNoteUseCaseInterface = PatchNoteUseCase(noteAPIService: noteAPIService)
        let viewModel = EditNoteViewModel(
            editNoteUseCase: editNoteUseCase,
            note: note
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
    
    private func searchMoreFavoriteArtistsDependencies() -> SearchMoreFavoriteArtistViewModel {
        @Injected(.artistAPIService) var artistAPIService: ArtistAPIServiceInterface
        let artistPaginationService = ArtistPaginationService()
        let getArtistsUseCase = GetArtistsUseCase(artistAPIService: artistAPIService, artistPaginationService: artistPaginationService)
        let searchArtistsUseCase = SearchArtistsUseCase(artistAPIService: artistAPIService, artistPaginationService: artistPaginationService)
        let viewModel = SearchMoreFavoriteArtistViewModel(getArtistsUseCase: getArtistsUseCase, searchArtistsUseCase: searchArtistsUseCase)
        
        return viewModel
    }
}
