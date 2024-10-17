//
//  NoteMusicHandling.swift
//  FeatureHomeInterface
//
//  Created by 황인우 on 9/7/24.
//

import UIKit

public protocol NoteMusicHandling where Self: UIViewController {
    func openYouTube(query: String)
}

public extension NoteMusicHandling {
    
    func openYouTube(query: String) {
        let encodedQuery = query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
        let youtubeMusicPath = "https://music.youtube.com/search?q=\(encodedQuery ?? query)"
        
        if let url = URL(string: youtubeMusicPath) {
            UIApplication.shared.open(url)
        }
    }
}
