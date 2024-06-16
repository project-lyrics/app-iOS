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
        configureLoginController()
    }
}

private extension OnboardingCoordinator {
    func configureLoginController() {
        let viewModel = loginDependencies()
        let viewController = LoginViewController(viewModel: viewModel)
        viewController.coordinator = self
        navigationController.setNavigationBarHidden(true, animated: false)
        navigationController.pushViewController(viewController, animated: false)
    }

    func registerDependencies() {
        DIContainer.registerNetworkProvider(hasTokenStorage: true)
        DIContainer.registerUserValidityService()
        DIContainer.registerKakaoOAuthService()
        DIContainer.registerAppleOAuthService()
        DIContainer.registerRecentLoginRecordService()
    }

    func loginDependencies() -> LoginViewModel {
        @Injected(.kakaoOAuthService) var kakaoOAuthService
        @Injected(.appleOAuthService) var appleOAuthService
        @Injected(.userValidityService) var userValidityService
        @Injected(.recentLoginRecordService) var recentLoginRecordService

        let kakaoLoginUseCase = OAuthLoginUseCase(oAuthService: kakaoOAuthService)
        let appleLoginUseCase = OAuthLoginUseCase(oAuthService: appleOAuthService)

        let viewModel = LoginViewModel(
            kakaoOAuthLoginUseCase: kakaoLoginUseCase,
            appleOAuthLoginUseCase: appleLoginUseCase, 
            recentLoginRecordService: recentLoginRecordService
        )

        return viewModel
    }
}

extension OnboardingCoordinator: CoordinatorDelegate,
                                 LoginViewControllerDelegate {
    public func didFinish() {
        didFinish(childCoordinator: self)
    }

    public func didFinish(childCoordinator: Coordinator) {
        delegate?.didFinish(childCoordinator: childCoordinator)
    }
}
