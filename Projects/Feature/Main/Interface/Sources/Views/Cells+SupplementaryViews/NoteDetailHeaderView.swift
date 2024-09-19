//
//  NoteDetailHeaderView.swift
//  FeatureMainInterface
//
//  Created by 황인우 on 9/7/24.
//

import FlexLayout
import Shared

import UIKit

final class NoteDetailHeaderView: UICollectionReusableView, Reusable {
    
    // MARK: - UI components
    
    private var flexContainer = UIView()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "노트"
        label.font = SharedDesignSystemFontFamily.Pretendard.bold.font(size: 18)
        label.textColor = Colors.gray09
        
        return label
    }()
    
    private let noteCountLabel: UILabel = {
        let label = UILabel()
        label.font = SharedDesignSystemFontFamily.Pretendard.bold.font(size: 18)
        label.textColor = Colors.primary
        return label
    }()
    
    private (set) var includeNoteButton: IncludeNoteButton = .init()
    
    // MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.setUpLayout()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        flexContainer.pin.all()
        flexContainer.flex.layout()
    }
    
    private func setUpLayout() {
        self.addSubview(flexContainer)
        
        flexContainer.flex
            .define { flex in
                flex.addItem()
                    .direction(.row)
                    .define { flex in
                        flex.addItem(titleLabel)
                            .paddingRight(3)
                        
                        flex.addItem(noteCountLabel)
                            .grow(1)
                        
                        flex.addItem(includeNoteButton)
                    }
                    .paddingHorizontal(20)
                
                flex.addItem()
                    .height(1)
                    .width(100%)
                    .backgroundColor(Colors.backgroundTertiary)
                    .marginTop(20)
            }
    }
    
    func configureNoteCount(_ count: Int) {
        self.noteCountLabel.text = count.shortenedText()
        self.noteCountLabel.flex.markDirty()
        
        self.flexContainer.flex.layout()
    }
}

//#if canImport(SwiftUI)
//import SwiftUI
//
//struct NoteDetailHeaderView_Preview: PreviewProvider {
//    static var previews: some View {
//        NoteDetailHeaderView(
//            frame: .init(x: 0,
//            y: 0,
//            width: 350,
//            height: 64)
//        )
//        .showPreview()
//    }
//}
//
//#endif
