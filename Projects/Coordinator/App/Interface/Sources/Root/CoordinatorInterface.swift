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
    var appErrorHandler: AppErrorHandlerInterface { get }

    func start()
    func finish()
    func popViewController()
    func dismissViewController()
    func handleError(
        errorCode: String?,
        errorMessage: String,
        errorData: AnyType?
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
        errorMessage: String,
        errorData: AnyType?
    ) {
        if let errorCode = errorCode {
            switch errorCode {
            case FeelinAPIError.ErrorType.authInfoNotFound.errorCode,
                 FeelinAPIError.ErrorType.duplicatedLogin.errorCode:
                self.navigationController.topViewController?.showAlert(
                    title: errorMessage,
                    message: "에러코드(\(errorCode))",
                    singleActionTitle: "확인") { [weak self] in
                        self?.appErrorHandler.deleteUserData()
                        self?.finish()
                    }
                
            case FeelinAPIError.ErrorType.updateRequired.errorCode:
                self.navigationController.topViewController?.showAlert(
                    title: errorMessage,
                    message: "원활한 서비스 이용을 위해 업데이트가 필요해요.",
                    singleActionTitle: "확인") { [weak self] in
                        self?.appErrorHandler.goToUpdate(data: errorData)
                    }
                
            default:
                self.navigationController.topViewController?.showAlert(
                    title: errorMessage,
                    message: "에러코드(\(errorCode))",
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
