import UIKit
import CoordinatorAppInterface
import FeatureOnboardingInterface
import DependencyInjection
import DomainOAuthInterface
import CoordinatorMainInterface

public final class OnboardingCoordinator: Coordinator {
    public weak var delegate: CoordinatorDelegate?
    public var navigationController: UINavigationController
    public var childCoordinators: [Coordinator]

    public init(navigationController: UINavigationController) {
        self.navigationController = navigationController
        self.childCoordinators = []
    }

    public func start() {
        registerDependencies()
        configureLogInController()
    }
}

private extension OnboardingCoordinator {
    func configureLogInController() {
        let viewModel = logInDependencies()
        let viewController = LogInViewController(viewModel: viewModel)
        viewController.coordinator = self
        navigationController.setNavigationBarHidden(true, animated: false)
        navigationController.pushViewController(viewController, animated: false)
    }

    func registerDependencies() {
        DIContainer.registerTokenStorageNetwork()
        DIContainer.registerUserValidityService()
        DIContainer.registerKakaoOAuthService()
        DIContainer.registerAppleOAuthService()
        DIContainer.registerRecentLogInRecordService()
    }

    func logInDependencies() -> LogInViewModel {
        @Injected(.kakaoOAuthService) var kakaoOAuthService
        @Injected(.appleOAuthService) var appleOAuthService
        @Injected(.userValidityService) var userValidityService
        @Injected(.recentLogInRecordService) var recentLoginRecordService

        let kakaoLoginUseCase = OAuthLogInUseCase(oAuthService: kakaoOAuthService)
        let appleLoginUseCase = OAuthLogInUseCase(oAuthService: appleOAuthService)

        let viewModel = LogInViewModel(
            kakaoOAuthLoginUseCase: kakaoLoginUseCase,
            appleOAuthLoginUseCase: appleLoginUseCase, 
            recentLoginRecordService: recentLoginRecordService
        )

        return viewModel
    }
}

extension OnboardingCoordinator: CoordinatorDelegate,
                                 LogInViewControllerDelegate {
    public func didFinish() {
        didFinish(childCoordinator: self)
    }

    public func didFinish(childCoordinator: Coordinator) {
        delegate?.didFinish(childCoordinator: childCoordinator)
    }
}
