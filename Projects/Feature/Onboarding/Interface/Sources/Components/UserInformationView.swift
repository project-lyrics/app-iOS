//
//  UserInformationView.swift
//  FeatureOnboardingInterface
//
//  Created by jiyeon on 6/12/24.
//

import UIKit

import Shared
import Combine
import FlexLayout
import PinLayout

final class UserInformationView: UIView {
    // MARK: - components
    
    private let flexContainer = UIView()
    
    private let navigationBar = NavigationBar()
    
    lazy var backButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false

        let userInterfaceStyle = traitCollection.userInterfaceStyle
        let image = userInterfaceStyle == .light ? FeelinImages.backLight : FeelinImages.backDark
        button.setImage(image, for: .normal)

        return button
    }()

    let skipButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("건너뛰기", for: .normal)
        button.titleLabel?.font = SharedDesignSystemFontFamily.Pretendard.regular.font(size: 16)
        button.setTitleColor(Colors.gray05, for: .normal)
        return button
    }()

    private let titleLabel = {
        let label = UILabel()
        label.text = "추가 정보를 입력해주세요"
        label.font = SharedDesignSystemFontFamily.Pretendard.bold.font(size: 24)
        label.textColor = Colors.gray08
        return label
    }()
    
    private let subTitleLabel = {
        let label = UILabel()
        label.setTextWithLineHeight(
            "서비스 이용 현황 분석을 위해서만 활용되며\n다른 곳엔 사용되지 않아요",
            lineHeight: 20
        )
        label.font = SharedDesignSystemFontFamily.Pretendard.regular.font(size: 14)
        label.textColor = Colors.gray04
        return label
    }()
    
    private lazy var genderTitleLabel = {
        let label = createInformationTitleLabel()
        label.text = "성별"
        return label
    }()
    
    let genderCollectionView = GenderCollectionView()
    
    private lazy var birthYearTitleLabel = {
        let label = createInformationTitleLabel()
        label.text = "출생 연도"
        return label
    }()
    
    let birthYearDropDownButton = FeelinDropDownButton(description: "출생 연도를 입력해주세요")
    
    let nextButton = FeelinConfirmButton(title: "다음")

    // MARK: - init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = Colors.background
        setUpLayout()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - layout

    override func layoutSubviews() {
        super.layoutSubviews()

        flexContainer.pin.all(pin.safeArea)
        flexContainer.flex.layout()
    }
    
    private func setUpLayout() {
        addSubview(flexContainer)

        navigationBar.addLeftBarView([backButton])
        navigationBar.addRightBarView([skipButton])

        flexContainer.flex.paddingHorizontal(20).define { flex in
            flex.addItem(navigationBar)
                .height(44)
                .marginTop(pin.safeArea.top)

            flex.addItem(titleLabel)
                .marginTop(28)
            flex.addItem(subTitleLabel)
                .marginTop(8)
            
            flex.addItem(genderTitleLabel)
                .marginTop(24)
             flex.addItem(genderCollectionView)
                .height(204)
                .marginTop(12)
            
            flex.addItem(birthYearTitleLabel)
                .marginTop(24)
            flex.addItem(birthYearDropDownButton)
                .minHeight(52)
                .marginTop(12)
                .cornerRadius(8)
            
            flex.addItem()
                .grow(1)
            
            flex.addItem(nextButton)
                .minHeight(56)
                .cornerRadius(8)
                .marginBottom(23)
        }
    }
}

private extension UserInformationView {
    func createInformationTitleLabel() -> UILabel {
        let label = UILabel()
        label.font = SharedDesignSystemFontFamily.Pretendard.semiBold.font(size: 16)
        label.textColor = Colors.gray05
        return label
    }
}
