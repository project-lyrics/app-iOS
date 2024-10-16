//
//  NoteNotificationCell.swift
//  FeatureHomeInterface
//
//  Created by 황인우 on 9/29/24.
//

import FlexLayout
import Domain
import Shared

import UIKit

class NoteNotificationCell: UICollectionViewCell, Reusable {
    
    // MARK: - UI
    
    private let flexContainer = UIView()
    
    private let notificationImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        
        return imageView
    }()
    
    private let alertRedDot: UIView = .init()
    
    private let notificationContentLabel: UILabel = {
        let label = UILabel()
        label.font = SharedDesignSystemFontFamily.Pretendard.medium.font(size: 14)
        label.textColor = Colors.gray09
        label.numberOfLines = 3
        
        return label
    }()
    
    private let notificationTimeLabel: UILabel = {
        let label = UILabel()
        label.font = SharedDesignSystemFontFamily.Pretendard.medium.font(size: 12)
        
        return label
    }()
    
    // MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.setUpLayout()
    }
    
    // MARK: - Layout
    
    @available(*, unavailable)
    required  init?(coder: NSCoder) {
        fatalError()
    }
    
    override public func layoutSubviews() {
        super.layoutSubviews()
        
        flexContainer.pin.all()
        flexContainer.flex.layout(mode: .adjustHeight)
    }
    
    private func setUpLayout() {
        self.addSubview(flexContainer)
        
        flexContainer.flex
            .define { flex in
                flex.addItem()
                    .direction(.row)
                    .padding(20)
                    .define { flex in
                        flex.addItem(notificationImageView)
                            .size(.init(width: 36, height: 36))
                            .cornerRadius(18)
                            .marginRight(12)
                        
                        flex.addItem(alertRedDot)
                            .size(.init(width: 4, height: 4))
                            .cornerRadius(4)
                            .backgroundColor(.systemRed)
                            .position(.absolute)
                            .left(52)
                            .top(20)
                        
                        flex.addItem()
                            .grow(1)
                            .shrink(1)
                            .direction(.column)
                            .define { flex in
                                flex.addItem(notificationContentLabel)
                                    .marginBottom(4)
                                
                                flex.addItem(notificationTimeLabel)
                            }
                    }
                
                flex.addItem()
                    .height(1)
                    .width(100%)
                    .backgroundColor(Colors.gray01)
                
            }
    }
    
    func configure(notification: NoteNotification) {
        switch notification.type {
        case .commentOnNote:
            self.notificationImageView.kf.setImage(with: try? notification.image?.asURL())
        case .public, .discipline:
            self.notificationImageView.image = FeelinImages.logo
        }
      
        self.alertRedDot.flex.display(notification.hasRead ? .none : .flex)
        self.notificationContentLabel.text = notification.content
        self.notificationContentLabel.textColor = notification.hasRead ? Colors.gray04 : Colors.gray09
        self.notificationContentLabel.flex.markDirty()
        
        self.notificationTimeLabel.textColor = notification.hasRead ? Colors.gray03 : Colors.gray02
        self.notificationTimeLabel.text = notification.time.formattedTimeInterval()
        self.notificationImageView.layer.opacity = notification.hasRead ? 0.5 : 1.0
        
        flexContainer.flex.layout(mode: .adjustHeight)
        
    }
    
    func markRead(hasRead: Bool) {
        self.alertRedDot.flex.display(hasRead ? .none : .flex)
        self.notificationContentLabel.textColor = hasRead ? Colors.gray04 : Colors.gray09
        self.notificationTimeLabel.textColor = hasRead ? Colors.gray03 : Colors.gray02
        self.notificationImageView.layer.opacity = hasRead ? 0.5 : 1.0
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        self.notificationImageView.image = nil
        self.notificationContentLabel.text = nil
        self.notificationTimeLabel.text = nil
        self.flexContainer.flex.layout()
    }
    
    override func sizeThatFits(_ size: CGSize) -> CGSize {
        self.flexContainer.pin.width(size.width)
        self.flexContainer.flex.layout(mode: .adjustHeight)
        
        return self.flexContainer.frame.size
    }
}
