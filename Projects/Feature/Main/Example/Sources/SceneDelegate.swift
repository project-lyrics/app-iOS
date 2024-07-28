//
//  SceneDelegate.swift
//  CoreLocalStorageExample
//
//  Created by 황인우 on 5/19/24.
//

import DependencyInjection
import Domain
import FeatureMainInterface
import FeatureMainTesting
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
        
        DIContainer.standard.register(.networkProvider) { resolver in
            return NetworkProvider(
                networkSession: .init(requestInterceptor: MockTokenInterceptor())
            )
        }
        DIContainer.registerDependenciesForArtistSelectView()
        
        @Injected(.artistAPIService) var artistAPIService: ArtistAPIServiceInterface
        @Injected(.artistPaginationService) var artistPaginationService: ArtistPaginationServiceInterface
        
        let getArtistsUseCase = GetArtistsUseCase(
            artistAPIService: artistAPIService,
            artistPaginationService: artistPaginationService
        )
        
        let searchArtistsUseCase = SearchArtistsUseCase(
            artistAPIService: artistAPIService,
            artistPaginationService: artistPaginationService
        )
        
        let postFavoriteArtistsUseCase = PostFavoriteArtistsUseCase(artistAPIService: artistAPIService)
        
        let viewModel = ArtistSelectViewModel(
            getArtistsUseCase: getArtistsUseCase,
            searchArtistsUseCase: searchArtistsUseCase, 
            postFavoriteArtistsUseCase: postFavoriteArtistsUseCase
        )
        
        let artistSelectViewController = ArtistSelectViewController(viewModel: viewModel)
        
        window?.rootViewController = artistSelectViewController
        window?.makeKeyAndVisible()
    }
    
    func sceneDidDisconnect(_ scene: UIScene) { }
    
    func sceneDidBecomeActive(_ scene: UIScene) { }
    
    func sceneWillResignActive(_ scene: UIScene) { }
    
    func sceneWillEnterForeground(_ scene: UIScene) { }
    
    func sceneDidEnterBackground(_ scene: UIScene) { }
}
