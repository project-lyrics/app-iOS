//
//  AppSearchItemResponseDTO.swift
//  CoreNetwork
//
//  Created by Derrick kim on 4/3/24.
//

import Foundation

public struct AppSearchItemResponseDTO: Decodable {
    let screenshotUrls: [String]?
    let ipadScreenshotUrls: [String]?
    let artworkUrl60: String?
    let artworkUrl512: String?
    let artworkUrl100: String?
    let artistViewUrl: String?
    let minimumOsVersion: String?
    let languageCodesISO2A: [String]?
    let fileSizeBytes: String?
    let sellerUrl: String?
    let formattedPrice: String?
    let contentAdvisoryRating: String?
    let averageUserRating: Double?
    let trackViewUrl: String?
    let description, bundleId: String?
    let supportedDevices: [String]?
    let releaseDate: String?
    let sellerName: String?
    let trackId: Int?
    let trackName: String?
    let currentVersionReleaseDate: String?
    let releaseNotes: String?
    let artistId: Int?
    let artistName: String?
    let genres: [String]?
    let price: Int?
    let version: String?
    let userRatingCount: Int?
}

public extension AppSearchItemResponseDTO {
    static let completeDataMock = AppSearchItemResponseDTO(
        screenshotUrls: [],
        ipadScreenshotUrls: [],
        artworkUrl60: "",
        artworkUrl512: "",
        artworkUrl100: "",
        artistViewUrl: "https://apps.apple.com/kr/developer/kakaobank-corp/id1258016943?uo=4",
        minimumOsVersion: "13.0",
        languageCodesISO2A: [ "NL", "PT", "DA", "KO", "FI", "NO", "JA", "EN", "ZH"],
        fileSizeBytes: "326386688",
        sellerUrl: "https://www.kakaobank.com/",
        formattedPrice: "무료",
        contentAdvisoryRating: "4+",
        averageUserRating: 3.354729999999999989768184605054557323455810546875,
        trackViewUrl: "https://apps.apple.com/kr/app/%EC%B9%B4%EC%B9%B4%EC%98%A4%EB%B1%85%ED%81%AC/id1258016944?uo=4",
        description: "",
        bundleId: "com.kakaobank.channel",
        supportedDevices: [],
        releaseDate: "2023-06-12T02:01:11Z",
        sellerName: "KakaoBank Corp.",
        trackId: 1258016944,
        trackName: "카카오 뱅크",
        currentVersionReleaseDate: nil,
        releaseNotes: "",
        artistId: 1258016943,
        artistName: "카카오 뱅크",
        genres: ["금융"],
        price: 0,
        version: "2.26.0",
        userRatingCount: 11468
    )
}
