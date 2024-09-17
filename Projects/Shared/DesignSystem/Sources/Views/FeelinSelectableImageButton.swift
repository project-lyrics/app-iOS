//
//  FeelinSelectableImageButton.swift
//  SharedDesignSystem
//
//  Created by 황인우 on 8/4/24.
//

import UIKit

public class FeelinSelectableImageButton: UIButton {
    private var selectedImage: UIImage
    private var unSelectedImage: UIImage
    
    public init(
        selectedImage: UIImage,
        unSelectedImage: UIImage,
        frame: CGRect = .zero
    ) {
        self.selectedImage = selectedImage
        self.unSelectedImage = unSelectedImage
        super.init(frame: frame)
        self.setUpButton()
    }

    @available(*, unavailable)
    public required init?(coder: NSCoder) {
        fatalError()
    }

    public override var isSelected: Bool {
        didSet {
            updateButtonImage()
        }
    }

    private func setUpButton() {
        updateButtonImage()
        addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
    }
    
    @objc private func buttonTapped() {
        isSelected.toggle()
        updateButtonImage()
    }
    
    private func updateButtonImage() {
        let image = isSelected ? selectedImage : unSelectedImage
        setImage(image, for: .normal)
    }
    
    private func replaceSelectedImage(with image: UIImage) {
        self.selectedImage = image
    }
    
    private func replaceUnSelectedImage(with image: UIImage) {
        self.unSelectedImage = image
    }
}
