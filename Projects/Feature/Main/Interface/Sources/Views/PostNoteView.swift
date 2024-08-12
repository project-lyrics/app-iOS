//
//  PostNoteView.swift
//  FeatureMainInterface
//
//  Created by Derrick kim on 8/4/24.
//

import UIKit
import Shared
import FlexLayout
import PinLayout

final class PostNoteView: UIView {

    private let rootFlexContainer = UIView()
    let rootScrollView = UIScrollView()
    let contentView = UIView()

    private let topDivider: UIView = {
        let view = UIView()
        view.backgroundColor = Colors.gray01

        return view
    }()

    let iconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = FeelinImages.album

        return imageView
    }()

    let addTrackLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "곡을 추가해주세요."
        label.font = SharedDesignSystemFontFamily.Pretendard.medium.font(size: 14)
        label.textColor = Colors.gray04

        return label
    }()

    let titleOfSongLabel: UILabel = {
        let label = UILabel()
        label.font = SharedDesignSystemFontFamily.Pretendard.medium.font(size: 14)
        label.textColor = Colors.gray08

        return label
    }()

    let artistNameLabel: UILabel = {
        let label = UILabel()
        label.textColor = Colors.gray04
        label.font = SharedDesignSystemFontFamily.Pretendard.medium.font(size: 12)

        return label
    }()

    let addToPlayButton: UIButton = {
        let button = UIButton()
        button.setImage(FeelinImages.add, for: .normal)

        return button
    }()

    private let bottomDivider: UIView = {
        let view = UIView()
        view.backgroundColor = Colors.gray01

        return view
    }()

    let lyricsTextView: UITextView = {
        let textView = UITextView()
        textView.text = "좋아하는 가사를 적어주세요 (선택)"
        textView.layer.cornerRadius = 4.0
        textView.textAlignment = .center
        textView.font = SharedDesignSystemFontFamily.Pretendard.regular.font(size: 16)
        textView.tintColor = Colors.gray08
        textView.textColor = Colors.gray04
        textView.isScrollEnabled = false
        textView.backgroundColor = UIColor(patternImage: FeelinImages.image00Default)

        return textView
    }()

    let lyricsCharCountLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .right
        label.textColor = Colors.gray04
        label.font = SharedDesignSystemFontFamily.Pretendard.regular.font(size: 14)
        label.text = "0/50"
        label.lineBreakMode = .byClipping

        return label
    }()

    let selectLyricsBackgroundButton = PostSelectButton()
    let searchLyricsButton = PostSelectButton()

    let noteTextView: UITextView = {
        let textView = UITextView()
        textView.text = "생각을 남겨보세요."
        textView.textAlignment = .left
        textView.font = SharedDesignSystemFontFamily.Pretendard.regular.font(size: 14)
        textView.tintColor = Colors.gray08
        textView.textColor = Colors.gray04
        textView.isScrollEnabled = false

        return textView
    }()

    let noteCharCountLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .right
        label.textColor = Colors.gray04
        label.font = SharedDesignSystemFontFamily.Pretendard.regular.font(size: 14)
        label.text = "0/1000"
        label.lineBreakMode = .byClipping

        return label
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)

        setUpDefaults()
        setUpLayout()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError()
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        rootFlexContainer.pin.all()
        rootScrollView.pin.all()
        contentView.pin.top().left().right()
        contentView.flex.layout(mode: .adjustHeight)
        rootScrollView.contentSize = contentView.frame.size
    }

    private func setUpDefaults() {
        backgroundColor = Colors.background

        selectLyricsBackgroundButton.configure(title: "가사 배경", image: FeelinImages.gallery)
        searchLyricsButton.configure(title: "가사 검색", image: FeelinImages.searchDark)
    }

    private func setUpLayout() {
        addSubview(rootFlexContainer)

        rootScrollView.addSubview(addTrackLabel)

        rootFlexContainer
            .flex
            .define { rootFlex in
                rootFlex.addItem(rootScrollView)
                    .define { rootScrollFlex in

                        rootScrollFlex.addItem(contentView)
                            .direction(.column)
                            .paddingHorizontal(20)
                            .define { contentFlex in
                                artistInfoHeaderView(contentFlex)
                                lyricsTextBodyView(contentFlex)

                                contentFlex.addItem(noteTextView)
                                    .width(100%)
                                    .marginTop(24)
                            }
                    }
            }

        rootFlexContainer.addSubview(noteCharCountLabel)

        NSLayoutConstraint.activate([
            addTrackLabel.centerYAnchor.constraint(
                equalTo: iconImageView.centerYAnchor
            ),
            addTrackLabel.leadingAnchor.constraint(
                equalTo: titleOfSongLabel.leadingAnchor
            )
        ])

        NSLayoutConstraint.activate([
            noteCharCountLabel.bottomAnchor.constraint(
                equalTo: rootFlexContainer.bottomAnchor,
                constant: -33
            ),
            noteCharCountLabel.rightAnchor.constraint(
                equalTo: rootFlexContainer.rightAnchor,
                constant: -20
            )
        ])
    }

    private func artistInfoHeaderView(_ flex: Flex) {
        flex.addItem(topDivider)
            .height(1)
            .width(100%)

        flex.addItem()
            .direction(.row)
            .marginVertical(12)
            .alignItems(.center)
            .define { flex in
                flex.addItem(iconImageView)
                    .size(40)

                flex.addItem()
                    .direction(.column)
                    .marginLeft(10)
                    .grow(1)
                    .define { flex in
                        flex.addItem(titleOfSongLabel)
                        flex.addItem(artistNameLabel)
                    }
                    .view?.isHidden = true

                flex.addItem(addToPlayButton)
                    .size(40)
            }

        flex.addItem(bottomDivider)
            .height(1)
            .width(100%)
    }

    private func lyricsTextBodyView(_ flex: Flex) {
        flex.addItem()
            .direction(.column)
            .define { flex in
                flex.addItem()
                    .direction(.column)
                    .marginTop(20)
                    .define { flex in
                        flex.addItem(lyricsTextView)
                            .height(132)
                            .position(.relative)
                            .define { flex in
                                flex.addItem(lyricsCharCountLabel)
                                    .position(.absolute)
                                    .bottom(16)
                                    .right(16)
                                    .shrink(0)
                                    .width(50)
                            }
                    }

                flex.addItem()
                    .direction(.row)
                    .marginTop(12)
                    .justifyContent(.end)
                    .define { flex in
                        flex.addItem(selectLyricsBackgroundButton)
                            .marginRight(12)

                        flex.addItem(searchLyricsButton)
                    }
            }
    }
}
