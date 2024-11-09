//
//  GetArtistUseCase.swift
//  DomainArtistInterface
//
//  Created by 황인우 on 10/26/24.
//

import Core
import DomainSharedInterface

import Combine
import Foundation

public protocol GetArtistUseCaseInterface {
    func execute(artistID: Int) -> AnyPublisher<Artist, ArtistError>
}

public struct GetArtistUseCase: GetArtistUseCaseInterface {
    private let artistAPIService: ArtistAPIServiceInterface
    
    public init(artistAPIService: ArtistAPIServiceInterface) {
        self.artistAPIService = artistAPIService
    }
    
    public func execute(artistID: Int) -> AnyPublisher<Artist, ArtistError> {
            let artistPublisher = artistAPIService.getArtist(artistID: artistID)
        
            let isFavoritePublisher = artistAPIService.getIsFavoriteArtist(artistID: artistID)
            .tryCatch({ artistError in
                if case .feelinAPIError(let feelinAPIError) = artistError,
                   feelinAPIError.type == .tokenIsExpired {
                    // 비회원인 경우 즐겨찾기 정보를 가져올 수 없다. 하지만 이 부분은 에러를 발생시키기 보다는
                    // false값을 리턴하여야 한다. 유저가 커뮤니티 메인 화면을 확인은 할 수 있어야 하니
                    return Just(IsFavoriteArtistResponse(exists: false))
                        .setFailureType(to: ArtistError.self)
                        .eraseToAnyPublisher()
                } else {
                    throw artistError
                }
            })
            .mapError(ArtistError.init)
            .eraseToAnyPublisher()
            
            return artistPublisher
                .zip(isFavoritePublisher)
                .map { artistResponse, isFavoriteResponse in
                    Artist(
                        dto: artistResponse,
                        isFavorite: isFavoriteResponse.exists
                    )
                }
                .eraseToAnyPublisher()
        }
}
