import UIKit
import CoordinatorAppInterface
import CoordinatorMainInterface

public final class TabBarCoordinator: Coordinator {
    public weak var delegate: CoordinatorDelegate?
    public var navigationController: UINavigationController
    public var tabBarController: UITabBarController
    public var childCoordinators: [Coordinator]

    public init(navigationController: UINavigationController) {
        self.navigationController = navigationController
        self.tabBarController = UITabBarController()
        self.childCoordinators = []
    }

    public func start() {
        let pages: [TabBarPageType] = TabBarPageType.allCases
        let controllers: [UINavigationController] = pages.map {
            createTabBarNavigationController(of: $0)
        }
        configureTabBarController(with: controllers)
    }
}

extension TabBarCoordinator: CoordinatorDelegate {
    public func didFinish(childCoordinator: Coordinator) {
        self.navigationController.popToRootViewController(animated: false)
        self.finish()
    }
}

private extension TabBarCoordinator {
    func configureTabBarController(with viewControllers: [UIViewController]) {
        tabBarController.selectedIndex = 0
        tabBarController.tabBar.tintColor = .systemBlue

        tabBarController.setViewControllers(
            viewControllers,
            animated: true
        )

        navigationController.setNavigationBarHidden(
            true,
            animated: false
        )

        navigationController.pushViewController(
            tabBarController,
            animated: true
        )
    }

    func createTabBarNavigationController(
        of page: TabBarPageType
    ) -> UINavigationController {
        let tabBarNavigationController = UINavigationController()
        tabBarNavigationController.tabBarItem = page.tabBarItem

        tabBarNavigationController.setNavigationBarHidden(
            false,
            animated: false
        )

        connectTabCoordinator(
            of: page,
            to: tabBarNavigationController
        )

        return tabBarNavigationController
    }

    func connectTabCoordinator(
        of page: TabBarPageType,
        to tabBarNavigationController: UINavigationController
    ) {
        switch page {
        case .main: connectMainFlow(to: tabBarNavigationController)
        }
    }

    func connectMainFlow(to tabBarNavigationController: UINavigationController) {
        let mainCoordinator = MainCoordinator(
            navigationController: navigationController
        )

        mainCoordinator.delegate = self
        mainCoordinator.start()
        childCoordinators.append(mainCoordinator)
    }
}
