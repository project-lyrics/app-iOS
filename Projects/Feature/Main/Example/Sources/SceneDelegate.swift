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

        let navigationController = UINavigationController(rootViewController: pushPostNoteViewController(artistID: 12))
        navigationController.navigationBar.isHidden = true
        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()
    }

    func sceneDidDisconnect(_ scene: UIScene) { }

    func sceneDidBecomeActive(_ scene: UIScene) { }

    func sceneWillResignActive(_ scene: UIScene) { }

    func sceneWillEnterForeground(_ scene: UIScene) { }

    func sceneDidEnterBackground(_ scene: UIScene) { }

    func registerNetwork() {
        DIContainer.standard.register(.networkProvider) { resolver in
            return NetworkProvider(
                networkSession: .init(requestInterceptor: MockTokenInterceptor())
            )
        }
    }
}

extension SceneDelegate {
    func artistDependencies() {
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
        
//        DIContainer.standard.register(.networkProvider) { _ in
//            let networkSession = NetworkSession(
//                urlSession: .shared,
//                requestInterceptor: MockTokenInterceptor()
//            )
//            
//            return NetworkProvider(networkSession: networkSession)
//        }
//        
//        DIContainer.standard.register(.notePaginationService) { _ in
//            return NotePaginationService()
//        }
//        
//        DIContainer.standard.register(.artistPaginationService) { resolver in
//            return ArtistPaginationService()
//        }
//        
//        DIContainer.standard.register(.noteAPIService.self) { resolver in
//            let networkProvider = try resolver.resolve(.networkProvider)
//            
//            return NoteAPIService(networkProvider: networkProvider)
//        }
//        
//        DIContainer.standard.register(.artistAPIService) { resolver in
//            let networkProvider = try resolver.resolve(.networkProvider)
//            
//            return ArtistAPIService(networkProvider: networkProvider)
//        }
//        @Injected(.artistAPIService) var artistAPIService: ArtistAPIServiceInterface
//        @Injected(.noteAPIService) var noteAPiService: NoteAPIServiceInterface
//        @Injected(.notePaginationService) var notePaginationService: NotePaginationServiceInterface
//        @Injected(.artistPaginationService) var artistPaginationService: KeywordPaginationServiceInterface
//        
//        @KeychainWrapper<UserInformation>(.userInfo)
//        var userInfo
//        
//        // 테스트용 유저 아이디
//        userInfo = .init(userID: 1)

//        let homeViewModel = HomeViewModel(
//            getNotesUseCase: GetFavoriteArtistsRelatedNotesUseCase(
//                noteAPIService: noteAPiService,
//                notePaginationService: notePaginationService
//            ), 
//            setNoteLikeUseCase: SetNoteLikeUseCase(noteAPIService: noteAPiService),
//            getFavoriteArtistsUseCase: GetFavoriteArtistsUseCase(
//                artistAPIService: artistAPIService,
//                artistPaginationService: artistPaginationService
//            ),
//            setBookmarkUseCase: SetBookmarkUseCase(noteAPIService: noteAPiService),
//            deleteNoteUseCase: DeleteNoteUseCase(noteAPIService: noteAPiService)
//        )
//        let homeViewModel = HomeViewModel(
//            getNotesUseCase: MockGetNotesUseCase(),
//            setNoteLikeUseCase: MockSetNoteLikeUseCase(),
//            getFavoriteArtistsUseCase: MockGetFavoriteArtistsUseCase(),
//            setBookmarkUseCase: MockSetBookmarkUseCase(), deleteNoteUseCase: MockDeleteNoteUseCase()
//        )
//        
//        window?.rootViewController = HomeViewController(viewModel: homeViewModel)
//        window?.makeKeyAndVisible()
//         --------------------MainViewController-------------------
        
//        DIContainer.standard.register(.networkProvider) { _ in
//            return NetworkProvider(
//                networkSession: .init(requestInterceptor: MockTokenInterceptor())
//            )
//        }
//        
//        DIContainer.standard.register(.noteAPIService) { resolver in
//            let networkProvider = try resolver.resolve(.networkProvider)
//            return NoteAPIService(networkProvider: networkProvider)
//        }
//        
//        @Injected(.noteAPIService) var noteAPiService: NoteAPIServiceInterface
//        
//        @KeychainWrapper<UserInformation>(.userInfo)
//        var userInfo
//        
//        // 테스트용 유저 아이디
//        userInfo = .init(userID: 1)
//        
//        let getSearchedNoteUseCase = GetSearchedNotesUseCase(
//            noteAPIService: noteAPiService,
//            searchedNotePaginationService: SearchedNotePaginationService()
//        )
//        
//        let searchNoteViewModel = SearchNoteViewModel(getSearchedNotesUseCase: getSearchedNoteUseCase)
//        
//        window?.rootViewController = SearchNoteViewController(viewModel: searchNoteViewModel)
//        window?.makeKeyAndVisible()
        
        // --------------------SearchNoteViewController-------------------
        
//        DIContainer.standard.register(.networkProvider) { _ in
//            return NetworkProvider(networkSession: .init(requestInterceptor: MockTokenInterceptor()))
//        }
//        
//        DIContainer.standard.register(.noteAPIService) { resolver in
//            let networkProvider = try resolver.resolve(.networkProvider)
//            
//            return NoteAPIService(networkProvider: networkProvider)
//        }
//        
//        @Injected(.noteAPIService) var noteAPIService: NoteAPIServiceInterface
//        
//        let getSongNotesUseCase = GetSongNotesUseCase(
//            noteAPIService: noteAPIService,
//            notePaginationService: NotePaginationService()
//        )
//        
//        let setNoteLikeUseCase = SetNoteLikeUseCase(noteAPIService: noteAPIService)
//        
//        let setBookmarkUseCase = SetBookmarkUseCase(noteAPIService: noteAPIService)
//        
//        let deleteNoteUseCase = DeleteNoteUseCase(noteAPIService: noteAPIService)
//        
//        let selectedNote = SearchedNote(
//            id: 1,
//            songName: "Flying Bobs",
//            artistName: "검정치마",
//            imageUrl: "https://i.scdn.co/image/ab67616d0000b2739c3a4e471c5e82a457dce2c0",
//            noteCount: 1
//        )
//        
//        let noteDetailViewModel = NoteDetailViewModel(
//            selectedNote: selectedNote,
//            getSongNotesUseCase: getSongNotesUseCase,
//            setNoteLikeUseCase: setNoteLikeUseCase,
//            setBookmarkUseCase: setBookmarkUseCase,
//            deleteNoteUseCase: deleteNoteUseCase
//        )
//        
//        window?.rootViewController = NoteDetailViewController(viewModel: noteDetailViewModel)
//        window?.makeKeyAndVisible()
        
        // --------------------NoteDetailViewController-------------------
        
//        @KeychainWrapper<UserInformation>(.userInfo)
//        var userInfo
//        
//        userInfo = .init(userID: 4)
//        
////        let noteCommentsViewModel = NoteCommentsViewModel(
////            noteID: 1,
////            setNoteLikeUseCase: MockSetNoteLikeUseCase(),
////            setBookmarkUseCase: MockSetBookmarkUseCase(),
////            deleteNoteUseCase: MockDeleteNoteUseCase(),
////            getNoteWithCommentsUseCase: MockGetNoteWithCommentsUseCase(),
////            writeCommentUseCase: MockWriteCommentUseCase(),
////            deleteCommentUseCase: MockDeleteCommentUseCase()
////        )
//        DIContainer.standard.register(.networkProvider) { _ in
//            return NetworkProvider(networkSession: .init(requestInterceptor: MockTokenInterceptor()))
//        }
//        
//        DIContainer.standard.register(.noteAPIService) { resolver in
//            let networkProvider = try resolver.resolve(.networkProvider)
//            
//            return NoteAPIService(networkProvider: networkProvider)
//        }
//        
//        DIContainer.standard.register(.commentAPIService) { resolver in
//            let networkProvider = try resolver.resolve(.networkProvider)
//            return CommentAPIService(networkProvider: networkProvider)
//        }
//        
//        @Injected(.noteAPIService) var noteAPIService: NoteAPIServiceInterface
//        @Injected(.commentAPIService) var commentAPIService: CommentAPIServiceInterface
//        
//        let noteCommentsViewModel = NoteCommentsViewModel(
//            noteID: 3,
//            setNoteLikeUseCase: SetNoteLikeUseCase(noteAPIService: noteAPIService),
//            setBookmarkUseCase: SetBookmarkUseCase(noteAPIService: noteAPIService),
//            deleteNoteUseCase: DeleteNoteUseCase(noteAPIService: noteAPIService),
//            getNoteWithCommentsUseCase: GetNoteWithCommentsUseCase(commentAPIService: commentAPIService),
//            writeCommentUseCase: WriteCommentUseCase(commentAPIService: commentAPIService),
//            deleteCommentUseCase: DeleteCommentUseCase(commentAPIService: commentAPIService)
//        )
//        
//        window?.rootViewController = NoteCommentsViewController(viewModel: noteCommentsViewModel)
//        window?.makeKeyAndVisible()
        
        // --------------------NoteCommentsViewController-------------------
    }
}

