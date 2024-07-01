//
//  SelectBirthYearViewController.swift
//  FeatureOnboardingInterface
//
//  Created by jiyeon on 6/19/24.
//

import UIKit

import Shared

protocol SelectBirthYearDelegate: AnyObject {
    func setBitrhYear(year: Int)
}

public final class SelectBirthYearViewController: BottomSheetViewController<SelectBirthYearView> {
    private let currentYear = Calendar.current.component(.year, from: Date())
    private let minYear = Calendar.current.component(.year, from: Date()) - 100
    private let maxYear = Calendar.current.component(.year, from: Date()) - 14
    private var selectedYear: Int
    
    weak var delegate: SelectBirthYearDelegate?
    
    // MARK: - init
    
    public init(bottomSheetHeight: CGFloat, baseYear: Int) {
        self.selectedYear = baseYear
        
        super.init(bottomSheetHeight: bottomSheetHeight)
        
        setUpPickerView(baseYear: baseYear)
        setUpAction()
    }
    
    private func setUpPickerView(baseYear: Int) {
        pickerView.delegate = self
        pickerView.dataSource = self
        
        let baseYearIndex = baseYear - minYear
        pickerView.selectRow(baseYearIndex, inComponent: 0, animated: false)
    }
    
    private func setUpAction() {
        doneButton.addTarget(
            self,
            action: #selector(doneButtonDidTap),
            for: .touchUpInside
        )
    }
    
    @objc private func doneButtonDidTap() {
        delegate?.setBitrhYear(year: selectedYear)
        dismiss(animated: false)
    }
}

private extension SelectBirthYearViewController {
    var pickerView: UIPickerView {
        bottomSheetView.pickerView
    }
    
    var doneButton: UIButton {
        bottomSheetView.doneButton
    }
}

extension SelectBirthYearViewController: UIPickerViewDelegate {
    public func pickerView(
        _ pickerView: UIPickerView,
        titleForRow row: Int,
        forComponent component: Int
    ) -> String? {
        let year = minYear + row
        return "\(year)"
    }
    
    public func pickerView(
        _ pickerView: UIPickerView,
        didSelectRow row: Int,
        inComponent component: Int
    ) {
        let year = minYear + row
        selectedYear = year
    }
}

extension SelectBirthYearViewController: UIPickerViewDataSource {
    public func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    public func pickerView(
        _ pickerView: UIPickerView,
        numberOfRowsInComponent component: Int
    ) -> Int {
        return maxYear - minYear + 1 // 14세부터 100세까지
    }
}
