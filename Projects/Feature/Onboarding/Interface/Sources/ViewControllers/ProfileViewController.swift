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
    public override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
}

private extension ProfileViewController {
    var profileEditButton: ProfileEditButton {
        return profileView.profileEditButton
    }

    var nextButton: FeelinConfirmButton {
        return profileView.nextButton
    }
}
