//
//  ResolveError.swift
//  CoreDependencyInjectionInterface
//
//  Created by Derrick kim on 4/18/24.
//

import Foundation

public enum ResolveError<T>: Error {
    case dependencyNotFound(_ type: T.Type?, _ key: String?)
}
