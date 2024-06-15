//
//  UserInformationView.swift
//  FeatureOnboardingInterface
//
//  Created by jiyeon on 6/12/24.
//

import UIKit

import SharedDesignSystem
import SharedUtil

import FlexLayout
import PinLayout

final class UserInformationView: UIView {
    // MARK: - components
    
    private let flexContainer = UIView()
    
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
        label.numberOfLines = 2
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
    
    lazy var nextButton = FeelinConfirmButton(title: "다음")
    
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
        flexContainer.flex.padding(20).define { flex in
            flex.addItem(titleLabel)
                .marginTop(46)
            flex.addItem(subTitleLabel)
                .marginTop(13)
            
            flex.addItem(genderTitleLabel)
                .marginTop(26)
             flex.addItem(genderCollectionView)
                .height(204)
                .marginTop(13)
            
            flex.addItem(birthYearTitleLabel)
                .marginTop(26)
            flex.addItem(birthYearDropDownButton)
                .minHeight(52)
                .marginTop(13)
                .cornerRadius(8)
            
            flex.addItem()
                .grow(1)
            
            flex.addItem(nextButton)
                .minHeight(56)
                .cornerRadius(8)
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
