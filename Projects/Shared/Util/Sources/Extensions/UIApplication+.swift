//
//  UIApplication+.swift
//  SharedUtil
//
//  Created by 황인우 on 10/3/24.
//

import UIKit

public extension UIApplication {
    var safeAreaInsets: UIEdgeInsets {
        let windowScene = self.connectedScenes.first as? UIWindowScene
        let window = windowScene?.windows.first
        return window?.safeAreaInsets ?? .zero
    }
}
