//
//  HomeView.swift
//  FeatureHomeInterface
//
//  Created by 황인우 on 8/11/24.
//

import Shared

import UIKit

final class HomeView: UIView {

    // MARK: - UI Components

    private let rootFlexContainer = UIView()

    private let appLogoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = FeelinImages.feelinLogo
        imageView.contentMode = .scaleAspectFill

        return imageView
    }()

    let notificationButton: UIButton = {
        let button = UIButton()
        button.setImage(FeelinImages.notificationOff, for: .normal)

        return button
    }()

    private (set) var homeCollectionView: UICollectionView = {
        let compositionalLayout = UICollectionViewCompositionalLayout { (sectionIndex, environment) -> NSCollectionLayoutSection? in
            switch sectionIndex {
            case HomeView.bannerSectionIndex:
                return HomeView.createBannerSection()

            case HomeView.favoriteArtistSectionIndex:
                return HomeView.createArtistSection()

            case HomeView.notesSectionIndex:
                return HomeView.createNotesSection()

            default:
                return nil
            }
        }

        let collectionView = UICollectionView(
            frame: .zero,
            collectionViewLayout: compositionalLayout
        )
        collectionView.refreshControl = UIRefreshControl()
        collectionView.backgroundColor = Colors.background

        collectionView.showsVerticalScrollIndicator = false
        return collectionView
    }()

    // MARK: - Init

    init() {
        super.init(frame: .zero)
        setUpDefaults()
        setUpLayouts()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        super.init(coder: coder)
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

        rootFlexContainer
            .flex
            .direction(.column)
            .define { flex in
                flex.addItem()
                    .alignItems(.center)
                    .marginLeft(20)
                    .marginRight(20)
                    .height(44)
                    .direction(.row)
                    .justifyContent(.spaceBetween)
                    .define { flex in
                        flex.addItem(appLogoImageView)
                            .width(83)
                            .height(24)

                        flex.addItem(notificationButton)
                            .size(24)
                    }

                flex.addItem(homeCollectionView)
                    .grow(1)
                    .shrink(1)
            }
    }
}

// MARK: - UICollectionViewCompositionalLayout

extension HomeView {
    static let bannerSectionIndex = 0
    static let favoriteArtistSectionIndex = 1
    static let notesSectionIndex = 2

    static func createBannerSection() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .absolute(110)
        )

        let item = NSCollectionLayoutItem(layoutSize: itemSize)

        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .absolute(110)
        )

        let group = NSCollectionLayoutGroup.horizontal(
            layoutSize: groupSize,
            subitems: [item]
        )

        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = NSDirectionalEdgeInsets(
            top: 24,
            leading: 20,
            bottom: 24,
            trailing: 20
        )
        return section
    }

    static func createArtistSection() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .absolute(64),
            heightDimension: .absolute(88)
        )

        let item = NSCollectionLayoutItem(layoutSize: itemSize)

        let groupSize = NSCollectionLayoutSize(
            widthDimension: .absolute(64),
            heightDimension: .absolute(88)
        )

        let group = NSCollectionLayoutGroup.horizontal(
            layoutSize: groupSize,
            subitems: [item]
        )

        let headerSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .absolute(24)
        )
        let headerView = NSCollectionLayoutBoundarySupplementaryItem(
            layoutSize: headerSize,
            elementKind: FavoriteArtistsHeaderView.reuseIdentifier,
            alignment: .top
        )

        let footerSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.2),
            heightDimension: .absolute(8)
        )

        let footerView = NSCollectionLayoutBoundarySupplementaryItem(
            layoutSize: footerSize,
            elementKind: SectionDividerView.reuseIdentifier,
            containerAnchor: .init(
                edges: .bottom,
                // 섹션 inset을 무시하여 divider line을 구현하기 위한 offset처리. 추후 다른 방법이 있다면 수정
                absoluteOffset: .init(x: -20, y: 0)
            )
        )

        let section = NSCollectionLayoutSection(group: group)
        section.boundarySupplementaryItems = [headerView, footerView]
        section.orthogonalScrollingBehavior = .continuous
        section.contentInsets = .init(
            top: 23,
            leading: 20,
            bottom: 33,
            trailing: 0
        )
        section.interGroupSpacing = 16
        return section
    }

    static func createNotesSection() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .estimated(300)
        )

        let item = NSCollectionLayoutItem(layoutSize: itemSize)

        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .estimated(300)
        )

        let group = NSCollectionLayoutGroup.vertical(
            layoutSize: groupSize,
            subitems: [item]
        )

        let headerSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .absolute(48)
        )
        let header = NSCollectionLayoutBoundarySupplementaryItem(
            layoutSize: headerSize,
            elementKind: NotesHeaderView.reuseIdentifier,
            alignment: .top
        )

        let section = NSCollectionLayoutSection(group: group)
        section.boundarySupplementaryItems = [header]
        section.contentInsets = .init(
            top: 0,
            leading: 20,
            bottom: 0,
            trailing: 20
        )

        return section
    }
}
