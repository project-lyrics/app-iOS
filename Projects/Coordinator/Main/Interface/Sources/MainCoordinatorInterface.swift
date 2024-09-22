import UIKit
import CoordinatorAppInterface
import FeatureMainInterface
import DependencyInjection
import Domain
import Core

public final class MainCoordinator: Coordinator {
    public weak var delegate: CoordinatorDelegate?
    public var navigationController: UINavigationController
    public var childCoordinators: [Coordinator]

    public init(navigationController: UINavigationController) {
        self.navigationController = navigationController
        self.childCoordinators = []
    }

    public func start() {
        registerNetwork()
    }
}

private extension MainCoordinator {
    func configureMainController() {

    }

    func registerNetwork() {
        DIContainer.registerNetworkProvider(hasTokenStorage: true)
    }

    func registerPostNoteDI() {
        DIContainer.registerDependenciesForPostNote()
    }

    func registerReportNoteService() {
        DIContainer.registerReportNoteService()
    }
}

// MARK: 노트작성

extension MainCoordinator: CoordinatorDelegate,
                           PostNoteViewControllerDelegate,
                           SearchSongViewControllerDelegate {
    public func didFinish(selectedItem: DomainSharedInterface.Song) {
        if let postNoteViewController = navigationController.viewControllers.first(where: { $0 is PostNoteViewController }) as? PostNoteViewController {
            postNoteViewController.addSelectedSong(selectedItem)
            popViewController()
        }
    }

    public func didFinish() {

    }

    public func pushPostNoteViewController(artistID: Int) {
        registerPostNoteDI()
        let viewModel = postNoteDependencies(artistID: artistID)
        let postNoteViewController = PostNoteViewController(viewModel: viewModel)
        postNoteViewController.coordinator = self
        navigationController.pushViewController(postNoteViewController, animated: true)
    }

    public func pushSearchSongViewController(artistID: Int) {
        let searchSongViewModel = searchSongDependencies(artistID: artistID)
        let searchSongViewController = SearchSongViewController(viewModel: searchSongViewModel)
        searchSongViewController.coordinator = self
        navigationController.pushViewController(searchSongViewController, animated: true)
    }

    public func didFinish(childCoordinator: Coordinator) {

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
}


    }
}
