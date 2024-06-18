//
//  SelectBirthYearView.swift
//  FeatureOnboardingInterface
//
//  Created by jiyeon on 6/19/24.
//

import UIKit

import Shared

import FlexLayout
import PinLayout

public final class SelectBirthYearView: UIView {
    // MARK: - components
    private let flexContainer = UIView()
    
    let doneButton = {
        let button = UIButton()
        button.setTitle("Done", for: .normal)
        button.setTitleColor(Colors.gray09, for: .normal)
        return button
    }()
    
    lazy var pickerView = UIPickerView()
    
    // MARK: - init
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = Colors.background
        setUpLayout()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - layout
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        
        flexContainer.pin.all(pin.safeArea)
        flexContainer.flex.layout()
    }
    
    private func setUpLayout() {
        addSubview(flexContainer)
        flexContainer.flex.paddingHorizontal(20).define { flex in
            flex.addItem(doneButton)
                .marginTop(10)
                .alignSelf(.end)
            
            flex.addItem(pickerView)
                .marginBottom(23)
        }
    }
}
