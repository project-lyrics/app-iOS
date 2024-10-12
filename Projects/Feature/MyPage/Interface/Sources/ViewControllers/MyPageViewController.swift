//
//  MyPageViewController.swift
//  FeatureMyPageInterface
//
//  Created by Derrick kim on 10/7/24.
//

import UIKit
import Combine

import Shared
import Domain

public protocol MyPageViewControllerDelegate: AnyObject {
    func pushSettingViewController()
    func pushNoteNotificationViewController()
    func pushEditProfileViewController(userProfile: UserProfile)
    func pushReportViewController(noteID: Int?, commentID: Int?)
    func presentEditNoteViewController(note: Note)
    func popViewController()
    func pushNoteCommentsViewController(noteID: Int)
    func didFinish()
}

public final class MyPageViewController: UIViewController {

    public weak var coordinator: MyPageViewControllerDelegate?

    private let flexContainer = UIView()

    private let myPageTabViewController = MyPageTabViewController()
    private let myPageView = MyPageView()
    private var cancellables = Set<AnyCancellable>()

    private let viewModel: MyPageViewModel

    public init(viewModel: MyPageViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError()
    }

    public override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()

        flexContainer.pin
            .top(self.view.pin.safeArea)
            .horizontally()
            .bottom()

        flexContainer.flex.layout()
    }

    public override func viewDidLoad() {
        super.viewDidLoad()

        setUpDefault()
        setUpLayouts()
        bindAction()
    }

    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.fetchUserProfile()
    }

    private func setUpDefault() {
        view.backgroundColor = Colors.background
        myPageTabViewController.coordinator = self
    }

    private func setUpLayouts() {
        self.view.addSubview(flexContainer)

        flexContainer.flex.define { flex in
            flex.addItem(myPageView)

            flex.addItem(myPageTabViewController.view)
                .marginTop(24)
                .grow(1)
                .shrink(1)
        }
    }

    private func bindAction() {
        settingBarButton.publisher(for: .touchUpInside)
            .sink { [weak self] _ in
                self?.coordinator?.pushSettingViewController()
            }
            .store(in: &cancellables)

        notificationBarButton.publisher(for: .touchUpInside)
            .sink { [weak self] _ in
                self?.coordinator?.pushNoteNotificationViewController()
            }
            .store(in: &cancellables)

        userNicknameContainerView.tapPublisher
            .sink { [weak self] _ in
                guard let self = self, let userProfile = viewModel.fetchedUserProfile
                else { return }
                coordinator?.pushEditProfileViewController(userProfile: userProfile)
            }
            .store(in: &cancellables)

        viewModel.$fetchedUserProfile
            .receive(on: DispatchQueue.main)
            .sink { [weak self] fetchedUserProfile in
                self?.userNicknameLabel.flex.markDirty()
                self?.userNicknameLabel.text = fetchedUserProfile?.nickname
                self?.rootFlexContainer.flex.layout()
            }
            .store(in: &cancellables)

        viewModel.$error
            .compactMap { $0 }
            .sink { [weak self] error in
                self?.showAlert(
                    title: error.localizedDescription,
                    message: nil,
                    singleActionTitle: "확인"
                )
            }
            .store(in: &cancellables)
    }
}

extension MyPageViewController: MyPageTabViewControllerDelegate {
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

extension MyPageViewController {
    var settingBarButton: UIButton {
        return myPageView.settingBarButton
    }

    var notificationBarButton: UIButton {
        return myPageView.notificationBarButton
    }

    var userNicknameContainerView: UIView {
        return myPageView.userNicknameContainerView
    }   

    var userNicknameLabel: UILabel {
        return myPageView.userNicknameLabel
    } 

    var rootFlexContainer: UIView {
        return myPageView.rootFlexContainer
    }
}
