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
    var appErrorHandler: AppErrorHandlerInterface
    var delegate: CoordinatorDelegate?
    var navigationController: UINavigationController
    var childCoordinators: [Coordinator]

    init(
        rootViewController: UINavigationController,
        appErrorHandler: AppErrorHandlerInterface = AppErrorHandler()
    ) {
        self.navigationController = rootViewController
        self.appErrorHandler = appErrorHandler
        self.childCoordinators = []

        registerDependencies()
    }

    func start() {
        let splashCoordinator = SplashCoordinator(
            navigationController: navigationController
        )

        splashCoordinator.delegate = self
        splashCoordinator.start()
        childCoordinators.append(splashCoordinator)
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
        DIContainer.registerNetworkProvider(hasTokenStorage: true)
        DIContainer.registerUserValidityService()
    }

    func splashDependencies() -> SplashViewModel {
        @Injected(.userValidityService) var userValidityService

        let autoLoginUseCase = AutoLoginUseCase(userValidityService: userValidityService)
        let viewModel = SplashViewModel(autoLoginUseCase: autoLoginUseCase)
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
