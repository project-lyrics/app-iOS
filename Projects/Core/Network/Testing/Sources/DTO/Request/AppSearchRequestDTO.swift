//
//  AppSearchRequestDTO.swift
//  CoreNetwork
//
//  Created by Derrick kim on 4/3/24.
//

import Foundation

public struct AppSearchRequestDTO: Encodable {
    let keyword: String
    let media: String
    let country: String
    let page: Int
    let size: Int

    public enum CodingKeys: String, CodingKey {
        case keyword = "term"
        case media
        case country
        case page = "offset"
        case size = "limit"
    }
}
