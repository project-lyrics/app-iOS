//
//  SplashViewController.swift
//  Feelin
//
//  Created by Derrick kim on 5/22/24.
//

import UIKit
import Combine
import SharedDesignSystem
import CoordinatorAppInterface
import PinLayout

protocol SplashViewControllerDelegate: AnyObject {
    func connectTabBarFlow()
    func didFinish()
}

final class SplashViewController: UIViewController {
    private let logoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        imageView.image = FeelinImages.logo
        return imageView
    }()

    private var cancellables = Set<AnyCancellable>()

    weak var coordinator: SplashViewControllerDelegate?
    private let viewModel: SplashViewModel

    init(viewModel: SplashViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        setUpDefault()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        addConstraints()
    }

    private func setUpDefault() {
        addViews()
        setUpColors()
        bind()
        viewModel.autoLogin()
    }

    private func setUpColors() {
        view.backgroundColor = Colors.primary
    }

    private func addViews() {
        view.addSubview(logoImageView)
    }

    private func addConstraints() {
        logoImageView.pin.center()
    }

    private func bind() {
        viewModel.isSignIn
            .delay(for: .seconds(1), scheduler: DispatchQueue.main)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] isSignIn in
                if isSignIn {
                    self?.coordinator?.connectTabBarFlow()
                } else {
                    self?.coordinator?.didFinish()
                }
            }
            .store(in: &cancellables)
    }
}
