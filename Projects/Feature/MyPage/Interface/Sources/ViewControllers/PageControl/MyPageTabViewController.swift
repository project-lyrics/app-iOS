//
//  MyPageTabViewController.swift
//  FeatureMyPageInterface
//
//  Created by Derrick kim on 10/7/24.
//

import DependencyInjection
import Domain
import Shared
import Core

import UIKit

public protocol MyPageTabViewControllerDelegate: AnyObject {
    func pushReportViewController(noteID: Int?, commentID: Int?)
    func presentEditNoteViewController(note: Note)
    func popViewController()
    func pushNoteCommentsViewController(noteID: Int)
    func didFinish()
}

public final class MyPageTabViewController: ButtonBarPagerTabStripViewController {
    public weak var coordinator: MyPageTabViewControllerDelegate?

    public override func viewDidLoad() {
        setUpDefault()

        DIContainer.registerNetworkProvider(hasTokenStorage: true)
        DIContainer.standard.register(.noteAPIService) { resolver in
            let networkProvider = try resolver.resolve(.networkProvider)

            return NoteAPIService(networkProvider: networkProvider)
        }
        DIContainer.standard.register(.notePaginationService) { _ in
            return NotePaginationService()
        }

        changeCurrentIndexProgressive = { (oldCell: ButtonBarViewCell?, newCell: ButtonBarViewCell?, progressPercentage: CGFloat, changeCurrentIndex: Bool, animated: Bool) -> Void in
            guard changeCurrentIndex == true else { return }
            oldCell?.label.textColor = Colors.gray03
            newCell?.label.textColor = Colors.primary
        }

        super.viewDidLoad()
    }

    public override func viewControllers(for pagerTabStripController: FeelinPagerTabViewController) -> [UIViewController] {
        let myNoteViewModel = myNoteDependencies()
        let myNoteViewController = MyNoteViewController(viewModel: myNoteViewModel)
        myNoteViewController.coordinator = self

        let bookmarkViewModel = bookmarkDependencies()
        let bookmarkViewController = BookmarkViewController(viewModel: bookmarkViewModel)
        bookmarkViewController.coordinator = self

        return [myNoteViewController, bookmarkViewController]
    }

    private func setUpDefault() {
        settings.style.selectedBarHeight = 2.0
        settings.style.buttonBarMinimumLineSpacing = 0
        settings.style.buttonBarItemFont = SharedDesignSystemFontFamily.Pretendard.semiBold.font(size: 16)
        settings.style.buttonBarItemTitleColor = Colors.gray03
        settings.style.selectedBarItemTitleColor = Colors.primary
        settings.style.selectedBarBackgroundColor = Colors.primary
        settings.style.buttonBarBackgroundColor = .clear
    }
}

extension MyPageTabViewController: MyNoteViewControllerDelegate,
                                   BookmarkViewControllerDelegate{
    public func pushReportViewController(noteID: Int?, commentID: Int?) {
        coordinator?.pushReportViewController(noteID: noteID, commentID: commentID)
    }
    
    public func presentEditNoteViewController(note: Note) {
        coordinator?.presentEditNoteViewController(note: note)
    }
    
    public func popViewController() {
        coordinator?.popViewController()
    }
    
    public func pushNoteCommentsViewController(noteID: Int) {
        coordinator?.pushNoteCommentsViewController(noteID: noteID)
    }
    
    public func didFinish() {
        coordinator?.didFinish()
    }
}

private extension MyPageTabViewController {
    func myNoteDependencies() -> MyNoteViewModel {
        @Injected(.noteAPIService) var noteAPIService: NoteAPIServiceInterface
        @Injected(.notePaginationService) var notePaginationService: NotePaginationServiceInterface

        let setNoteLikeUseCase = SetNoteLikeUseCase(noteAPIService: noteAPIService)
        let setBookmarkUseCase = SetBookmarkUseCase(noteAPIService: noteAPIService)
        let deleteNoteUseCase = DeleteNoteUseCase(noteAPIService: noteAPIService)
        let getFavoriteArtistsHavingNotesUseCase = GetFavoriteArtistsHavingNotesUseCase(noteAPIService: noteAPIService)
        let getMyNotesUseCase = GetMyNotesUseCase(
            noteAPIService: noteAPIService,
            notePaginationService: notePaginationService
        )

        let viewModel = MyNoteViewModel(
            setNoteLikeUseCase: setNoteLikeUseCase,
            setBookmarkUseCase: setBookmarkUseCase,
            deleteNoteUseCase: deleteNoteUseCase,
            getFavoriteArtistsHavingNotesUseCase: getFavoriteArtistsHavingNotesUseCase,
            getMyNotesUseCase: getMyNotesUseCase
        )
        return viewModel
    }

    func bookmarkDependencies() -> BookmarkViewModel {
        @Injected(.noteAPIService) var noteAPIService: NoteAPIServiceInterface
        @Injected(.notePaginationService) var notePaginationService: NotePaginationServiceInterface

        let setNoteLikeUseCase = SetNoteLikeUseCase(noteAPIService: noteAPIService)
        let setBookmarkUseCase = SetBookmarkUseCase(noteAPIService: noteAPIService)
        let deleteNoteUseCase = DeleteNoteUseCase(noteAPIService: noteAPIService)
        let getFavoriteArtistsHavingNotesUseCase = GetFavoriteArtistsHavingNotesUseCase(noteAPIService: noteAPIService)
        let getMyNotesByBookmarkUseCase = GetMyNotesByBookmarkUseCase(
            noteAPIService: noteAPIService,
            notePaginationService: notePaginationService
        )

        let viewModel = BookmarkViewModel(
            setNoteLikeUseCase: setNoteLikeUseCase,
            setBookmarkUseCase: setBookmarkUseCase,
            deleteNoteUseCase: deleteNoteUseCase,
            getFavoriteArtistsHavingNotesUseCase: getFavoriteArtistsHavingNotesUseCase,
            getMyNotesByBookmarkUseCase: getMyNotesByBookmarkUseCase
        )
        return viewModel
    }
}