extension SceneDelegate: PostNoteViewControllerDelegate, SearchSongViewControllerDelegate {
    func popViewController() {

    }

    func didFinish() {

    }

    func didFinish(selectedItem: DomainSharedInterface.Song) {

    }

    func registerPostNoteDI() {
        DIContainer.registerDependenciesForPostNote()
    }

    func postNoteDependencies(artistID: Int) -> PostNoteViewModel {
        @Injected(.noteAPIService) var noteAPIService: NoteAPIServiceInterface
        let postNoteUseCase: PostNoteUseCaseInterface = PostNoteUseCase(noteAPIService: noteAPIService)
        let viewModel = PostNoteViewModel(postNoteUseCase: postNoteUseCase, artistID: artistID)

        return viewModel
    }

    func pushPostNoteViewController(artistID: Int) -> PostNoteViewController {
        registerNetwork()
        registerPostNoteDI()
        let viewModel = postNoteDependencies(artistID: artistID)
        let postNoteViewController = PostNoteViewController(viewModel: viewModel)
        postNoteViewController.coordinator = self
        return postNoteViewController
    }

    func pushSearchSongViewController(artistID: Int) {
        @Injected(.noteAPIService) var noteAPIService: NoteAPIServiceInterface
        @Injected(.songPaginationService) var songPaginationService: SongPaginationServiceInterface

        songPaginationService.resetPagination()

        let searchSongUseCase = SearchSongUseCase(
            noteAPIService: noteAPIService,
            songPaginationService: songPaginationService
        )
        let searchSongViewModel = SearchSongViewModel(
            searchSongUseCase: searchSongUseCase,
            artistID: artistID
        )

        let searchSongViewController = SearchSongViewController(viewModel: searchSongViewModel)
        searchSongViewController.coordinator = self

        if let postNoteViewController = UIApplication.shared.windows.first?.rootViewController?.children.first(where: { $0 is PostNoteViewController }) as? PostNoteViewController {
            postNoteViewController.navigationController?.pushViewController(searchSongViewController, animated: true)
        }
    }
}

