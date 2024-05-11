import UIKit
import CoordinatorAppInterface
import FeatureMainInterface

public final class MainCoordinator: Coordinator {
    public weak var delegate: CoordinatorDelegate?
    public var navigationController: UINavigationController
    public var childCoordinators: [Coordinator]

    public init(navigationController: UINavigationController) {
        self.navigationController = navigationController
        self.childCoordinators = []
    }

    public func start() {
        configureMainController()
    }
}

private extension MainCoordinator {
    func configureMainController() {
        let viewController = MainRootViewController()
        navigationController.pushViewController(viewController, animated: true)
    }
}
