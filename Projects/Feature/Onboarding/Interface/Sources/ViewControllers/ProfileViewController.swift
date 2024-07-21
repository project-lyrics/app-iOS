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

        bind()
    }

    public override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }

    private func bind() {
        let nicknameTextPublisher = PassthroughSubject<String?, Never>()
        let profileImagePublisher = PassthroughSubject<String?, Never>()

        let combinedSignUpModelPublisher = Publishers.CombineLatest(
            nicknameTextPublisher,
            profileImagePublisher
        )
            .compactMap { (nickname, profileCharacter) -> UserSignUpEntity? in
                guard let nickname = nickname,
                      let profileCharacter = profileCharacter else { return nil }

                return UserSignUpEntity(nickname: nickname, profileCharacter: profileCharacter)
            }
            .eraseToAnyPublisher()

        backButton.publisher(for: .touchUpInside)
            .sink { [weak self] _ in
                self?.coordinator?.popViewController()
            }
            .store(in: &cancellables)

        profileEditButton.publisher(for: .touchUpInside)
            .sink { [weak self] _ in
                guard let self = self else { return }

                editProfileViewController.modalPresentationStyle = .overFullScreen
                present(editProfileViewController, animated: false)
            }
            .store(in: &cancellables)

        let nicknameTextFieldPublisher = nicknameTextField.textField.textPublisher
            .map { nickname in
                if let count = nickname?.count, count < 10, count > 0 {
                    nicknameTextPublisher.send(nickname)
                    return true
                }

                return false
            }
            .eraseToAnyPublisher()

        profileSelectionPublisher
            .sink { [weak self] index in
                let images = ProfileCharacterType.allCases
                self?.profileEditButton.setProfileImage(with: images[index].image)
                profileImagePublisher.send(images[index].character)
            }
            .store(in: &cancellables)

        nicknameTextFieldPublisher
            .sink { [weak self] isEnabled in
                guard let self = self else { return }
                nextButton.isEnabled = isEnabled && nicknameTextField.isValid
            }
            .store(in: &cancellables)

        let nextButtonPublisher = nextButton.publisher(for: .touchUpInside)
            .eraseToAnyPublisher()

        let combinedPublisher = nextButtonPublisher
            .combineLatest(combinedSignUpModelPublisher)
            .map { $1 }
            .eraseToAnyPublisher()

        let input = ProfileViewModel.Input(
            combinedSignUpModelPublisher: combinedPublisher
        )

        let output = viewModel.transform(input)

        output.signUpResult
            .receive(on: DispatchQueue.main)
            .sink { [weak self] result in
                switch result {
                case .success:
                    self?.coordinator?.pushWelcomeViewController()
                case .failure(let error):
                    print("Sign up failed: \(error.localizedDescription)")
                }
            }
            .store(in: &cancellables)

        profileImagePublisher.send(ProfileCharacterType.defaultCharacter)
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

    var profileSelectionPublisher: PassthroughSubject<Int, Never> {
        return editProfileViewController.profileSelectionPublisher
    }
}
