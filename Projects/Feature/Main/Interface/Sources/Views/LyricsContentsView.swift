//
//  LyricsContentsView.swift
//  FeatureMainInterface
//
//  Created by 황인우 on 8/22/24.
//

import UIKit

import FlexLayout
import PinLayout
import Domain
import Shared

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
    
    public func configureView(with lyrics: Lyrics?) {
        self.lyricsLabel.text = lyrics?.content
        self.backgroundImageView.image = lyrics?.background.image
        
        switch lyrics?.background {
        case .black, .red:
            self.lyricsLabel.textColor = .white
            
        default:
            self.lyricsLabel.textColor = Colors.fixedGray08
        }
        
        
        flexContainer.flex.define { flex in
            flex.addItem(backgroundImageView)
                .justifyContent(.center)
                .alignItems(.center)
                .define { flex in
                    flex.addItem(lyricsLabel)
                        .height(60)
                        .width(240)
                }
                .height(132)
        }
    }
}
