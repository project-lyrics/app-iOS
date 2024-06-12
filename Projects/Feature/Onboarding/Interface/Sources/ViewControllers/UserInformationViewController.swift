//
//  UserInformationViewController.swift
//  FeatureOnboardingInterface
//
//  Created by jiyeon on 6/12/24.
//

import UIKit

import SharedDesignSystem

public final class UserInformationViewController: UIViewController {
    private let userInformationView = UserInformationView()
    
    public override func loadView() {
        super.loadView()
        view = UserInformationView()
    }
}
