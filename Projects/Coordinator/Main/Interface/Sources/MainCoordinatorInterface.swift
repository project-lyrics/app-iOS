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

    func postNoteDependencies(artistID: Int) -> PostNoteViewModel {
        @Injected(.noteService) var noteService: NoteServiceInterface
        let postNoteUseCase: PostNoteUseCaseInterface = PostNoteUseCase(noteService: noteService)
        let viewModel = PostNoteViewModel(postNoteUseCase: postNoteUseCase, artistID: artistID)

        return viewModel
    }
}

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
        @Injected(.noteService) var noteService: NoteServiceInterface
        @Injected(.songPaginationService) var songPaginationService: SongPaginationServiceInterface

        songPaginationService.resetPagination()

        let searchSongUseCase = SearchSongUseCase(
            noteService: noteService,
            songPaginationService: songPaginationService
        )
        let searchSongViewModel = SearchSongViewModel(
            searchSongUseCase: searchSongUseCase,
            artistID: artistID
        )

        let searchSongViewController = SearchSongViewController(viewModel: searchSongViewModel)
        searchSongViewController.coordinator = self
        navigationController.pushViewController(searchSongViewController, animated: true)
    }

    public func didFinish(childCoordinator: Coordinator) {

    }
}
