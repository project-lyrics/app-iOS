//
//  Reusable.swift
//  SharedUtil
//
//  Created by jiyeon on 6/14/24.
//

import Foundation

public protocol Reusable: AnyObject {
  static var reuseIdentifier: String { get }
}

public extension Reusable {
  static var reuseIdentifier: String {
    return String(describing: self)
  }
}
