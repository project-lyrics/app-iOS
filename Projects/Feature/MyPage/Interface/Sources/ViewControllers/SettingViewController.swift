//
//  SettingViewController.swift
//  FeatureMyPageInterface
//
//  Created by Derrick kim on 10/9/24.
//

import UIKit
import Combine

import Shared

public protocol SettingViewControllerDelegate: AnyObject {
    func popViewController()
    func pushUserInfoViewController()
    func didFinish()
}

public final class SettingViewController: UIViewController {

    private let settingView = SettingView()

    public weak var coordinator: SettingViewControllerDelegate?
    private var cancellables = Set<AnyCancellable>()

    // MARK: - Diffable DataSource

    private typealias SettingListDataSource = UITableViewDiffableDataSource<SettingSection, ServiceInfoRow>
    private typealias SettingListSnapshot = NSDiffableDataSourceSnapshot<SettingSection, ServiceInfoRow>

    private enum SettingSection {
        case userInfo
        case serviceInfo
    }

    private lazy var settingListDataSource: SettingListDataSource = makeDataSource()

    private let viewModel: SettingViewModel

    public init(viewModel: SettingViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError()
    }

    public override func loadView() {
        view = settingView
    }

    public override func viewDidLoad() {
        super.viewDidLoad()

        setUpDefault()
        bindData()
        bindAction()
    }

    private func setUpDefault() {
        view.backgroundColor = Colors.background

        settingInfoTableView.delegate = self
    }

    private func bindData() {
        let sectionData = ServiceInfoRow.allCases.map { $0 }
        updateSettingInfoTableView(with: sectionData)
    }

    private func bindAction() {
        backButton.publisher(for: .touchUpInside)
            .sink { [weak self] _ in
                self?.coordinator?.popViewController()
            }
            .store(in: &cancellables)

        logoutButton.publisher(for: .touchUpInside)
            .sink { [weak self] _ in
                self?.viewModel.removeUser()
                self?.coordinator?.didFinish()
            }
            .store(in: &cancellables)

        deleteUserButton.publisher(for: .touchUpInside)
            .sink { [weak self] _ in
                self?.viewModel.deleteUserInfo()
                self?.coordinator?.didFinish()
            }
            .store(in: &cancellables)

        bannerImageView.tapPublisher
            .sink { [weak self] _ in
                // TODO: 구글폼으로 이동
                self?.openWebBrowser(urlStr: "")
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

    private func makeDataSource() -> SettingListDataSource {
        return SettingListDataSource(
            tableView: self.settingInfoTableView,
            cellProvider: { tableView, indexPath, item -> SettingsTableViewCell in
                let cell: SettingsTableViewCell = tableView.dequeueReusableCell(for: indexPath)
                cell.configure(info: item.title)
                cell.selectionStyle = .none

                return cell
            })
    }

    private func updateSettingInfoTableView(with data: [ServiceInfoRow]) {
        let userInfoSectionData = [data[0]]
        let serviceInfoData = data[1...].map { $0 }

        var snapshot = SettingListSnapshot()
        snapshot.appendSections([.userInfo, .serviceInfo])
        snapshot.appendItems(userInfoSectionData, toSection: .userInfo)
        snapshot.appendItems(serviceInfoData, toSection: .serviceInfo)
        settingListDataSource.applySnapshotUsingReloadData(snapshot)
    }

    private func openWebBrowser(urlStr: String) {
        guard let url = URL(string: urlStr) else {
            return
        }
        UIApplication.shared.open(url)
    }
}

// MARK: UITableViewDelegate

extension SettingViewController: UITableViewDelegate {
    public func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let footerView = UIView()
        footerView.backgroundColor = .clear

        let dividerView = UIView()
        dividerView.backgroundColor = Colors.gray01
        dividerView.translatesAutoresizingMaskIntoConstraints = false

        footerView.addSubview(dividerView)

        NSLayoutConstraint.activate([
            dividerView.topAnchor.constraint(equalTo: footerView.topAnchor),
            dividerView.bottomAnchor.constraint(equalTo: footerView.bottomAnchor, constant: -24),
            dividerView.leadingAnchor.constraint(equalTo: footerView.leadingAnchor),
            dividerView.trailingAnchor.constraint(equalTo: footerView.trailingAnchor),
            dividerView.heightAnchor.constraint(equalToConstant: 8)
        ])

        return footerView
    }

    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let item = settingListDataSource.itemIdentifier(for: indexPath) else { return }

        switch item {
        case .userInfo:
            coordinator?.pushUserInfoViewController()

        case .serviceUsage,
                .personalInfo,
                .serviceInquiry:
            openWebBrowser(urlStr: item.url)
        }
    }
}

private extension SettingViewController {
    var backButton: UIButton {
        return settingView.backButton
    }

    var settingInfoTableView: UITableView {
        return settingView.tableView
    }

    var logoutButton: UIButton {
        return settingView.logoutButton
    }

    var deleteUserButton: UIButton {
        return settingView.deleteUserButton
    }

    var bannerImageView: UIImageView {
        return settingView.bannerImageView
    }
}
