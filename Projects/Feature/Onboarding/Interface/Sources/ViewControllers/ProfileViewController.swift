//
//  ProfileViewController.swift
//  FeatureOnboardingInterface
//
//  Created by jiyeon on 6/14/24.
//

import UIKit

import Shared

public final class ProfileViewController: UIViewController {
    private let profileView = ProfileView()
    
    public override func loadView() {
        view = profileView
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpAction()
    }
    
    private func setUpAction() {
        profileEditButton.addTarget(
            self,
            action: #selector(profileEditButtonDidTap),
            for: .touchUpInside
        )
    }
    
    @objc private func profileEditButtonDidTap() {
        let editProfileViewController = EditProfileViewController(bottomSheetHeight: 284)
        editProfileViewController.modalPresentationStyle = .overFullScreen
        present(editProfileViewController, animated: false)
    }
    
    public override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
}

private extension ProfileViewController {
    var profileEditButton: ProfileEditButton {
        profileView.profileEditButton
    }
    
    var nextButton: FeelinConfirmButton {
        profileView.nextButton
    }
}
