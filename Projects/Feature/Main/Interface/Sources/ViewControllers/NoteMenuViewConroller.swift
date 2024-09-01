//
//  NoteMenuViewConroller.swift
//  FeatureMainInterface
//
//  Created by 황인우 on 9/1/24.
//

import Shared

import Combine
import UIKit

class NoteMenuViewConroller: BottomSheetViewController<NoteMenuView> {
    private var cancellables: Set<AnyCancellable> = .init()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}

#if canImport(SwiftUI)
import SwiftUI

struct NoteMenuViewConroller_Preview: PreviewProvider {
    static var previews: some View {
        return NoteMenuViewConroller(
            bottomSheetHeight: 180,
            bottomSheetView: NoteMenuView(menuType: .me,
            frame: .zero)
        )
            .asPreview()
    }
}

#endif
