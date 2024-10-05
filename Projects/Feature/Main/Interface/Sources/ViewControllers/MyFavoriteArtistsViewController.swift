//
//  MyFavoriteArtistsViewController.swift
//  FeatureMainInterface
//
//  Created by 황인우 on 10/6/24.
//

import UIKit

import Domain
import Shared

public final class MyFavoriteArtistsViewController: UIViewController {
    
    private let artists: [Artist]
    
    // MARK: - View
    private let myFavoriteArtistsView: MyFavoriteArtistsView = .init()
    
    // MARK: - Init
    
    public init(artists: [Artist]) {
        self.artists = artists
        
        super.init(nibName: nil, bundle: .main)
    }
    
    @available(*, unavailable)
    public required init?(coder: NSCoder) {
        fatalError()
    }
    
    // MARK: - View Lifecycle
    
    override public func loadView() {
        self.view = myFavoriteArtistsView
    }

    override public func viewDidLoad() {
        super.viewDidLoad()
        self.assignDelegates()
        self.bindAction()
        
    }
    
    private func assignDelegates() {
        self.artistCollectionView.delegate = self
        self.artistCollectionView.dataSource = self
    }
    
    private func bindAction() {
        self.closeButton.addTarget(
            self,
            action: #selector(onTapClose),
            for: .touchUpInside
        )
    }
    
    @objc private func onTapClose() {
        // TODO: - dismiss
    }
}

// MARK: - UICollectionViewDelegate

extension MyFavoriteArtistsViewController: UICollectionViewDelegate {
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // TODO: - 커뮤니티 화면으로 이동
    }
}


// MARK: - UICollectionViewDataSource

extension MyFavoriteArtistsViewController: UICollectionViewDataSource {
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.artists.count
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(
            for: indexPath,
            cellType: FeelinArtistCell.self
        )
        
        cell.configure(
            artistName: artists[indexPath.item].name,
            artistImageURL: try? artists[indexPath.item].imageSource?.asURL()
        )
        
        return cell
    }
    
    
}

private extension MyFavoriteArtistsViewController {
    var artistCollectionView: UICollectionView {
        return self.myFavoriteArtistsView.artistCollectionView
    }
    
    var closeButton: UIButton {
        return self.myFavoriteArtistsView.closeButton
    }
}
