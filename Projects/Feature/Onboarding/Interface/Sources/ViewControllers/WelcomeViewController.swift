//
//  WelcomeViewController.swift
//  FeatureOnboardingInterface
//
//  Created by Derrick kim on 7/10/24.
//

import Combine
import UIKit
import Shared

public protocol WelcomeViewControllerDelegate: AnyObject {
    func connectTabBarFlow()
}

public final class WelcomeViewController: UIViewController {
    private var welcomeView = WelcomeView()

    private var cancellables = Set<AnyCancellable>()

    public weak var coordinator: WelcomeViewControllerDelegate?

    public init() {
        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        fatalError()
    }

    public override func loadView() {
        view = welcomeView
    }

    public override func viewDidLoad() {
        super.viewDidLoad()
        
        overrideUserInterfaceStyle = .light

        Just<Void>(())
            .delay(for: .seconds(1), scheduler: DispatchQueue.main)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.coordinator?.connectTabBarFlow()
            }
            .store(in: &cancellables)

    }
}
