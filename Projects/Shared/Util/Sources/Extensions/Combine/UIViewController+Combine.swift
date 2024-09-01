//
//  UIViewController+Combine.swift
//  SharedUtil
//
//  Created by 황인우 on 9/2/24.
//

import Combine
import UIKit

public extension UIViewController {
    func dismissPublisher(animated: Bool) -> AnyPublisher<Void, Never> {
        return Future { [weak self] promise in
            self?.dismiss(animated: animated, completion: {
                promise(.success(()))
            })
        }
        .eraseToAnyPublisher()
    }
}
