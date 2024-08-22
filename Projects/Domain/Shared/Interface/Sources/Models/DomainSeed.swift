//
//  DomainSeed.swift
//  DomainSharedInterface
//
//  Created by 황인우 on 8/19/24.
//

import Foundation

public struct DomainSeed {
    
    public static let getNoteResponseJsonData =
"""
{
  "nextCursor": 273,
  "hasNext": true,
  "data": [
    {
      "id": 246,
      "content": "노트 내용1",
      "status": "PUBLISHED",
      "createdAt": "2024-08-13 09:52:51",
      "publisher": {
        "id": 243,
        "nickname": "nickname",
        "profileCharacterType": "poopHair"
      },
      "song": {
        "id": 245,
        "name": "name",
        "imageUrl": "imageUrl",
        "artist": {
          "id": 244,
          "name": "아티스트 이름1",
          "imageUrl": "https://asdf.com"
        }
      },
      "commentsCount": 0,
      "likesCount": 0,
      "isLiked": false,
      "isBookmarked": false
    },
    {
      "id": 249,
      "content": "노트 내용2",
      "status": "PUBLISHED",
      "createdAt": "2024-08-13 09:52:51",
      "lyrics": {
        "lyrics": "가사",
        "background": "DEFAULT"
      },
      "publisher": {
        "id": 243,
        "nickname": "nickname",
        "profileCharacterType": "poopHair"
      },
      "song": {
        "id": 248,
        "name": "name",
        "imageUrl": "imageUrl",
        "artist": {
          "id": 247,
          "name": "아티스트 이름2",
          "imageUrl": "https://asdf.com"
        }
      },
      "commentsCount": 0,
      "likesCount": 0,
      "isLiked": false,
      "isBookmarked": false
    },
    {
      "id": 252,
      "content": "노트 내용3",
      "status": "PUBLISHED",
      "createdAt": "2024-08-13 09:52:51",
      "lyrics": {
        "lyrics": "가사",
        "background": "DEFAULT"
      },
      "publisher": {
        "id": 243,
        "nickname": "nickname",
        "profileCharacterType": "poopHair"
      },
      "song": {
        "id": 251,
        "name": "name",
        "imageUrl": "imageUrl",
        "artist": {
          "id": 250,
          "name": "아티스트 이름3",
          "imageUrl": "https://asdf.com"
        }
      },
      "commentsCount": 0,
      "likesCount": 0,
      "isLiked": false,
      "isBookmarked": false
    },
    {
      "id": 255,
      "content": "노트 내용4",
      "status": "PUBLISHED",
      "createdAt": "2024-08-13 09:52:51",
      "lyrics": {
        "lyrics": "가사",
        "background": "DEFAULT"
      },
      "publisher": {
        "id": 243,
        "nickname": "nickname",
        "profileCharacterType": "poopHair"
      },
      "song": {
        "id": 254,
        "name": "name",
        "imageUrl": "imageUrl",
        "artist": {
          "id": 253,
          "name": "아티스트 이름",
          "imageUrl": "https://asdf.com"
        }
      },
      "commentsCount": 0,
      "likesCount": 0,
      "isLiked": false,
      "isBookmarked": false
    },
    {
      "id": 258,
      "content": "노트 내용",
      "status": "PUBLISHED",
      "createdAt": "2024-08-13 09:52:51",
      "lyrics": {
        "lyrics": "가사",
        "background": "DEFAULT"
      },
      "publisher": {
        "id": 243,
        "nickname": "nickname",
        "profileCharacterType": "poopHair"
      },
      "song": {
        "id": 257,
        "name": "name",
        "imageUrl": "imageUrl",
        "artist": {
          "id": 256,
          "name": "아티스트 이름",
          "imageUrl": "https://asdf.com"
        }
      },
      "commentsCount": 0,
      "likesCount": 0,
      "isLiked": false,
      "isBookmarked": false
    },
    {
      "id": 261,
      "content": "노트 내용",
      "status": "PUBLISHED",
      "createdAt": "2024-08-13 09:52:51",
      "lyrics": {
        "lyrics": "가사",
        "background": "DEFAULT"
      },
      "publisher": {
        "id": 243,
        "nickname": "nickname",
        "profileCharacterType": "poopHair"
      },
      "song": {
        "id": 260,
        "name": "name",
        "imageUrl": "imageUrl",
        "artist": {
          "id": 259,
          "name": "아티스트 이름",
          "imageUrl": "https://asdf.com"
        }
      },
      "commentsCount": 0,
      "likesCount": 0,
      "isLiked": false,
      "isBookmarked": false
    },
    {
      "id": 264,
      "content": "노트 내용",
      "status": "PUBLISHED",
      "createdAt": "2024-08-13 09:52:51",
      "lyrics": {
        "lyrics": "가사",
        "background": "DEFAULT"
      },
      "publisher": {
        "id": 243,
        "nickname": "nickname",
        "profileCharacterType": "poopHair"
      },
      "song": {
        "id": 263,
        "name": "name",
        "imageUrl": "imageUrl",
        "artist": {
          "id": 262,
          "name": "아티스트 이름",
          "imageUrl": "https://asdf.com"
        }
      },
      "commentsCount": 0,
      "likesCount": 0,
      "isLiked": false,
      "isBookmarked": false
    },
    {
      "id": 267,
      "content": "노트 내용",
      "status": "PUBLISHED",
      "createdAt": "2024-08-13 09:52:51",
      "lyrics": {
        "lyrics": "가사",
        "background": "DEFAULT"
      },
      "publisher": {
        "id": 243,
        "nickname": "nickname",
        "profileCharacterType": "poopHair"
      },
      "song": {
        "id": 266,
        "name": "name",
        "imageUrl": "imageUrl",
        "artist": {
          "id": 265,
          "name": "아티스트 이름",
          "imageUrl": "https://asdf.com"
        }
      },
      "commentsCount": 0,
      "likesCount": 0,
      "isLiked": false,
      "isBookmarked": false
    },
    {
      "id": 270,
      "content": "노트 내용",
      "status": "PUBLISHED",
      "createdAt": "2024-08-13 09:52:51",
      "lyrics": {
        "lyrics": "가사",
        "background": "DEFAULT"
      },
      "publisher": {
        "id": 243,
        "nickname": "nickname",
        "profileCharacterType": "poopHair"
      },
      "song": {
        "id": 269,
        "name": "name",
        "imageUrl": "imageUrl",
        "artist": {
          "id": 268,
          "name": "아티스트 이름",
          "imageUrl": "https://asdf.com"
        }
      },
      "commentsCount": 0,
      "likesCount": 0,
      "isLiked": false,
      "isBookmarked": false
    },
    {
      "id": 273,
      "content": "노트 내용",
      "status": "PUBLISHED",
      "createdAt": "2024-08-13 09:52:51",
      "lyrics": {
        "lyrics": "가사",
        "background": "DEFAULT"
      },
      "publisher": {
        "id": 243,
        "nickname": "nickname",
        "profileCharacterType": "poopHair"
      },
      "song": {
        "id": 272,
        "name": "name",
        "imageUrl": "imageUrl",
        "artist": {
          "id": 271,
          "name": "아티스트 이름",
          "imageUrl": "https://asdf.com"
        }
      },
      "commentsCount": 0,
      "likesCount": 0,
      "isLiked": false,
      "isBookmarked": false
    }
  ]
}
""".data(using: .utf8)!
    
    
    public static let getArtistsResponseJsonData =
"""
{
  "nextCursor": 273,
  "hasNext": false,
  "data": [
        {
          "id": 1,
          "artist": {
            "id": 1,
            "name": "검정치마",
            "imageUrl": "https://i.scdn.co/image/ab6761610000e5eb8609536d21beed6769d09d7f"
          }
        }
    ]
}
""".data(using: .utf8)!
    
}
