//
//  NoteNotificationPageViewController.swift
//  FeatureHomeInterface
//
//  Created by 황인우 on 9/29/24.
//

import DependencyInjection
import Domain
import Shared

import UIKit

public protocol NoteNotificationPageViewControllerDelegate: AnyObject {
    func pushNoteCommentsViewController(noteID: Int)
    func presentErrorAlert(message: String)
}

public final class NoteNotificationPageViewController: ButtonBarPagerTabStripViewController {
    public weak var coordinator: NoteNotificationPageViewControllerDelegate?

    override public func viewDidLoad() {
        settings.style.defaultBarBackgroundColor = Colors.gray01
        settings.style.buttonBarBackgroundColor = Colors.background
        settings.style.buttonBarItemTitleColor = Colors.gray03
        settings.style.selectedBarHeight = 2
        settings.style.selectedBarBackgroundColor = Colors.primary
        settings.style.buttonBarItemFont = SharedDesignSystemFontFamily.Pretendard.semiBold.font(size: 16)

        DIContainer.registerNotificationService()
        DIContainer.registerNotificationPaginationService()

        changeCurrentIndexProgressive = { (oldCell: ButtonBarViewCell?, newCell: ButtonBarViewCell?, progressPercentage: CGFloat, changeCurrentIndex: Bool, animated: Bool) -> Void in
            guard changeCurrentIndex == true else { return }
            oldCell?.label.textColor = Colors.gray03
            newCell?.label.textColor = Colors.primary
        }

        super.viewDidLoad()
    }

    override public func viewControllers(for pagerTabStripController: FeelinPagerTabViewController) -> [UIViewController] {

        let notePersonalNotificationViewModel = notePersonalNotificationViewDependencies()
        let notePersonalNotificationViewController = NotePersonalNotificationViewController(
            viewModel: notePersonalNotificationViewModel
        )

        notePersonalNotificationViewController.coordinator = self

        let notePublicNotificationViewModel = notePublicNotificationViewDependencies()
        let notePublicNotificationPageViewController = NotePublicNotificationViewController(
            viewModel: notePublicNotificationViewModel
        )
        notePublicNotificationPageViewController.coordinator = self

        return [
            notePersonalNotificationViewController,
            notePublicNotificationPageViewController
        ]
    }

    private func notePersonalNotificationViewDependencies() -> NotePersonalNotificationViewModel {
        @Injected(.notificationAPIService)
        var notificationAPIService: NotificationAPIServiceInterface
        @Injected(.notificationPaginationService)
        var personalNotificationPaginationService: NotificationPaginationServiceInterface

        let checkNotificationUseCase:CheckNotificationUseCaseInterface = CheckNotificationUseCase(
            notificationAPIService: notificationAPIService
        )
        let getPersonalNotificationUseCase: GetNotificationUseCaseInterface = GetPersonalNotificationUseCase(
            notificationAPIService: notificationAPIService,
            notificationPaginationService: personalNotificationPaginationService
        )

        let viewModel = NotePersonalNotificationViewModel(
            checkNotificationUseCase: checkNotificationUseCase,
            getPersonalNotificationUseCase: getPersonalNotificationUseCase
        )

        return viewModel
    }

    private func notePublicNotificationViewDependencies() -> NotePublicNotificationViewModel {
        @Injected(.notificationAPIService)
        var notificationAPIService: NotificationAPIServiceInterface
        let publicNotificationPaginationService: NotificationPaginationServiceInterface = NotificationPaginationService()

        let checkNotificationUseCase:CheckNotificationUseCaseInterface = CheckNotificationUseCase(
            notificationAPIService: notificationAPIService
        )

        let getPublicNotificationUseCase: GetNotificationUseCaseInterface = GetPublicNotificationUseCase(
            notificationAPIService: notificationAPIService,
            notificationPaginationService: publicNotificationPaginationService
        )
        
        let viewModel = NotePublicNotificationViewModel(
            checkNotificationUseCase: checkNotificationUseCase,
            getPublicNotificationUseCase: getPublicNotificationUseCase
        )

        return viewModel
    }
}

extension NoteNotificationPageViewController: NotePersonalNotificationViewControllerDelegate,
                                              NotePublicNotificationViewControllerDelegate {
    public func pushNoteCommentsViewController(noteID: Int) {
        coordinator?.pushNoteCommentsViewController(noteID: noteID)
    }

    public func presentErrorAlert(message: String) {
        coordinator?.presentErrorAlert(message: message)
    }
}
