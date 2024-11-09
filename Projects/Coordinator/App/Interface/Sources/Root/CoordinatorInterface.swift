//
//  RootCoordinatorInterface.swift
//  CoordinatorAppInterface
//
//  Created by Derrick kim on 5/6/24.
//

import UIKit

import Shared

public protocol CoordinatorDelegate: AnyObject {
    func didFinish(childCoordinator: Coordinator)
}

public protocol Coordinator: AnyObject {
    var delegate: CoordinatorDelegate? { get set }
    var navigationController: UINavigationController { get set }
    var childCoordinators: [Coordinator] { get set }
    var authErrorHandler: AuthErrorHandler { get }

    func start()
    func finish()
    func popViewController()
    func dismissViewController()
    func handleError(
        errorCode: String?,
        errorMessage: String
    )
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
    
    func handleError(
        errorCode: String?,
        errorMessage: String
    ) {
        if let errorCode = errorCode {
            switch errorCode {
            case FeelinAPIError.ErrorType.authInfoNotFound.errorCode,
                 FeelinAPIError.ErrorType.duplicatedLogin.errorCode:
                self.navigationController.topViewController?.showAlert(
                    title: errorMessage,
                    message: "에러코드(\(errorCode))",
                    singleActionTitle: "확인") { [weak self] in
                        self?.authErrorHandler.deleteUserData()
                        self?.finish()
                    }
                
            default:
                self.navigationController.topViewController?.showAlert(
                    title: errorMessage,
                    message: "에러코드(\(errorCode)",
                    singleActionTitle: "확인"
                )
            }
        } else {
            self.navigationController.topViewController?.showAlert(
                title: errorMessage,
                message: nil,
                singleActionTitle: "확인"
            )
        }
    }
}
