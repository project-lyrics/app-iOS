//
//  String+.swift
//  SharedUtil
//
//  Created by Derrick kim on 10/9/24.
//

import Foundation

public extension String {
    var containsOnlyAllowedCharacters: Bool {
        let regex = "^[ㄱ-ㅎ가-힣ㅏ-ㅣa-zA-Z0-9]*$"
        return NSPredicate(format: "SELF MATCHES %@", regex).evaluate(with: self)
    }
}
