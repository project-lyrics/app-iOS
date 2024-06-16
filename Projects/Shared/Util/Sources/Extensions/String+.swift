//
//  String+.swift
//  SharedUtil
//
//  Created by jiyeon on 6/14/24.
//

import Foundation

extension String {
    public var containsOnlyAllowedCharacters: Bool {
        // 한글, 영문, 숫자만 포함되는 정규식
        let regex = "^[ㄱ-ㅎ가-힣a-zA-Z0-9]*$"
        return NSPredicate(format: "SELF MATCHES %@", regex).evaluate(with: self)
    }
}
