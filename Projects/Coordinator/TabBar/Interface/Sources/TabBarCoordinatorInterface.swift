//
//  TabBarCoordinator.swift
//  CoordinatorTabBarCoordinatorInterface
//
//  Created by Derrick kim on 10/6/24.
//

import UIKit
import CoordinatorAppInterface
import CoordinatorHomeInterface
import CoordinatorSearchNoteInterface
import SharedDesignSystem

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
        tabBarController.selectedIndex = TabBarPageType.home.index
        tabBarController.view.backgroundColor = .white
        tabBarController.tabBar.backgroundColor = Colors.gray01
        tabBarController.tabBar.tintColor = Colors.gray08

        tabBarController.setViewControllers(viewControllers, animated: false)
        navigationController.setNavigationBarHidden(true, animated: false)
        navigationController.pushViewController(tabBarController, animated: true)
    }

    func createTabBarNavigationController(
        of page: TabBarPageType
    ) -> UINavigationController {
        let tabBarNavigationController = UINavigationController()
        tabBarNavigationController.tabBarItem = page.tabBarItem

        tabBarNavigationController.setNavigationBarHidden(
            true,
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
        case .home:         connectHomeFlow(to: tabBarNavigationController)
        case .noteSearch:   connectSearchNoteFlow(to: tabBarNavigationController)
        case .myPage: break
        }
    }

    func connectHomeFlow(to tabBarNavigationController: UINavigationController) {
        let homeCoordinator = HomeCoordinator(
            navigationController: tabBarNavigationController
        )

        homeCoordinator.delegate = self
        homeCoordinator.start()
        childCoordinators.append(homeCoordinator)
    }    

    func connectSearchNoteFlow(to tabBarNavigationController: UINavigationController) {
        let searchNoteCoordinator = SearchNoteCoordinator(
            navigationController: tabBarNavigationController
        )

        searchNoteCoordinator.delegate = self
        searchNoteCoordinator.start()
        childCoordinators.append(searchNoteCoordinator)
    }
}
