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
}

public final class NoteNotificationContainerViewController: UIViewController {
    public weak var coordinator: NoteNotificationContainerViewControllerDelegate?
    private var cancellables: Set<AnyCancellable> = .init()

    private let noteNotificationPageViewController = NoteNotificationPageViewController()

    // MARK: - UI

    private let flexContainer = UIView()
    private let navigationBar = NavigationBar()

    private let backButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(FeelinImages.back, for: .normal)

        return button
    }()

    private var navigationTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "알림"
        label.translatesAutoresizingMaskIntoConstraints = false
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

    private func bindAction() {
        backButton.publisher(for: .touchUpInside)
            .sink { [weak self] _ in
                self?.coordinator?.popViewController()
            }
            .store(in: &cancellables)
    }
}

extension NoteNotificationContainerViewController: NoteNotificationPageViewControllerDelegate {
    public func pushNoteCommentsViewController(noteID: Int) {
        coordinator?.pushNoteCommentsViewController(noteID: noteID)
    }
}
