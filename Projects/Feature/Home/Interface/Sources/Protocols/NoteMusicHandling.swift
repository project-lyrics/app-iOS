//
//  NoteMusicHandling.swift
//  FeatureHomeInterface
//
//  Created by 황인우 on 9/7/24.
//

import UIKit

public protocol NoteMusicHandling where Self: UIViewController {
    var youTubeMusicURLScheme: String { get }
    
    func isYouTubeMusicInstalled() -> Bool
    func openYouTube(query: String)
}

public extension NoteMusicHandling {
    var youTubeMusicURLScheme: String {
        return "youtubemusic://"
    }
    
    func isYouTubeMusicInstalled() -> Bool {
        if let url = URL(string: youTubeMusicURLScheme) {
            return UIApplication.shared.canOpenURL(url)
        }
        return false
    }
    
    func openYouTube(query: String) {
        let encodedQuery = query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
        
        if isYouTubeMusicInstalled() {
            let youtubeMusicPath = "\(youTubeMusicURLScheme)search/\(encodedQuery ?? query)"
            
            if let url = URL(string: youtubeMusicPath) {
                UIApplication.shared.open(url)
            }
        } else {
            let youtubeMusicWebPath = "https://music.youtube.com/search?q=\(encodedQuery ?? query)"
            
            if let url = URL(string: youtubeMusicWebPath) {
                UIApplication.shared.open(url)
            }
        }
    }
}
