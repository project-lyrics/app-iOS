//
//  WritingNoteView.swift
//  FeatureHomeInterface
//
//  Created by Derrick kim on 8/4/24.
//

import UIKit
import Shared
import Domain

import Kingfisher
import FlexLayout
import PinLayout

public final class WritingNoteView: UIView {

    let rootFlexContainer = UIView()
    let artistInfoHeaderView = UIView()
    let noteCharCountContainerView = UIView()

    private let navigationBar = NavigationBar()

    public lazy var closeButton: UIButton = {
        let button = UIButton()
        button.setImage(FeelinImages.x, for: .normal)

        return button
    }()

    private let naviTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "노트 작성"
        label.font = SharedDesignSystemFontFamily.Pretendard.bold.font(size: 18)
        label.textColor = Colors.gray09

        return label
    }()

    public lazy var completeButton = FeelinConfirmButton(
        initialEnabled: false,
        title: "완료",
        setting: .text
    )

    public let rootScrollView = UIScrollView()
    public let contentView = UIView()

    private let topDivider: UIView = {
        let view = UIView()
        view.backgroundColor = Colors.gray01

        return view
    }()

    private let iconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 4
        imageView.image = FeelinImages.album

        return imageView
    }()

    private let addTrackLabel: UILabel = {
        let label = UILabel()
        label.text = "곡을 추가해주세요."
        label.font = SharedDesignSystemFontFamily.Pretendard.medium.font(size: 14)
        label.textColor = Colors.gray04

        return label
    }()

    private let titleOfSongLabel: UILabel = {
        let label = UILabel()
        label.font = SharedDesignSystemFontFamily.Pretendard.medium.font(size: 14)
        label.textColor = Colors.gray08

        return label
    }()

    private let artistNameLabel: UILabel = {
        let label = UILabel()
        label.textColor = Colors.gray04
        label.font = SharedDesignSystemFontFamily.Pretendard.medium.font(size: 12)

        return label
    }()

    private let addToPlayButton: UIButton = {
        let button = UIButton()
        button.setImage(FeelinImages.add, for: .normal)

        return button
    }()

    private let bottomDivider: UIView = {
        let view = UIView()
        view.backgroundColor = Colors.gray01

        return view
    }()

    public let lyricsTextView: UITextView = {
        let textView = UITextView()
        textView.text = "좋아하는 가사를 적어주세요 (선택)"
        textView.layer.cornerRadius = 4.0
        textView.textAlignment = .center
        textView.font = SharedDesignSystemFontFamily.Pretendard.regular.font(size: 16)
        textView.tintColor = Colors.gray08.resolvedColor(with: UITraitCollection(userInterfaceStyle: .light))
        textView.textColor = Colors.gray02.resolvedColor(with: UITraitCollection(userInterfaceStyle: .light))
        textView.isScrollEnabled = false
        textView.backgroundColor = UIColor(patternImage: FeelinImages.image00Default)
        textView.textContainer.maximumNumberOfLines = 3
        textView.textContainer.lineBreakMode = .byTruncatingTail

        return textView
    }()

    public let lyricsCharCountLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .right
        label.textColor = Colors.gray02.resolvedColor(with: UITraitCollection(userInterfaceStyle: .light))
        label.font = SharedDesignSystemFontFamily.Pretendard.regular.font(size: 14)
        label.text = "0/50"

        return label
    }()

    public let selectLyricsBackgroundButton = PostSelectButton()
    public let searchLyricsButton = PostSelectButton()

    public let noteTextView: UITextView = {
        let textView = UITextView()
        textView.text = "생각을 남겨보세요."
        textView.textAlignment = .left
        textView.font = SharedDesignSystemFontFamily.Pretendard.regular.font(size: 14)
        textView.tintColor = Colors.gray08
        textView.textColor = Colors.gray04
        textView.isScrollEnabled = false
        textView.backgroundColor = .clear

        return textView
    }()

    public let noteCharCountLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .right
        label.textColor = Colors.gray04
        label.font = SharedDesignSystemFontFamily.Pretendard.regular.font(size: 14)
        label.text = "0/1000"

        return label
    }()

    private var keyboardHeightConstraint: NSLayoutConstraint?

    public override init(frame: CGRect) {
        super.init(frame: frame)

        setUpDefaults()
        setUpLayout()
    }

    public override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        endEditing(true)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError()
    }

    public override func layoutSubviews() {
        super.layoutSubviews()

        rootFlexContainer.pin
            .top(pin.safeArea.top)
            .left(pin.safeArea.left)
            .right(pin.safeArea.right)
            .bottom(pin.safeArea.bottom + 12)

        rootFlexContainer.flex.layout()

        rootScrollView.pin
            .below(of: navigationBar)
            .left()
            .right()
            .bottom()

        contentView.pin.top().left().right()

        contentView.flex.layout(mode: .adjustHeight)
        rootScrollView.contentSize = contentView.frame.size
    }

    private func setUpDefaults() {
        backgroundColor = Colors.background

        selectLyricsBackgroundButton.configure(title: "가사 배경", image: FeelinImages.gallery)
        searchLyricsButton.configure(title: "가사 검색", image: FeelinImages.search)
    }

    private func setUpLayout() {
        addSubview(rootFlexContainer)

        navigationBar.addLeftBarView([closeButton])
        navigationBar.addTitleView(naviTitleLabel)
        navigationBar.addRightBarView([completeButton])

        rootFlexContainer
            .flex
            .define { rootFlex in
                rootFlex.addItem(navigationBar)
                    .height(44)
                    .marginTop(pin.safeArea.top)
                    .marginHorizontal(10)

                rootFlex.addItem(rootScrollView)
                    .paddingHorizontal(20)
                    .marginTop(16)
                    .define { rootScrollFlex in
                        rootScrollFlex.addItem(contentView)
                            .paddingHorizontal(20)
                            .define { contentFlex in
                                artistInfoHeaderView(contentFlex)
                                lyricsTextBodyView(contentFlex)

                                contentFlex.addItem(noteTextView)
                                    .marginTop(24)
                                    .width(100%)

                                contentFlex.addItem(noteCharCountContainerView)
                                    .maxHeight((UIScreen.main.bounds.height * 0.435) + 17)
                                    .grow(1)
                                    .define { flex in
                                        flex.addItem(noteCharCountLabel)
                                            .position(.absolute)
                                            .bottom(0)
                                            .right(0)
                                            .shrink(0)
                                            .grow(0)
                                            .width(70)
                                    }
                            }
                    }
            }
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
                    .marginLeft(10)
                    .grow(1)
                    .define { flex in
                        flex.addItem(addTrackLabel)
                            .width(100%)
                            .height(100%)

                        flex.addItem()
                            .position(.absolute)
                            .top(2)
                            .bottom(2)
                            .left(0)
                            .width(100%)
                            .define { flex in
                                flex.addItem(titleOfSongLabel)
                                    .view?.isHidden = true
                                flex.addItem(artistNameLabel)
                                    .marginTop(4)
                                    .view?.isHidden = true
                            }
                    }

                flex.addItem(addToPlayButton)
                    .size(40)
            }

        flex.addItem(artistInfoHeaderView)
            .position(.absolute)
            .top(12)
            .bottom(12)
            .left(20)
            .right(20)
            .height(40) // 적절한 높이 설정
            .backgroundColor(.clear)

        flex.addItem(bottomDivider)
            .height(1)
            .width(100%)
    }

    private func lyricsTextBodyView(_ flex: Flex) {
        flex.addItem()
            .define { flex in
                flex.addItem()
                    .marginTop(20)
                    .define { flex in
                        flex.addItem(lyricsTextView)
                            .height(132)
                            .width(100%)
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

    public func configure(_ item: Song) {
        let imageUrl = URL(string: item.imageUrl)
        iconImageView.kf.setImage(with: imageUrl)

        titleOfSongLabel.text = item.name
        artistNameLabel.text = item.artist.name

        addToPlayButton.setImage(FeelinImages.selectedSongActive, for: .normal)

        addTrackLabel.isHidden = true
        titleOfSongLabel.isHidden = false
        artistNameLabel.isHidden = false

        titleOfSongLabel.flex.markDirty()
        artistNameLabel.flex.markDirty()
    }
}
