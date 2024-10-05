//
//  NoteNotificationPageViewController.swift
//  FeatureMainInterface
//
//  Created by 황인우 on 9/29/24.
//

import DependencyInjection
import Domain
import Shared

import UIKit

public final class NoteNotificationPageViewController: ButtonBarPagerTabStripViewController {

    override public func viewDidLoad() {
        settings.style.defaultBarBackgroundColor = Colors.gray01
        settings.style.buttonBarBackgroundColor = Colors.background
        settings.style.selectedBarHeight = 2
        settings.style.selectedBarBackgroundColor = Colors.primary
        settings.style.buttonBarItemFont = SharedDesignSystemFontFamily.Pretendard.semiBold.font(size: 16)
        DIContainer.registerNotificationService()
        DIContainer.registerNotificationPaginationService()

        super.viewDidLoad()
    }
    
    override public func viewControllers(for pagerTabStripController: FeelinPagerTabViewController) -> [UIViewController] {

        let noteMyNotificationViewModel = noteNotificationViewDependencies()
        let noteMyNotificationViewController = NoteNotificationViewController(
            indicatorType: .myNotification,
            viewModel: noteMyNotificationViewModel
        )

        let noteAllNotificationViewModel = noteNotificationViewDependencies()
        let noteAllNotificationViewController = NoteNotificationViewController(
            indicatorType: .allNotification,
            viewModel: noteAllNotificationViewModel
        )

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
