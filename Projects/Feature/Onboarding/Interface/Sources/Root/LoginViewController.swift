//
//  LoginViewController.swift
//  FeatureOnboardingInterface
//
//  Created by Derrick kim on 4/20/24.
//

import UIKit
import FlexLayout
import Combine

public protocol LoginViewControllerDelegate: AnyObject {
    func didFinish()
}

public final class LoginViewController: UIViewController {
    private let loginView = LoginView()
    private let viewModel: LoginViewModel
    private var cancellables = Set<AnyCancellable>()

    public weak var coordinator: LoginViewControllerDelegate?

    public init(viewModel: LoginViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    public required init?(coder: NSCoder) {
        fatalError()
    }

    public override func loadView() {
        view = loginView
    }

    public override func viewDidLoad() {
        super.viewDidLoad()

        setUpDefault()
    }

    private func setUpDefault() {
        loginView.configureLayouts()
        addButtonTargets()
        bind()
        viewModel.fetchRecentLoginRecord()
    }

    private func bind() {
        viewModel.outputs.loginResultState
            .receive(on: DispatchQueue.main)
            .sink { [weak self] state in
                switch state {
                case .success:
                    self?.coordinator?.didFinish()
                case .failure(let error):
                    break
                }
            }
            .store(in: &cancellables)

        viewModel.outputs.recentLoginRecord
            .sink { [weak self] type in
                switch type {
                case .none:
                    break
                case .apple:
                    self?.loginView.setUpRecentLoginRecordBallonView(true)
                case .kakao:
                    self?.loginView.setUpRecentLoginRecordBallonView(false)
                }
            }
            .store(in: &cancellables)
    }

    private func addButtonTargets() {
        appleLoginButton.addTarget(
            self,
            action: #selector(appleLoginButtonTapped),
            for: .touchUpInside
        )

        kakaoLoginButton.addTarget(
            self,
            action: #selector(kakaoLoginButtonTapped),
            for: .touchUpInside
        )

        let tapGesture = UITapGestureRecognizer(
            target: self,
            action: #selector(continueWithoutLoginLabelTapped)
        )
        continueWithoutLoginLabel.addGestureRecognizer(tapGesture)
    }

    @objc private func appleLoginButtonTapped(_ sender: UIButton) {
        viewModel.inputs.appleLogin()
    }

    @objc private func kakaoLoginButtonTapped(_ sender: UIButton) {
        viewModel.inputs.kakaoLogin()
    }

    @objc private func continueWithoutLoginLabelTapped(_ sender: UIGestureRecognizer) {
        coordinator?.didFinish()
    }
}

// MARK: UI Properties
private extension LoginViewController {
    var kakaoLoginButton: UIButton {
        return loginView.kakaoLoginButton
    }

    var appleLoginButton: UIButton {
        return loginView.appleLoginButton
    }

    var continueWithoutLoginLabel: UILabel {
        return loginView.continueWithoutLoginLabel
    }
}
