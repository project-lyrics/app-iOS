//
//  RootCoordinatorInterface.swift
//  CoordinatorAppInterface
//
//  Created by Derrick kim on 5/6/24.
//

import UIKit

public protocol CoordinatorDelegate: AnyObject {
    func didFinish(childCoordinator: Coordinator)
}

public protocol Coordinator: AnyObject {
    var delegate: CoordinatorDelegate? { get set }
    var navigationController: UINavigationController { get set }
    var childCoordinators: [Coordinator] { get set }

    func start()
    func finish()
    func popViewController()
    func dismissViewController()
}

public extension Coordinator {
    func finish() {
        childCoordinators.removeAll()
        delegate?.didFinish(childCoordinator: self)
    }

    func popViewController() {
        navigationController.popViewController(animated: true)
    }

    func dismissViewController() {
        navigationController.dismiss(animated: true)
    }
}
