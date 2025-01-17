//
//  SplashCoordinator.swift
//  Feelin
//
//  Created by Derrick kim on 12/16/24.
//

import UIKit
import CoordinatorAppInterface
import CoordinatorTabBarInterface
import DependencyInjection
import DomainOAuthInterface

public final class SplashCoordinator: Coordinator {
    public var appErrorHandler: AppErrorHandlerInterface

    public weak var delegate: CoordinatorDelegate?
    public var navigationController: UINavigationController
    public var childCoordinators: [Coordinator]

    public init(
        navigationController: UINavigationController,
        appErrorHandler: AppErrorHandlerInterface = AppErrorHandler()
    ) {
        self.navigationController = navigationController
        self.appErrorHandler = appErrorHandler
        self.childCoordinators = []
    }

    public func start() {
        let viewModel = splashDependencies()
        let viewController = SplashViewController(viewModel: viewModel)
        viewController.coordinator = self
        navigationController.setNavigationBarHidden(true, animated: false)
        navigationController.pushViewController(viewController, animated: false)
    }
}

private extension SplashCoordinator {
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

extension SplashCoordinator: CoordinatorDelegate, SplashViewControllerDelegate {
    public func didFinish(childCoordinator: Coordinator) {
        self.delegate?.didFinish(childCoordinator: childCoordinator)
    }
    
    func connectTabBarFlow() {
        navigationController.popToRootViewController(animated: false)
        let onboardingCoordinator = TabBarCoordinator(
            navigationController: navigationController
        )

        onboardingCoordinator.delegate = self
        onboardingCoordinator.start()
        childCoordinators.append(onboardingCoordinator)
    }
    
    func didFinish() {
        didFinish(childCoordinator: self)
    }
}
