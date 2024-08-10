//
//  UIViewPreview.swift
//  SharedUtil
//
//  Created by 황인우 on 8/4/24.
//

#if canImport(SwiftUI)
import SwiftUI

struct UIViewPreview<View: UIView>: UIViewRepresentable {
    let view: View
    
    init(_ builder: @escaping () -> View) {
        view = builder()
    }
    
    // MARK: - UIViewRepresentable
    
    func makeUIView(context: Context) -> UIView {
        return view
    }
    
    func updateUIView(_ view: UIView, context: Context) {
        view.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        view.setContentHuggingPriority(.defaultHigh, for: .vertical)
    }
}
#endif

#if canImport(SwiftUI)
import SwiftUI
extension UIView {
    private struct Preview: UIViewRepresentable {
        typealias UIViewType = UIView
        
        let view: UIView
        
        func makeUIView(context: Context) -> UIView {
            return view
        }
        
        func updateUIView(_ uiView: UIView, context: Context) {
            view.setContentHuggingPriority(.defaultHigh, for: .horizontal)
            view.setContentHuggingPriority(.defaultHigh, for: .vertical)
        }
    }
    
    public func showPreview() -> some View {
        Preview(view: self)
    }
}

extension UIViewController {
    private struct Preview: UIViewControllerRepresentable {
        var viewController: UIViewController
        
        func makeUIViewController(context: Context) -> some UIViewController {
            viewController
        }
        
        func updateUIViewController(
            _ uiViewController: UIViewControllerType,
            context: Context
        ) {
        }
    }
    
    public func asPreview() -> some View {
        Preview(viewController: self)
    }
}

#endif
