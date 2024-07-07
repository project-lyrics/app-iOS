//
//  SelectBirthYearViewController.swift
//  FeatureOnboardingInterface
//
//  Created by jiyeon on 6/19/24.
//

import UIKit
import Combine
import Shared

public final class SelectBirthYearViewController: BottomSheetViewController<SelectBirthYearView> {
    private let currentYear = Calendar.current.component(.year, from: Date())
    private let minYear = Calendar.current.component(.year, from: Date()) - 100
    private let maxYear = Calendar.current.component(.year, from: Date()) - 14
    private var selectedYear: Int
    private var cancellables = Set<AnyCancellable>()

    public let selectedYearSubject = PassthroughSubject<String, Never>()

    // MARK: - init

    public init(bottomSheetHeight: CGFloat, baseYear: Int) {
        self.selectedYear = baseYear

        super.init(bottomSheetHeight: bottomSheetHeight)

        setUpPickerView(baseYear: baseYear)
        bind()
    }

    private func setUpPickerView(baseYear: Int) {
        pickerView.delegate = self
        pickerView.dataSource = self

        let baseYearIndex = baseYear - minYear
        pickerView.selectRow(baseYearIndex, inComponent: 0, animated: false)
    }

    private func bind() {
        doneButton.publisher(for: .touchUpInside)
            .sink { [weak self] _ in
                guard let self = self else { return }

                selectedYearSubject.send("\(selectedYear)년")
                dismiss(animated: false)
            }
            .store(in: &cancellables)
    }
}

private extension SelectBirthYearViewController {
    private var pickerView: UIPickerView {
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
