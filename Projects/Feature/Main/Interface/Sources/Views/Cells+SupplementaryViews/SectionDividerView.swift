//
//  SectionDividerView.swift
//  FeatureMainInterface
//
//  Created by 황인우 on 8/20/24.
//

import Shared

import UIKit

class SectionDividerView: UICollectionReusableView, Reusable {
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = Colors.backgroundTertiary
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
