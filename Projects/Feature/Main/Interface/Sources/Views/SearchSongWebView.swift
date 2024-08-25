//
//  SearchSongWebView.swift
//  FeatureMainInterface
//
//  Created by Derrick kim on 8/25/24.
//

import UIKit

import FlexLayout
import PinLayout
import Shared
import Domain
import WebKit

public final class SearchSongWebView: UIView {

    // MARK: - UI Components

    private let flexContainer = UIView()

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = SharedDesignSystemFontFamily.Pretendard.semiBold.font(size: 16)
        label.textColor = Colors.gray09
        label.textAlignment = .left

        label.text = "가사 검색"
        return label
    }()

    let cancelButton: UIButton = {
        let button = UIButton()
        button.setImage(FeelinImages.xLight, for: .normal)
        return button
    }()

    let webView: WKWebView = {
        let webView = WKWebView()
        let url = URL(string: "https://search.naver.com/search.naver?query=%EC%8B%A4%EB%A6%AC%EC%B9%B4%EA%B2%94+no+pain")!
        let urlRequest = URLRequest(url: url)
        webView.load(urlRequest)

        return webView
    }()

    // MARK: - Init

    public override init(frame: CGRect) {
        super.init(frame: frame)

        backgroundColor = Colors.background
        self.setUpLayout()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError()
    }

    public override func layoutSubviews() {
        super.layoutSubviews()

        flexContainer.pin.all()
        flexContainer.flex.layout()
    }

    private func setUpLayout() {
        self.addSubview(flexContainer)

        flexContainer
            .flex
            .direction(.column)
            .marginTop(24)
            .define { flex in
                flex.addItem()
                    .direction(.row)
                    .marginHorizontal(20)
                    .marginBottom(20)
                    .define { flex in
                        flex.addItem(titleLabel)
                            .grow(1)

                        flex.addItem(cancelButton)
                            .size(24)
                    }

                flex.addItem(webView)
                    .height(88%)
                    .marginHorizontal(20)
            }
    }
}

#if canImport(SwiftUI)
import SwiftUI

struct SearchSongWebView_Preview: PreviewProvider {
    static var previews: some View {
        SearchSongWebView(
            frame: .init(x: 0, y: 0, width: 350, height: 514)
        ).showPreview()
    }
}
#endif
