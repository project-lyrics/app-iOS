//
//  LyricsContentsView.swift
//  SharedDesignSystem
//
//  Created by 황인우 on 8/4/24.
//

import UIKit

import FlexLayout
import PinLayout
import SharedUtil

public class LyricsContentsView: UIView {
    private let flexContainer = UIView()
    
    private let backgroundImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private let lyricsLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 3
        label.font = SharedDesignSystemFontFamily.Pretendard.regular.font(size: 16)
        label.textAlignment = .center
        return label
    }()
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        self.setUpLayout()
    }
    
    @available(*, unavailable)
    public required init?(coder: NSCoder) {
        fatalError()
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        flexContainer.pin.all()
        flexContainer.flex.layout()
    }
    
    private func setUpLayout() {
        self.addSubview(flexContainer)
    }
    
    public func configureView(
        lyricsContent: String,
        backgroundImage: UIImage
    ) {
        self.lyricsLabel.text = lyricsContent
        self.backgroundImageView.image = backgroundImage
        
        flexContainer.flex.define { flex in
            flex.addItem(backgroundImageView).define { flex in
                flex.addItem(lyricsLabel)
                    .alignSelf(.center)
                    .padding(30, 52)
            }
        }
    }
}