#if canImport(SwiftUI)
import SwiftUI

//struct HomeViewController_Preview: PreviewProvider {
//    static var previews: some View {
//        let viewModelForPreview = HomeViewModel(
//            getNotesUseCase: MockGetNotesUseCase(), 
//            setNoteLikeUseCase: MockSetNoteLikeUseCase(),
//            getFavoriteArtistsUseCase: MockGetFavoriteArtistsUseCase(),
//            setBookmarkUseCase: MockSetBookmarkUseCase(),
//            deleteNoteUseCase: MockDeleteNoteUseCase()
//        )
//        return HomeViewController(viewModel: viewModelForPreview)
//            .asPreview()
//    }
//}

//struct SearchNoteViewController_Preview: PreviewProvider {
//    static var previews: some View {
//        let viewModelForPreview = SearchNoteViewModel(
//            getSearchedNotesUseCase: MockGetSearchedNotesUseCase()
//        )
//        
//        return SearchNoteViewController(viewModel: viewModelForPreview)
//            .asPreview()
//    }
//}

//struct NoteDetailViewController_Preview: PreviewProvider {
//    static var previews: some View {
//        let selectedNote = SearchedNote(
//            id: 1,
//            songName: "사랑하긴 했었나요 스쳐가는 인연이었나요 \n 짧지않은 우리 함께했던 시간들이 자꾸 내 마음을 가둬두네",
//            artistName: "잔나비",
//            imageUrl: "https://i.scdn.co/image/ab67616d0000b2739c3a4e471c5e82a457dce2c0",
//            noteCount: 1
//        )
//        
//        let viewModelForPreview = NoteDetailViewModel(
//            selectedNote: selectedNote,
//            getSongNotesUseCase: MockGetSongNotesUseCase(),
//            setNoteLikeUseCase: MockSetNoteLikeUseCase(),
//            setBookmarkUseCase: MockSetBookmarkUseCase(),
//            deleteNoteUseCase: MockDeleteNoteUseCase()
//        )
//        
//        return NoteDetailViewController(viewModel: viewModelForPreview)
//            .asPreview()
//    }
//}


//struct NoteCommentsViewController_Preview: PreviewProvider {
//    static var previews: some View {
//        
//        let viewModelForPreview = NoteCommentsViewModel(
//            noteID: 1,
//            setNoteLikeUseCase: MockSetNoteLikeUseCase(),
//            setBookmarkUseCase: MockSetBookmarkUseCase(),
//            deleteNoteUseCase: MockDeleteNoteUseCase(),
//            getNoteWithCommentsUseCase: MockGetNoteWithCommentsUseCase(),
//            writeCommentUseCase: MockWriteCommentUseCase(),
//            deleteCommentUseCase: MockDeleteCommentUseCase()
//        )
//        
//        
//        return NoteCommentsViewController(viewModel: viewModelForPreview)
//            .asPreview()
//    }
//}

#endif
