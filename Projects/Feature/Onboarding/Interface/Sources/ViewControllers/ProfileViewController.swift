//
//  ProfileViewController.swift
//  FeatureOnboardingInterface
//
//  Created by jiyeon on 6/14/24.
//

import UIKit

import Combine
import Domain
import Shared

public protocol ProfileViewControllerDelegate: AnyObject {
    func popViewController()
    func pushWelcomeViewController()
}

public final class ProfileViewController: UIViewController {
    private let profileView = ProfileView()
    private let editProfileViewController = EditProfileViewController(bottomSheetHeight: 284)

    public weak var coordinator: ProfileViewControllerDelegate?
    private var cancellables = Set<AnyCancellable>()
    private let viewModel: ProfileViewModel

    public init(viewModel: ProfileViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError()
    }

    public override func loadView() {
        view = profileView
    }

    public override func viewDidLoad() {
        super.viewDidLoad()
        
        overrideUserInterfaceStyle = .light
        bind()
    }

    public override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }

    private func bind() {
        backButton.publisher(for: .touchUpInside)
            .sink { [weak self] _ in
                self?.coordinator?.popViewController()
            }
            .store(in: &cancellables)

        profileEditButton.publisher(for: .touchUpInside)
            .sink { _ in
                self.editProfileViewController.modalPresentationStyle = .overFullScreen
                self.present(self.editProfileViewController, animated: false)
            }
            .store(in: &cancellables)

        let profileSelectionPublisher = profileSelectionIndexPublisher
            .map { ProfileCharacterType.allCases[$0].character }
            .eraseToAnyPublisher()

        let nicknameTextPublisher = nicknameTextField.textField.textPublisher
            .eraseToAnyPublisher()

        let nextButtonPublisher = nextButton.publisher(for: .touchUpInside)
            .eraseToAnyPublisher()

        let input = ProfileViewModel.Input(
            nicknameTextPublisher: nicknameTextPublisher,
            profileImagePublisher: profileSelectionPublisher,
            nextButtonTapPublisher: nextButtonPublisher
        )

        let output = viewModel.transform(input)

        output.isNextButtonEnabled
            .assign(to: \.isEnabled, on: nextButton)
            .store(in: &cancellables)

        output.profileImage
            .sink { [weak self] profileImage in
                self?.profileEditButton.setProfileImage(with: profileImage)
            }
            .store(in: &cancellables)

        output.signUpResult
            .receive(on: DispatchQueue.main)
            .sink { [weak self] result in
                switch result {
                case .success:
                    self?.coordinator?.pushWelcomeViewController()
                case .failure(let error):
                    self?.showAlert(
                        shouldIgnoreDarkMode: true,
                        title: "알림",
                        message: error.localizedDescription
                    )
                }
            }
            .store(in: &cancellables)
    }
}

private extension ProfileViewController {
    var backButton: UIButton {
        return profileView.backButton
    }

    var profileEditButton: ProfileEditButton {
        return profileView.profileEditButton
    }

    var nicknameTextField: FeelinLineInputField {
        return profileView.nicknameTextField
    }

    var nextButton: FeelinConfirmButton {
        return profileView.nextButton
    }

    var profileSelectionIndexPublisher: CurrentValueSubject<Int, Never> {
        return editProfileViewController.profileSelectionIndexPublisher
    }
}
