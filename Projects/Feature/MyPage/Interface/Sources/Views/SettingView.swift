//
//  SettingView.swift
//  FeatureMyPageInterface
//
//  Created by Derrick kim on 10/9/24.
//

import UIKit

import Shared

final class SettingView: UIView {
    private let rootFlexContainer = UIView()
    private let navigationBar = NavigationBar()

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "설정"
        label.font = SharedDesignSystemFontFamily.Pretendard.bold.font(size: 18)
        label.textColor = Colors.gray09

        return label
    }()

    private (set) lazy var backButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false

        let userInterfaceStyle = traitCollection.userInterfaceStyle
        let image = userInterfaceStyle == .light ? FeelinImages.backLight : FeelinImages.backDark
        button.setImage(image, for: .normal)

        return button
    }()

    lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.showsVerticalScrollIndicator = false
        tableView.separatorStyle = .none
        tableView.estimatedRowHeight = 45
        tableView.register(cellType: SettingsTableViewCell.self)

        return tableView
    }()

    private let versionTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "버전 정보"
        label.font = SharedDesignSystemFontFamily.Pretendard.regular.font(size: 16)
        label.textColor = Colors.gray09

        return label
    }()

    private let versionLabel: UILabel = {
        let label = UILabel()
        label.font = SharedDesignSystemFontFamily.Pretendard.medium.font(size: 14)
        label.textColor = Colors.gray04

        return label
    }()

    let logoutButton: UIButton = {
        let button = UIButton()
        button.setTitle("로그아웃", for: .normal)
        button.titleLabel?.font = SharedDesignSystemFontFamily.Pretendard.regular.font(size: 16)
        button.setTitleColor(Colors.gray09, for: .normal)

        return button
    }()

    let deleteUserButton: UIButton = {
        let button = UIButton()
        button.setTitle("회원탈퇴", for: .normal)
        button.titleLabel?.font = SharedDesignSystemFontFamily.Pretendard.regular.font(size: 16)
        button.setTitleColor(Colors.gray03, for: .normal)

        return button
    }()

    let bannerImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = FeelinImages.feedbackBanner
        imageView.contentMode = .scaleAspectFill

        return imageView
    }()

    override init(frame: CGRect = .zero) {
        super.init(frame: frame)
        setUpDefaults()
        setUpLayouts()
        configure()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError()
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        rootFlexContainer.pin.all(pin.safeArea)
        rootFlexContainer.flex.layout()
    }

    private func setUpDefaults() {
        backgroundColor = Colors.background
    }

    private func setUpLayouts() {
        addSubview(rootFlexContainer)

        navigationBar.addTitleView(titleLabel)
        navigationBar.addLeftBarView([backButton])

        rootFlexContainer
            .flex
            .direction(.column)
            .define { flex in
                flex.addItem(navigationBar)
                    .height(44)
                    .marginHorizontal(10)

                flex.addItem(tableView)
                    .marginTop(40)
                    .height(240)

                flex.addItem()
                    .marginHorizontal(20)
                    .grow(1)
                    .define { flex in
                        flex.addItem()
                            .direction(.row)
                            .marginBottom(12)
                            .define { flex in
                                flex.addItem(versionTitleLabel)
                                    .grow(1)

                                flex.addItem(versionLabel)
                            }

                        flex.addItem()
                            .direction(.row)
                            .marginBottom(12)
                            .define { flex in
                                flex.addItem(logoutButton)

                                flex.addItem()
                                    .grow(1)
                            }

                        flex.addItem()
                            .direction(.row)
                            .define { flex in
                                flex.addItem(deleteUserButton)

                                flex.addItem()
                                    .grow(1)
                            }
                    }

                flex.addItem(bannerImageView)
                    .marginHorizontal(20)
                    .marginBottom(22)
            }
    }

    private func configure() {
        guard let dictionary = Bundle.main.infoDictionary,
              let version = dictionary["CFBundleShortVersionString"] as? String
        else {
            return
        }

        versionLabel.text = "최신 v.\(version) 사용 중"
    }
}
