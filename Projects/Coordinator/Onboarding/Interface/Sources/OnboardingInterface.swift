import UIKit

import CoordinatorMainInterface
import CoordinatorAppInterface
import Core

import Domain
import DependencyInjection
import FeatureOnboardingInterface

public final class OnboardingCoordinator: Coordinator {
    public weak var delegate: CoordinatorDelegate?
    public var navigationController: UINavigationController
    public var childCoordinators: [Coordinator]

    public init(navigationController: UINavigationController) {
        self.navigationController = navigationController
        self.childCoordinators = []
    }

    public func start() {
        registerLoginDependencies()
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

    func registerLoginDependencies() {
        DIContainer.registerRecentLoginRecordService()
        DIContainer.registerNetworkProvider(hasTokenStorage: false)
        DIContainer.registerUserValidityService()
        DIContainer.registerKakaoOAuthService()
        DIContainer.registerAppleOAuthService()
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
                                 LoginViewControllerDelegate,
                                 UseAgreementViewControllerDelegate,
                                 UserInformationViewControllerDelegate,
                                 ProfileViewControllerDelegate {
    public func pushUseAgreementViewController(model: UserSignUpEntity) {
        let viewController = UseAgreementViewController(model: model)
        viewController.coordinator = self
        navigationController.pushViewController(viewController, animated: true)
    }

    public func pushServiceUsageViewController() {

    }

    public func pushPersonalInfoUsageViewController() {

    }

    public func pushUserInformationViewController(model: UserSignUpEntity) {
        let viewController = UserInformationViewController(model: model)
        viewController.coordinator = self
        navigationController.pushViewController(viewController, animated: true)
    }

    public func pushProfileViewController(model: UserSignUpEntity) {
        let viewController = ProfileViewController(model: model)
        viewController.coordinator = self
        navigationController.pushViewController(viewController, animated: true)
    }

    public func didFinish() {
        didFinish(childCoordinator: self)
    }

    public func didFinish(childCoordinator: Coordinator) {
        delegate?.didFinish(childCoordinator: childCoordinator)
    }
}
