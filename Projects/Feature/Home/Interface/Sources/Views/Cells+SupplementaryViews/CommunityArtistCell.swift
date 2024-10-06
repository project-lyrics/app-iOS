//
//  CommunityArtistCell.swift
//  FeatureHomeInterface
//
//  Created by 황인우 on 10/1/24.
//

import Domain
import Shared

import UIKit

class CommunityArtistCell: UICollectionViewCell, Reusable {
    
    // MARK: - UI
    
    private let artistImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.isUserInteractionEnabled = true
        
        return imageView
    }()
    
    private let recordLabel: UILabel = {
        let label = UILabel()
        label.font = SharedDesignSystemFontFamily.Pretendard.bold.font(size: 24)
        label.textColor = .white
        
        return label
    }()
    
    private (set) var favoriteArtistSelectButton: FavoriteArtistSelectButton = .init()
    
    // MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setUpDefaults()
        self.setUpLayout()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.artistImageView.pin.all()
        self.artistImageView.flex.layout()
    }
    
    // MARK: - Layout

    private func setUpDefaults() {
        backgroundColor = Colors.background
    }

    private func setUpLayout() {
        self.addSubview(artistImageView)
        
        artistImageView
            .flex
            .alignItems(.center)
            .justifyContent(.end)
            .paddingBottom(28)
            .define { flex in
                flex.addItem(recordLabel)
                    .marginBottom(20)
                
                flex.addItem(favoriteArtistSelectButton)
                    .minHeight(38)
            }
    }
    
    func configure(_ artist: Artist) {
        self.artistImageView.kf.setImage(with: try? artist.imageSource?.asURL())
        self.recordLabel.text = "\(artist.name) 레코드"
        self.favoriteArtistSelectButton.isSelected = artist.isFavorite
        self.recordLabel.flex.markDirty()
        self.artistImageView.kf.setImage(with: try? artist.imageSource?.asURL()) { result in
                switch result {
                case .success:
                    self.artistImageView.flex.markDirty()
                    self.artistImageView.flex.layout()
                case .failure(let error):
                    print("Error loading image: \(error)")
                }
            }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.artistImageView.image = nil
        self.recordLabel.text = nil
        self.favoriteArtistSelectButton = FavoriteArtistSelectButton()
        self.recordLabel.text = nil
        self.recordLabel.text = nil
        self.artistImageView.image = nil
    }
}

#if canImport(SwiftUI)
import SwiftUI

struct CommunityArtistCell_Preview: PreviewProvider {
    static var previews: some View {
        CommunityArtistCell(
            frame: .init(
                x: 0,
                y: 0,
                width: 117,
                height: 300
            )
        ).showPreview()
    }
}

#endif
