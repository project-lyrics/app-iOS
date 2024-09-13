//
//  PostNoteView.swift
//  FeatureMainInterface
//
//  Created by Derrick kim on 8/4/24.
//

import UIKit
import Shared
import Domain

import Kingfisher
import FlexLayout
import PinLayout

final class PostNoteView: UIView {

    private let rootFlexContainer = UIView()
    private let navigationBar = NavigationBar()

    lazy var closeButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(FeelinImages.xLight, for: .normal)

        return button
    }()

    private let naviTitleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "노트 작성"
        label.font = SharedDesignSystemFontFamily.Pretendard.bold.font(size: 18)
        label.textColor = Colors.gray09

        return label
    }()

    lazy var completeButton = FeelinConfirmButton(
        initialEnabled: false,
        title: "완료",
        setting: .text
    )

    let rootScrollView = UIScrollView()
    let contentView = UIView()

    private let topDivider: UIView = {
        let view = UIView()
        view.backgroundColor = Colors.gray01

        return view
    }()

    private let iconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = FeelinImages.album

        return imageView
    }()

    private let addTrackLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "곡을 추가해주세요."
        label.font = SharedDesignSystemFontFamily.Pretendard.medium.font(size: 14)
        label.textColor = Colors.gray04

        return label
    }()

    private let titleOfSongLabel: UILabel = {
        let label = UILabel()
        label.font = SharedDesignSystemFontFamily.Pretendard.medium.font(size: 14)
        label.textColor = Colors.gray08
        label.text = "NO PAIN"

        return label
    }()

    private let artistNameLabel: UILabel = {
        let label = UILabel()
        label.textColor = Colors.gray04
        label.font = SharedDesignSystemFontFamily.Pretendard.medium.font(size: 12)
        label.text = "실리카겔"

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
        textView.textContainer.maximumNumberOfLines = 3
        textView.textContainer.lineBreakMode = .byTruncatingTail

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

    private var keyboardHeightConstraint: NSLayoutConstraint?

    override init(frame: CGRect) {
        super.init(frame: frame)

        setUpDefaults()
        setUpLayout()
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        endEditing(true)
    }

    deinit {
        removeKeyboardObservers()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError()
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        rootFlexContainer.pin.all(pin.safeArea)
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
        searchLyricsButton.configure(title: "가사 검색", image: FeelinImages.searchDark)

        setUpKeyboardEvent()
    }

    private func setUpLayout() {
        addSubview(rootFlexContainer)

        navigationBar.addLeftBarView(closeButton)
        navigationBar.addTitleView(naviTitleLabel)
        navigationBar.addRightBarView(completeButton)

        rootFlexContainer
            .flex
            .paddingHorizontal(20)
            .direction(.column)
            .define { rootFlex in
                rootFlex.addItem(navigationBar)
                    .height(44)
                    .marginTop(pin.safeArea.top)

                rootFlex.addItem(rootScrollView)
                    .direction(.column)
                    .marginTop(16)
                    .define { rootScrollFlex in
                        rootScrollFlex.addItem(contentView)
                            .paddingHorizontal(20)
                            .direction(.column)
                            .define { contentFlex in
                                artistInfoHeaderView(contentFlex)
                                lyricsTextBodyView(contentFlex)

                                contentFlex.addItem(noteTextView)
                                    .width(100%)
                                    .marginTop(24)
                            }
                    }
            }

        rootScrollView.addSubview(addTrackLabel)
        addSubview(noteCharCountLabel)

        NSLayoutConstraint.activate([
            addTrackLabel.centerYAnchor.constraint(
                equalTo: iconImageView.centerYAnchor
            ),
            addTrackLabel.leadingAnchor.constraint(
                equalTo: iconImageView.trailingAnchor,
                constant: 10
            )
        ])

        keyboardHeightConstraint = noteCharCountLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -33)
        keyboardHeightConstraint?.isActive = true

        NSLayoutConstraint.activate([
            noteCharCountLabel.trailingAnchor.constraint(
                equalTo: trailingAnchor,
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
                            .view?.isHidden = true
                        flex.addItem(artistNameLabel)
                            .view?.isHidden = true
                    }

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

    private func setUpKeyboardEvent() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillShow),
            name: UIResponder.keyboardWillShowNotification,
            object: nil
        )
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillHide),
            name: UIResponder.keyboardWillHideNotification,
            object: nil
        )
    }

    private func removeKeyboardObservers() {
        NotificationCenter.default.removeObserver(
            self,
            name: UIResponder.keyboardWillShowNotification,
            object: nil
        )
        NotificationCenter.default.removeObserver(
            self,
            name: UIResponder.keyboardWillHideNotification,
            object: nil
        )
    }

    @objc private func keyboardWillShow(notification: NSNotification) {
        if let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect {
            let keyboardHeight = keyboardFrame.height
            rootScrollView.contentInset.bottom = keyboardHeight
            rootScrollView.verticalScrollIndicatorInsets.bottom = keyboardHeight

            keyboardHeightConstraint?.constant = -keyboardHeight - 12
            UIView.animate(withDuration: 0.3) {
                self.layoutIfNeeded()
            }
        }
    }

    @objc private func keyboardWillHide(notification: NSNotification) {
        rootScrollView.contentInset.bottom = 0
        rootScrollView.verticalScrollIndicatorInsets.bottom = 0

        keyboardHeightConstraint?.constant = -12
        UIView.animate(withDuration: 0.3) {
            self.layoutIfNeeded()
        }
    }

    func configure(_ item: Song) {
        let imageUrl = URL(string: item.imageUrl)
        iconImageView.kf.setImage(with: imageUrl)

        titleOfSongLabel.text = item.name
        artistNameLabel.text = item.artist.name

        addToPlayButton.setImage(FeelinImages.play, for: .normal)

        addTrackLabel.isHidden = true
        titleOfSongLabel.isHidden = false
        artistNameLabel.isHidden = false
    }
}
