//
//  SceneDelegate.swift
//  FeatureMyPageInterface
//
//  Created by Derrick kim on 10/12/24.
//

import DependencyInjection
import Domain
import FeatureHomeInterface
import FeatureHomeTesting
import Shared
import Core

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?

    func scene(
        _ scene: UIScene,
        willConnectTo session: UISceneSession,
        options connectionOptions: UIScene.ConnectionOptions
    ) {
        guard let windowScene = (scene as? UIWindowScene) else {
            return
        }

        window = UIWindow(windowScene: windowScene)
    }
}
