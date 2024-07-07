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
}

public final class ProfileViewController: UIViewController {
    private let profileView = ProfileView()
    private let editProfileViewController = EditProfileViewController(bottomSheetHeight: 284)

    public weak var coordinator: ProfileViewControllerDelegate?
    private var cancellables = Set<AnyCancellable>()
    private var model: UserSignUpEntity

    public init(model: UserSignUpEntity) {
        self.model = model
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
            .map {
                return ($0?.count ?? 0 < 10 && $0?.count ?? 0 > 0)
            }
            .eraseToAnyPublisher()

        profileSelectionPublisher
            .sink { [weak self] index in
                // TODO: 어떤 아이콘 선택했는지 필요함
                let images = ProfileCharacterType.allCases
                self?.profileEditButton.setProfileImage(with: images[index].image)
            }
            .store(in: &cancellables)

        nicknameTextFieldPublisher
            .sink { [weak self] isEnabled in
                guard let self = self else { return }
                nextButton.isEnabled = isEnabled && nicknameTextField.isValid
            }
            .store(in: &cancellables)

        nextButton.publisher(for: .touchUpInside)
            .sink { [weak self] _ in

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

    var profileSelectionPublisher: PassthroughSubject<Int, Never> {
        return editProfileViewController.profileSelectionPublisher
    }
}
