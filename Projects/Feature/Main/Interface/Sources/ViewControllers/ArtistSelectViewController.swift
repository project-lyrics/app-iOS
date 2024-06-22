//
//  ArtistSelectViewController.swift
//  FeatureMain
//
//  Created by 황인우 on 6/19/24.
//

import UIKit

import Domain
import Shared

public final class ArtistSelectViewController: UIViewController {
    
    // MARK: - 샘플데이터입니다.
    
    var artists: [Artist] = [
        Artist.init(
            name: "검정치마",
            image: UIImage(named: "검정치마")!
        ),
        Artist.init(
            name: "검엑스",
            image: UIImage(named: "검엑스")!
        ),
        Artist.init(
            name: "갤럭시익스프레스",
            image: UIImage(named: "갤럭시익스프레스")!
        ),
        Artist.init(
            name: "국카스텐",
            image: UIImage(named: "국카스텐")!
        ),
        Artist.init(
            name: "검은잎들",
            image: UIImage(named: "검은잎들")!
        ),
        Artist.init(
            name: "글랜체크",
            image: UIImage(named: "글랜체크")!
        ),
        Artist.init(
            name: "넬(NELL)",
            image: UIImage(named: "넬")!
        ),
        Artist.init(
            name: "노브레인",
            image: UIImage(named: "노브레인")!
        ),
        Artist.init(
            name: "노리플라이",
            image: UIImage(named: "노리플라이")!
        ),
        Artist.init(
            name: "나상현씨\n밴드",
            image: UIImage(named: "나상현씨밴드")!
        ),
        Artist.init(
            name: "내귀에도청장치설치했다가 너 혼남 진짜 혼남 리얼팩트",
            image: UIImage(named: "내귀에도청장치")!
        ),
    ]
    
    
    // MARK: - Diffable DataSource
    
    private typealias ArtistListDataSource = UICollectionViewDiffableDataSource<ArtistListSection, Artist>
    private typealias ArtistListSnapshot = NSDiffableDataSourceSnapshot<ArtistListSection, Artist>
    
    private enum ArtistListSection: CaseIterable {
        case main
    }
    
    private lazy var artistListDataSource: ArtistListDataSource = {
        let artistCellRegistration = UICollectionView.CellRegistration<FeelinArtistCell, Artist> { cell, indexPath, artist in
            
            cell.configure(
                artistName: artist.name,
                artistImage: artist.image,
                imageBorderWidth: 2,
                imageBorderInset: 5
            )
            cell.setArtistBorder(color: Colors.disabled)
        }
        
        return ArtistListDataSource(
            collectionView: self.artistCollectionView,
            cellProvider: { collectionView, indexPath, artist -> FeelinArtistCell in
                return collectionView.dequeueConfiguredReusableCell(
                    using: artistCellRegistration,
                    for: indexPath,
                    item: artist
                )
            })
    }()
    
    // MARK: - View
    
    private var artistSelectView: ArtistSelectView = .init()
    
    public override func loadView() {
        self.view = artistSelectView
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        self.assignDelegates()
        
        var snapshot = ArtistListSnapshot()
        snapshot.appendSections([.main])
        snapshot.appendItems(artists, toSection: .main)
        artistListDataSource.applySnapshotUsingReloadData(snapshot)
    }
    
    private func assignDelegates() {
        self.artistCollectionView.delegate = self
    }
}

// MARK: - UICollectionViewDelegate

extension ArtistSelectViewController: UICollectionViewDelegate {
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let cell = collectionView.cellForItem(at: indexPath) as? FeelinArtistCell else {
            return
        }
        
        var updatedArtist = artists[indexPath.row]
        updatedArtist.isFavorite.toggle()
        
        artists[indexPath.row] = updatedArtist
        
        updatedArtist.isFavorite ?
        cell.setArtistBorder(color: Colors.active) :
        cell.setArtistBorder(color: Colors.disabled)
    }
}

// MARK: - ArtistSelectView Subviews

private extension ArtistSelectViewController {
    var artistCollectionView: UICollectionView {
        return self.artistSelectView.artistCollectionView
    }
    
    var closeButton: UIButton {
        return self.artistSelectView.closeButton
    }
    
    var artistSearchBar: FeelinSearchBar {
        return self.artistSelectView.artistSearchBar
    }
    
    var finishSelectButton: FeelinConfirmButton {
        return self.artistSelectView.finishSelectButton
    }
}
