//
//  AppCoordinator.swift
//  Feelin
//
//  Created by Derrick kim on 4/23/24.
//

import UIKit
import CoordinatorAppInterface
import CoordinatorTabBarInterface
import FeatureOnboardingInterface
import CoordinatorOnboardingInterface
import DependencyInjection
import DomainOAuthInterface

final class AppCoordinator: Coordinator {
    var delegate: CoordinatorDelegate?
    var navigationController: UINavigationController
    var childCoordinators: [Coordinator]

    init(rootViewController: UINavigationController) {
        self.navigationController = rootViewController
        self.childCoordinators = []

        registerDependencies()
    }

    func start() {
        let viewModel = splashDependencies()
        let viewController = SplashViewController(viewModel: viewModel)
        viewController.coordinator = self
        navigationController.setNavigationBarHidden(true, animated: false)
        navigationController.pushViewController(viewController, animated: false)
    }
}

private extension AppCoordinator {
    func connectOnboardingCoordinator() {
        navigationController.viewControllers.removeAll()
        let onboardingCoordinator = OnboardingCoordinator(
            navigationController: navigationController
        )

        onboardingCoordinator.delegate = self
        onboardingCoordinator.start()
        childCoordinators.append(onboardingCoordinator)
    }

    func connectTabBarCoordinator() {
        navigationController.popToRootViewController(animated: false)
        let onboardingCoordinator = TabBarCoordinator(
            navigationController: navigationController
        )

        onboardingCoordinator.delegate = self
        onboardingCoordinator.start()
        childCoordinators.append(onboardingCoordinator)
    }

    func registerDependencies() {
        DIContainer.registerTokenStorageNetwork()
        DIContainer.registerUserValidityService()
    }

    func splashDependencies() -> SplashViewModel {
        @Injected(.userValidityService) var userValidityService

        let autoLogInUseCase = AutoLogInUseCase(userValidityService: userValidityService)
        let viewModel = SplashViewModel(autoLogInUseCase: autoLogInUseCase)
        return viewModel
    }
}

extension AppCoordinator: CoordinatorDelegate, SplashViewControllerDelegate {
    func connectTabBarFlow() {
        connectTabBarCoordinator()
    }

    func didFinish() {
        didFinish(childCoordinator: self)
    }

    func didFinish(childCoordinator: Coordinator) {
        navigationController.popToRootViewController(animated: false)
        if childCoordinator is OnboardingCoordinator {
            connectTabBarCoordinator()
        } else {
            connectOnboardingCoordinator()
        }
    }
}
