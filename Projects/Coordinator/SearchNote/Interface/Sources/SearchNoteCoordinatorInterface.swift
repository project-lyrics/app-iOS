//
//  SearchNoteCoordinatorInterface.swift
//  CoordinatorSearchNoteInterface
//
//  Created by Derrick kim on 10/6/24.
//

import UIKit

import CoordinatorAppInterface
import FeatureMainInterface
import DependencyInjection
import Domain
import Shared
import Core

public final class SearchNoteCoordinator: Coordinator {
    public weak var delegate: CoordinatorDelegate?
    public var navigationController: UINavigationController
    public var childCoordinators: [Coordinator]

    public init(navigationController: UINavigationController) {
        self.navigationController = navigationController
        self.childCoordinators = []
    }

    public func start() {
        registerSearchNoteDI()
        configureSearchNoteViewController()
    }

    private func registerSearchNoteDI() {
        DIContainer.registerNetworkProvider(hasTokenStorage: true)

        DIContainer.standard.register(.noteAPIService) { resolver in
            let networkProvider = try resolver.resolve(.networkProvider)
            return NoteAPIService(networkProvider: networkProvider)
        }

        DIContainer.registerReportNoteService()
    }
}
