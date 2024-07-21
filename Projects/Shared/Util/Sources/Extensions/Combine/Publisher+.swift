//
//  Publisher+.swift
//  SharedUtil
//
//  Created by 황인우 on 7/14/24.
//

import Combine

public extension Publisher {
    func mapToResult() -> AnyPublisher<Result<Output, Failure>, Never> {
        return map(Result.success)
            .catch { Just(.failure($0)) }
            .eraseToAnyPublisher()
    }
}
