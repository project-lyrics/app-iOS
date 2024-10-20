//
//  NotePersonalNotificationViewController.swift
//  FeatureHomeInterface
//
//  Created by 황인우 on 9/29/24.
//

import Combine
import UIKit

import Domain
import Shared

public protocol NotePersonalNotificationViewControllerDelegate: AnyObject {
    func pushNoteCommentsViewController(noteID: Int)
    func presentErrorAlert(message: String)
}

public final class NotePersonalNotificationViewController: UIViewController {

    public weak var coordinator: NotePersonalNotificationViewControllerDelegate?

    private let viewModel: NotePersonalNotificationViewModel

    private let noteNotificationView = NoteNotificationView()
    private var cancellables: Set<AnyCancellable> = .init()
    
    // MARK: - Diffable DataSource
    
    private typealias NoteNotificationDataSource = UICollectionViewDiffableDataSource<NotificationListSection, NotificationListRow>
    private typealias NoteNotificationListSnapshot = NSDiffableDataSourceSnapshot<NotificationListSection, NotificationListRow>
        
    private enum NotificationListSection: CaseIterable {
        case main
    }
    
    private enum NotificationListRow: Hashable {
        case noteNotification(NoteNotification)
        case emptyNotification
    }
    
    private lazy var noteNotificationListDataSource: NoteNotificationDataSource = {
        return NoteNotificationDataSource(collectionView: self.noteNotificationCollectionView) { collectionView, indexPath, row in
            switch row {
            case .emptyNotification:
                let cell = collectionView.dequeueReusableCell(
                    for: indexPath,
                    cellType: EmptyNotificationCell.self
                )
                
                return cell
                
            case .noteNotification(let noteNotification):
                let cell = collectionView.dequeueReusableCell(
                    for: indexPath,
                    cellType: NoteNotificationCell.self
                )
                
                cell.configure(notification: noteNotification)
                
                return cell
                
            }
        }
    }()
    
    // MARK: - Init
    
    public init(viewModel: NotePersonalNotificationViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    public required init?(coder: NSCoder) {
        fatalError()
    }
    
    // MARK: - View Lifecycle
    
    public override func loadView() {
        self.view = noteNotificationView
    }

    override public func viewDidLoad() {
        super.viewDidLoad()
        self.setUpDefault()
        self.bindUI()
        self.bindAction()
    }
    
    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.getNotifications(isInitial: true)
    }

    // MARK: - UI Settings
    
    private func setUpDefault() {
        self.view.backgroundColor = Colors.background
        self.noteNotificationCollectionView.delegate = self
    }
    
    private func updateNotificationCollectionView(with noteNotifications: [NoteNotification]) {
        var snapshot = NoteNotificationListSnapshot()
        snapshot.appendSections([.main])
        if noteNotifications.isEmpty {
            snapshot.appendItems([.emptyNotification], toSection: .main)
        } else {
            let rows: [NotificationListRow] = noteNotifications.map { .noteNotification($0)}
            snapshot.appendItems(rows, toSection: .main)
        }
        noteNotificationListDataSource.applySnapshotUsingReloadData(snapshot)
    }
}

// MARK: - UICollectionViewDelegate

extension NotePersonalNotificationViewController: UICollectionViewDelegate {
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // emptyNotificationCell을 탭할 경우 화면전환 및 api콜을 하지 않도록 하는 방지문
        if !self.viewModel.fetchedPersonalNotifications.isEmpty {
            self.viewModel.checkNotification(at: indexPath.row)

            let selectedNotification = self.viewModel.fetchedPersonalNotifications[indexPath.row]

            // 서버와 논의에 따라서 .public, 또는 .discipline이 경우 noteID는 nil일 것이기 때문에 아래와 같이
            // noteID가 not nil인 경우에만 코멘트 화면으로 navigation
            if let noteID = selectedNotification.noteID {
                self.coordinator?.pushNoteCommentsViewController(noteID: noteID)
            }
        }
    }
}

extension NotePersonalNotificationViewController: UICollectionViewDelegateFlowLayout {
    public func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        return .init(
            width: self.view.frame.width,
            height: 500
        )
    }
}

// MARK: - NoteNotificationView

private extension NotePersonalNotificationViewController {
    var noteNotificationCollectionView: UICollectionView {
        return self.noteNotificationView.noteNotificationCollectionView
    }
}

// MARK: - Bindings

private extension NotePersonalNotificationViewController {
    func bindUI() {
        viewModel.$fetchedPersonalNotifications
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { [weak self] notifications in
                self?.updateNotificationCollectionView(with: notifications)
            })
            .store(in: &cancellables)
        
        viewModel.$refreshState
            .receive(on: DispatchQueue.main)
            .sink { [weak self] refreshState in
                switch refreshState {
                case .failed(let error):
                    self?.coordinator?.presentErrorAlert(message: error.errorMessageWithCode)

                case .completed:
                    self?.noteNotificationCollectionView.refreshControl?.endRefreshing()
                    
                default:
                    return
                }
            }
            .store(in: &cancellables)
        
        viewModel.$error
            .receive(on: DispatchQueue.main)
            .compactMap { $0 }
            .sink { [weak self] error in
                self?.coordinator?.presentErrorAlert(message: error.errorMessageWithCode)
            }
            .store(in: &cancellables)
    }
    
    func bindAction() {
        noteNotificationCollectionView
            .didScrollToBottomPublisher()
            .sink { [weak viewModel] in
                viewModel?.getNotifications(isInitial: false)
            }
            .store(in: &cancellables)
        
        noteNotificationCollectionView.refreshControl?.isRefreshingPublisher
            .filter { $0 }
            .sink(receiveValue: { [weak viewModel] _ in
                viewModel?.refreshNotifications()
            })
            .store(in: &cancellables)
    }
}

// MARK: - IndicatorInfoProvider

extension NotePersonalNotificationViewController: IndicatorInfoProvider {
    public func indicatorInfo(for pagerTabStripController: FeelinPagerTabViewController) -> IndicatorInfo {
        return IndicatorInfo(title: "내 소식")
    }
}
