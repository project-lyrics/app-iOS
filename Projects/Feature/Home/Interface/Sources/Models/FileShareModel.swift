//
//  FileShareModel.swift
//  FeatureHomeInterface
//
//  Created by 황인우 on 10/13/24.
//

import UIKit
import LinkPresentation

public final class FileShareModel: NSObject, UIActivityItemSource {
    let url: URL
    var data: Data?
    let title: String
    
    init(
        url: URL,
        title: String
    ) {
        self.url = url
        self.title = title
        super.init()
    }
    
    func fetchData(_ completionHandler: @escaping (Result<FileShareModel, Error>) -> Void) {
        URLSession.shared.dataTask(with: url) { [weak self] (data, response, error) in
            guard let self = self else {
                return
            }
            
            if let error = error {
                completionHandler(.failure(error))
                return
            }
            
            if let data = data {
                self.data = data
                completionHandler(.success((self)))
            }
        }
        .resume()
    }
    
    public func activityViewControllerPlaceholderItem(_ activityViewController: UIActivityViewController) -> Any {
        data ?? Data()
    }
    
    public func activityViewController(
        _ activityViewController: UIActivityViewController,
        itemForActivityType activityType: UIActivity.ActivityType?
    ) -> Any? {
        data
    }
    
    public func activityViewControllerLinkMetadata(_ activityViewController: UIActivityViewController) -> LPLinkMetadata? {
        let metadata = LPLinkMetadata()
        metadata.title = title
        metadata.url = url
        metadata.originalURL = url
        metadata.iconProvider = NSItemProvider(contentsOf: url)
        return metadata
    }
}
