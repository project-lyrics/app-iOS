import UIKit
import CoordinatorAppInterface
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
        configureOnboardingController()
    }
}

private extension OnboardingCoordinator {
    func configureOnboardingController() {
        let viewController = OnboardingRootViewController()
    }
}
