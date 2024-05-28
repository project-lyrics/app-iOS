//
//  SplashViewController.swift
//  Feelin
//
//  Created by Derrick kim on 5/22/24.
//

import UIKit
import SharedDesignSystem
import CoordinatorAppInterface
import PinLayout

protocol SplashViewControllerDelegate: AnyObject {
    func didFinish()
}

final class SplashViewController: UIViewController {
    weak var coordinator: SplashViewControllerDelegate?

    private let logoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        imageView.image = FeelinImages.logo
        return imageView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        setupDefault()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        addConstraints()
    }

    private func setupDefault() {
        addViews()
        setupColors()
        setupAnimation()
    }

    private func setupColors() {
        view.backgroundColor = Colors.primary
    }

    private func addViews() {
        view.addSubview(logoImageView)
    }

    private func addConstraints() {
        logoImageView.pin.center()
    }

    private func setupAnimation() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) { [weak self] in
            self?.coordinator?.didFinish()
        }
    }
}
