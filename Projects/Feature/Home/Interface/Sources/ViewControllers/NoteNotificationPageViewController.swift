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

        let noteMyNotificationViewModel = noteNotificationViewDependencies()
        let noteMyNotificationViewController = NoteNotificationViewController(
            indicatorType: .myNotification,
            viewModel: noteMyNotificationViewModel
        )

        noteMyNotificationViewController.coordinator = self

        let noteAllNotificationViewModel = noteNotificationViewDependencies()
        let noteAllNotificationViewController = NoteNotificationViewController(
            indicatorType: .allNotification,
            viewModel: noteAllNotificationViewModel
        )
        noteAllNotificationViewController.coordinator = self

        return [
            noteMyNotificationViewController,
            noteAllNotificationViewController
        ]
    }

    private func noteNotificationViewDependencies() -> NoteNotificationViewModel {
        @Injected(.notificationAPIService)
        var notificationAPIService: NotificationAPIServiceInterface
        @Injected(.notificationPaginationService)
        var notificationPaginationService: NotificationPaginationServiceInterface

        let checkNotificationUseCase:CheckNotificationUseCaseInterface = CheckNotificationUseCase(
            notificationAPIService: notificationAPIService
        )
        let getNotificationUseCase: GetNotificationUseCaseInterface = GetNotificationUseCase(
            notificationAPIService: notificationAPIService,
            notificationPaginationService: notificationPaginationService
        )

        let viewModel = NoteNotificationViewModel(
            checkNotificationUseCase: checkNotificationUseCase,
            getNotificationUseCase: getNotificationUseCase
        )

        return viewModel
    }
}

extension NoteNotificationPageViewController: NoteNotificationViewControllerDelegate {
    public func pushNoteCommentsViewController(noteID: Int) {
        coordinator?.pushNoteCommentsViewController(noteID: noteID)
    }
}
