//
//  NoteNotificationContainerViewController.swift
//  FeatureHomeInterface
//
//  Created by 황인우 on 9/29/24.
//

import FlexLayout
import PinLayout
import Shared

import Domain
import Combine
import UIKit

public protocol NoteNotificationContainerViewControllerDelegate: AnyObject {
    func popViewController()
    func pushNoteCommentsViewController(noteID: Int)
    func didFinish()
    func handleError(errorCode: String?, errorMessage: String)
}

public final class NoteNotificationContainerViewController: UIViewController {
    @KeychainWrapper<UserInformation>(.userInfo)
    private var userInfo
    
    @KeychainWrapper<AccessToken>(.accessToken)
    private var accessToken
    
    @KeychainWrapper<RefreshToken>(.refreshToken)
    private var refreshToken
    
    public weak var coordinator: NoteNotificationContainerViewControllerDelegate?
    private var cancellables: Set<AnyCancellable> = .init()
    
    private let errorAlertSubject: PassthroughSubject<NotificationError, Never> = .init()

    private let noteNotificationPageViewController: NoteNotificationPageViewController = .init()

    // MARK: - UI

    private let flexContainer = UIView()
    private let navigationBar = NavigationBar()

    private let backButton: UIButton = {
        let button = UIButton()
        button.setImage(FeelinImages.back, for: .normal)

        return button
    }()

    private var navigationTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "알림"
        label.font = SharedDesignSystemFontFamily.Pretendard.bold.font(size: 18)
        label.textColor = Colors.gray09

        return label
    }()
    
    // MARK: - Init
    
    public override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        self.hidesBottomBarWhenPushed = true
    }
    
    @available(*, unavailable)
    public required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    // MARK: - View Lifecycle

    public override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()

        flexContainer.pin
            .top(view.pin.safeArea)
            .horizontally()
            .bottom()

        flexContainer.flex.layout()
    }

    override public func viewDidLoad() {
        super.viewDidLoad()
        self.setUpDefault()
        self.bindUI()
        self.bindAction()
    }

    private func setUpDefault() {
        self.view.backgroundColor = Colors.background
        self.view.addSubview(flexContainer)
        
        noteNotificationPageViewController.coordinator = self
        navigationBar.addLeftBarView([backButton])
        navigationBar.addTitleView(navigationTitleLabel)

        flexContainer.flex.define { flex in
            flex.addItem(navigationBar)
                .marginHorizontal(10)
                .height(44)

            flex.addItem(noteNotificationPageViewController.view)
        }
    }
    
    private func bindUI() {
        self.errorAlertSubject.eraseToAnyPublisher()
            .sink { [weak self] error in
                self?.coordinator?.handleError(
                    errorCode: error.errorCode,
                    errorMessage: error.userMessage
                )
            }
            .store(in: &cancellables)
    }

    private func bindAction() {
        backButton.publisher(for: .touchUpInside)
            .sink { [weak self] _ in
                self?.coordinator?.popViewController()
            }
            .store(in: &cancellables)
    }
}

extension NoteNotificationContainerViewController: NoteNotificationPageViewControllerDelegate {
    public func didFinish() {
        coordinator?.didFinish()
    }
    
    
    public func pushNoteCommentsViewController(noteID: Int) {
        coordinator?.pushNoteCommentsViewController(noteID: noteID)
    }
    
    public func handleError(
        errorCode: String?,
        errorMessage: String
    ) {
        coordinator?.handleError(errorCode: errorCode, errorMessage: errorMessage)
    }
}
