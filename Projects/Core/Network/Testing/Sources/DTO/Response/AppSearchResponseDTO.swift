//
//  AppSearchResponseDTO.swift
//  CoreNetwork
//
//  Created by Derrick kim on 4/3/24.
//

import Foundation

public struct AppSearchResponseDTO: Decodable {
    let resultCount: Int
    let results: [AppSearchItemResponseDTO]
}
