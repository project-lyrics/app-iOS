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
        
//        DIContainer.standard.register(.networkProvider) { resolver in
//            return NetworkProvider(
//                networkSession: .init(requestInterceptor: MockTokenInterceptor())
//            )
//        }
//        DIContainer.registerDependenciesForArtistSelectView()
//        
//        @Injected(.artistAPIService) var artistAPIService: ArtistAPIServiceInterface
//        @Injected(.artistPaginationService) var artistPaginationService: ArtistPaginationServiceInterface
//        
//        let getArtistsUseCase = GetArtistsUseCase(
//            artistAPIService: artistAPIService,
//            artistPaginationService: artistPaginationService
//        )
//        
//        let searchArtistsUseCase = SearchArtistsUseCase(
//            artistAPIService: artistAPIService,
//            artistPaginationService: artistPaginationService
//        )
//        
//        let postFavoriteArtistsUseCase = PostFavoriteArtistsUseCase(artistAPIService: artistAPIService)
//        
//        let viewModel = ArtistSelectViewModel(
//            getArtistsUseCase: getArtistsUseCase,
//            searchArtistsUseCase: searchArtistsUseCase,
//            postFavoriteArtistsUseCase: postFavoriteArtistsUseCase
//        )
//        
//        let artistSelectViewController = ArtistSelectViewController(viewModel: viewModel)
//        
//        window?.rootViewController = artistSelectViewController
//        window?.makeKeyAndVisible()
        // --------------------ArtistSelectViewController-------------------
        
        DIContainer.standard.register(.networkProvider) { _ in
            let networkSession = NetworkSession(
                urlSession: .shared,
                requestInterceptor: MockTokenInterceptor()
            )
            
            return NetworkProvider(networkSession: networkSession)
        }
        
        DIContainer.standard.register(.notePaginationService) { _ in
            return NotePaginationService()
        }
        
        DIContainer.standard.register(.artistPaginationService) { resolver in
            return ArtistPaginationService()
        }
        
        DIContainer.standard.register(.noteAPIService.self) { resolver in
            let networkProvider = try resolver.resolve(.networkProvider)
            
            return NoteAPIService(networkProvider: networkProvider)
        }
        
        DIContainer.standard.register(.artistAPIService) { resolver in
            let networkProvider = try resolver.resolve(.networkProvider)
            
            return ArtistAPIService(networkProvider: networkProvider)
        }
        @Injected(.artistAPIService) var artistAPIService: ArtistAPIServiceInterface
        @Injected(.noteAPIService) var noteAPiService: NoteAPIServiceInterface
        @Injected(.notePaginationService) var notePaginationService: NotePaginationServiceInterface
        @Injected(.artistPaginationService) var artistPaginationService: ArtistPaginationServiceInterface
        
//        let mainViewModel = MainViewModel(
//            getNotesUseCase: GetFavoriteArtistsRelatedNotesUseCase(
//                noteAPIService: noteAPiService,
//                notePaginationService: notePaginationService
//            ),
//            getFavoriteArtistsUseCase: GetFavoriteArtistsUseCase(
//                artistAPIService: artistAPIService,
//                artistPaginationService: artistPaginationService
//            )
//        )
        let mainViewModel = MainViewModel(
            getNotesUseCase: MockGetNotesUseCase(),
            getFavoriteArtistsUseCase: MockGetFavoriteArtistsUseCase()
        )
        
        window?.rootViewController = MainViewController(viewModel: mainViewModel)
        window?.makeKeyAndVisible()
    }
    
    func sceneDidDisconnect(_ scene: UIScene) { }
    
    func sceneDidBecomeActive(_ scene: UIScene) { }
    
    func sceneWillResignActive(_ scene: UIScene) { }
    
    func sceneWillEnterForeground(_ scene: UIScene) { }
    
    func sceneDidEnterBackground(_ scene: UIScene) { }
}

#if canImport(SwiftUI)
import SwiftUI

struct MainViewController_Preview: PreviewProvider {
    static var previews: some View {
        let viewModelForPreview = MainViewModel(
            getNotesUseCase: MockGetNotesUseCase(),
            getFavoriteArtistsUseCase: MockGetFavoriteArtistsUseCase()
        )
        return MainViewController(viewModel: viewModelForPreview)
            .asPreview()
    }
}

#endif
