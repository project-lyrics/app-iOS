//
//  BlockedUsersViewController.swift
//  FeatureMyPageInterface
//
//  Created by 황인우 on 11/23/24.
//

import Combine
import UIKit

import Domain
import Shared

public protocol BlockedUsersViewControllerDelegate: AnyObject {
    func popViewController()
    func didFinish()
    func handleError(
        errorCode: String?,
        errorMessage: String,
        errorData: AnyType?
    )
}

public class BlockedUsersViewController: UIViewController {
    public weak var coordinator: BlockedUsersViewControllerDelegate?
    
    private var cancellables = Set<AnyCancellable>()
    private let viewModel: BlockedUsersViewModel
    
    // MARK: - DiffableDataSource
    private typealias BlockedUsersDataSource = UICollectionViewDiffableDataSource<CollectionContent.Section, CollectionContent.Item>
    
    private lazy var blockedUsersDataSource: BlockedUsersDataSource = {
        let emptyBlockedUserCellRegistration = UICollectionView.CellRegistration<EmptyBlockedUserCell, Void> {
            cell, indexPath, _ in
        }
        let blockedUserCellRegistration = UICollectionView.CellRegistration<BlockedUserCell, User> { cell, indexPath, user in
            cell.configure(
                userName: user.nickname,
                characterImage: user.profileCharacterType.image
            )
            
            cell.unblockUserButton.publisher(for: .touchUpInside)
                .sink { [weak self] _ in
                    self?.unblockUser(id: user.id)
                }
                .store(in: &cell.cancellables)
        }
        
        let dataSource = BlockedUsersDataSource(collectionView: self.blockedUsersCollectionView) { collectionView, indexPath, itemIdentifier in
            switch itemIdentifier {
            case .blockedUser(let user):
                return collectionView.dequeueConfiguredReusableCell(
                    using: blockedUserCellRegistration,
                    for: indexPath,
                    item: user
                )
                
            case .empty:
                return collectionView.dequeueConfiguredReusableCell(
                    using: emptyBlockedUserCellRegistration,
                    for: indexPath,
                    item: ()
                )
            }
        }
        
        return dataSource
    }()
    
    // MARK: - View
    
    private let blockedUsersView = BlockedUsersView()
    
    // MARK: - Init
    
    public init(viewModel: BlockedUsersViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    @available(*, unavailable)
    public required init?(coder: NSCoder) {
        fatalError()
    }
    
    // MARK: - View Lifecycle
    
    public override func loadView() {
        self.view = blockedUsersView
    }

    override public func viewDidLoad() {
        super.viewDidLoad()
        setUpDefault()
        bindData()
        bindUI()
        bindAction()
    }
    
    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchBlockedUsers()
    }
    
    private func setUpDefault() {
        self.blockedUsersCollectionView.delegate = self
    }
    
    private func fetchBlockedUsers() {
        self.viewModel.fetchBlockedUsers()
    }
    
    private func unblockUser(id: Int) {
        self.viewModel.unblockUser(id: id)
    }
    
    private func updateUsers(_ users: [User]) {
        var snapshot = blockedUsersDataSource.snapshot()
        
        var newItems: [CollectionContent.Item] = []
        
        if users.isEmpty {
            newItems = [CollectionContent.Item.empty]
        } else {
            newItems = users.map { CollectionContent.Item.blockedUser($0)}
        }
        
        if snapshot.sectionIdentifiers.contains(.main) {
            let currentItems = snapshot.itemIdentifiers(inSection: .main)
            
            if currentItems != newItems {
                snapshot.deleteItems(currentItems)
                snapshot.appendItems(newItems)
            }
            
        } else {
            snapshot.appendSections([.main])
            snapshot.appendItems(newItems)
            
        }
        blockedUsersDataSource.apply(snapshot)
    }
    
    private func bindUI() {
        viewModel.$error
            .compactMap { $0 }
            .sink { [weak self] error in
                self?.coordinator?.handleError(
                    errorCode: error.errorCode,
                    errorMessage: error.userMessage,
                    errorData: error.data
                )
            }
            .store(in: &cancellables)
        
        viewModel.$unblockUserResult
            .sink { [weak self] result in
                switch result {
                case .success:
                    self?.showToast(
                        iconImage: FeelinImages.checkBoxActive,
                        message: "차단 해제되었습니다"
                    )
                    
                case .failure(let error):
                    self?.coordinator?.handleError(
                        errorCode: error.errorCode,
                        errorMessage: error.userMessage,
                        errorData: error.data
                    )
                    
                default:
                    return
                }
            }
            .store(in: &cancellables)
    }
    
    private func bindData() {
        viewModel.$fetchedUsers
            .sink { [weak self] fetchedUsers in
                self?.updateUsers(fetchedUsers)
            }
            .store(in: &cancellables)
    }
    
    private func bindAction() {
        self.backButton.publisher(for: .touchUpInside)
            .sink { [weak self] _ in
                self?.coordinator?.popViewController()
            }
            .store(in: &cancellables)
    }
}

// MARK: - UICollectionViewDelegateFlowLayout

extension BlockedUsersViewController: UICollectionViewDelegateFlowLayout {
    public func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        guard let item = blockedUsersDataSource.itemIdentifier(for: indexPath) else {
            return .zero
        }
        
        switch item {
        case .blockedUser:
            return CGSize(
                width: collectionView.frame.width,
                height: 72
            )
            
        case .empty:
            return CGSize(
                width: collectionView.frame.width,
                height: collectionView.frame.height
            )
        }
    }
}

// MARK: - CollectionContent

struct CollectionContent {
    enum Section: Hashable {
        case main
    }
    
    enum Item: Hashable {
        case blockedUser(User)
        case empty
    }
}

// MARK: - Subviews

extension BlockedUsersViewController {
    var blockedUsersCollectionView: UICollectionView {
        return blockedUsersView.blockedUsersCollectionView
    }
    
    var backButton: UIButton {
        return blockedUsersView.backButton
    }
}
