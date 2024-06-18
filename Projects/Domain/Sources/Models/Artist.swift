//
//  Artist.swift
//  Domain
//
//  Created by 황인우 on 6/16/24.
//

import UIKit

public struct Artist: Hashable {
    public var id: UUID = .init()
    public var name: String
    public var image: UIImage
    public var isFavorite: Bool
    
    public init(
        name: String,
        image: UIImage,
        isFavorite: Bool = false
    ) {
        self.name = name
        self.image = image
        self.isFavorite = false
    }
}
