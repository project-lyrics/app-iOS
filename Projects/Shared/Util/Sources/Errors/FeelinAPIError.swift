//
//  FeelinAPIError.swift
//  SharedUtil
//
//  Created by 황인우 on 10/19/24.
//

import Foundation

public struct FeelinAPIError: LocalizedError, Equatable {
    public enum ErrorType: Equatable {
        case invalidRequest             // 00000
        case invalidRequestInput        // 00001
        case unexpectedServerError      // 00002
        case notFound                   // 00003
        case someFieldMissing           // 00004
        case someFieldEmpty             // 00005
        case invalidURLFormat           // 00006
        case resourceNotFound           // 00007
        case invalidEmail               // 00008
        case updateRequired             // 00009
        case appVersionMissing          // 00010
        case restrictedUser             // 01000
        case tokenIsExpired             // 01001
        case wrongTokenTypePassed       // 01002
        case unsupportedAuthProvider    // 01003
        case invalidToken               // 01004
        case invalidPublicKey           // 01005
        case invalidSecretKey           // 01006
        case notAgreedToTerms           // 01007
        case tokenNotFound              // 01008
        case notBearerFormat            // 01009
        case invalidOAuthToken          // 01010
        case authInfoNotFound           // 01011
        case duplicatedLogin            // 01012
        case userDataNotFound           // 02000
        case invalidNickName            // 02001
        case ageNotAccepted             // 02002
        case invalidUserCharacter       // 02003
        case failedEditingUserProfile   // 02004
        case sameNickName               // 02005
        case artistDataNotFound         // 03000
        case dataFailedValidation       // 03001
        case recordDataNotFound         // 04000
        case failedGetNote              // 05000
        case invalidNoteBackground      // 05001
        case invalidNoteState           // 05002
        case failedDeleteNote           // 05003
        case failedEditNote             // 05004
        case exceededTempNotes          // 05005
        case failedGetSong              // 06000
        case failedGetChat              // 07000
        case failedEditChat             // 07001
        case failedDeleteChat           // 07002
        case failedGetLike              // 08000
        case duplicatedLike             // 08001
        case failedGetArtist            // 09000
        case duplicatedLikeArtist       // 09001
        case failedGetBookmark          // 10000
        case duplicatedBookmark         // 10001
        case invalidNoti                // 11000
        case failedSendingNoti          // 11001
        case invalidNotiReceiver        // 11002
        case failedGetNoti              // 11003
        case failedGetReport            // 12000
        case invalidReport              // 12001
        case missingReportData          // 12002
        case alreadyReported            // 12003
        case failedDiscipline           // 13000
        case failedCreateDiscipline     // 13001
        case restrictedAccess           // 13002
        case unknown(errorCode: String)
        
        public var errorCode: String {
            switch self {
            case .invalidRequest:           return "00000"
            case .invalidRequestInput:      return "00001"
            case .unexpectedServerError:    return "00002"
            case .notFound:                 return "00003"
            case .someFieldMissing:         return "00004"
            case .someFieldEmpty:           return "00005"
            case .invalidURLFormat:         return "00006"
            case .resourceNotFound:         return "00007"
            case .invalidEmail:             return "00008"
            case .updateRequired:           return "00009"
            case .appVersionMissing:        return "00010"
            case .restrictedUser:           return "01000"
            case .tokenIsExpired:           return "01001"
            case .wrongTokenTypePassed:     return "01002"
            case .unsupportedAuthProvider:  return "01003"
            case .invalidToken:             return "01004"
            case .invalidPublicKey:         return "01005"
            case .invalidSecretKey:         return "01006"
            case .notAgreedToTerms:         return "01007"
            case .tokenNotFound:            return "01008"
            case .notBearerFormat:          return "01009"
            case .invalidOAuthToken:        return "01010"
            case .authInfoNotFound:         return "01011"
            case .duplicatedLogin:          return "01012"
            case .userDataNotFound:         return "02000"
            case .invalidNickName:          return "02001"
            case .ageNotAccepted:           return "02002"
            case .invalidUserCharacter:     return "02003"
            case .failedEditingUserProfile: return "02004"
            case .sameNickName:             return "02005"
            case .artistDataNotFound:       return "03000"
            case .dataFailedValidation:     return "03001"
            case .recordDataNotFound:       return "04000"
            case .failedGetNote:            return "05000"
            case .invalidNoteBackground:    return "05001"
            case .invalidNoteState:         return "05002"
            case .failedDeleteNote:         return "05003"
            case .failedEditNote:           return "05004"
            case .exceededTempNotes:        return "05005"
            case .failedGetSong:            return "06000"
            case .failedGetChat:            return "07000"
            case .failedEditChat:           return "07001"
            case .failedDeleteChat:         return "07002"
            case .failedGetLike:            return "08000"
            case .duplicatedLike:           return "08001"
            case .failedGetArtist:          return "09000"
            case .duplicatedLikeArtist:     return "09001"
            case .failedGetBookmark:        return "10000"
            case .duplicatedBookmark:       return "10001"
            case .invalidNoti:              return "11000"
            case .failedSendingNoti:        return "11001"
            case .invalidNotiReceiver:      return "11002"
            case .failedGetNoti:            return "11003"
            case .failedGetReport:          return "12000"
            case .invalidReport:            return "12001"
            case .missingReportData:        return "12002"
            case .alreadyReported:          return "12003"
            case .failedDiscipline:         return "13000"
            case .failedCreateDiscipline:   return "13001"
            case .restrictedAccess:         return "13002"
            case .unknown(let errorCode):   return errorCode
            }
        }
        
        public var userMessage: String {
            switch self {
            case .invalidRequest,
                 .invalidRequestInput,
                 .someFieldMissing,
                 .someFieldEmpty:
                return "잘못된 요청입니다. 다시 시도해 주세요."
                
            case .invalidURLFormat,
                 .invalidEmail:
                return "유효한 형식이 아닙니다. 다시 시도해 주세요."
                
            case .wrongTokenTypePassed,
                 .invalidToken,
                 .tokenNotFound,
                 .notBearerFormat:
                return "인증 정보를 찾을 수 없어요. 다시 시도해 주세요."
                
            case .updateRequired:
                return "새로운 앱 버전이 나왔습니다.\n앱스토어에서 업데이트를 진행해 주세요."
                
            case .duplicatedLogin:
                return "타 기기에서 로그인했거나\n 등록되지 않은 기기입니다."
                
            case .authInfoNotFound:
                return "장기간 서비스를 이용하지 않아\n로그인 정보가 만료되었어요."
                
            case .restrictedUser:
                return "로그인이 제한된 계정입니다."
                
            case .invalidPublicKey:
                return "로그인에 실패했습니다. 다시 시도해 주세요."
                
            case .notAgreedToTerms:
                return "약관 동의 후 다시 가입을 진행해 주세요."
                
            case .ageNotAccepted:
                return "만 14세 이상부터 서비스를 이용할 수 있어요."
                
            case .invalidUserCharacter:
                return "프로필이 올바르지 않습니다."
                
            case .userDataNotFound:
                return "존재하지 않는 유저입니다."
                
            case .failedGetNote:
                return "해당 노트를 찾을 수 없어요."
                
            case .duplicatedBookmark:
                return "이미 추가된 노트에요."
                
            case .failedGetBookmark:
                return "해당 북마크를 찾을 수 없어요."
                
            case .failedDeleteNote:
                return "노트를 삭제할 수 없어요. 다시 시도해 주세요."
                
            case .restrictedAccess:
                return "서비스 이용이 일시적으로 제한되었어요.\n 알림을 확인해 주세요."
                
            case .failedGetSong:
                return "해당 곡을 찾을 수 없습니다. 다시 시도해 주세요."
                
            case .invalidNoteBackground:
                return "노트 배경이 올바르지 않습니다. 다시 시도해 주세요."
                
            case .invalidNoteState:
                return "노트가 올바르지 않습니다. 다시 시도해 주세요."
                
            case .failedEditNote:
                return "노트를 수정할 수 없습니다. 다시 시도해 주세요."
                
            case .failedGetChat:
                return "해당 댓글을 찾을 수 없어요."
            
            case .missingReportData:
                return "신고 대상을 찾을 수 없어요. 다시 시도해 주세요."
                
            case .alreadyReported:
                return "이미 신고가 완료 되었어요."
                
            default:
                return "서비스 오류입니다. 다시 시도해 주세요."
                
            }
        }
    }
    
    public let type: ErrorType
    public let errorMessage: String
    public var errorCode: String { type.errorCode }
    public var userMessage: String { type.userMessage }

    public init(
        type: ErrorType,
        errorMessage: String
    ) {
        self.type = type
        self.errorMessage = errorMessage
    }
    
    public init(apiFailResponse: APIFailResponse) {
        let errorCode = apiFailResponse.errorCode
        let errorMessage = apiFailResponse.errorMessage
        self.type = ErrorType(errorCode: errorCode)
        self.errorMessage = errorMessage
    }
}

public extension FeelinAPIError.ErrorType {
    init(errorCode: String) {
        switch errorCode {
        case "00000":       self = .invalidRequest
        case "00001":       self = .invalidRequestInput
        case "00002":       self = .unexpectedServerError
        case "00003":       self = .notFound
        case "00004":       self = .someFieldMissing
        case "00005":       self = .someFieldEmpty
        case "00006":       self = .invalidURLFormat
        case "00007":       self = .resourceNotFound
        case "00008":       self = .invalidEmail
        case "01000":       self = .restrictedUser
        case "01001":       self = .tokenIsExpired
        case "01002":       self = .wrongTokenTypePassed
        case "01003":       self = .unsupportedAuthProvider
        case "01004":       self = .invalidToken
        case "01005":       self = .invalidPublicKey
        case "01006":       self = .invalidSecretKey
        case "01007":       self = .notAgreedToTerms
        case "01008":       self = .tokenNotFound
        case "01009":       self = .notBearerFormat
        case "01010":       self = .invalidOAuthToken
        case "01011":       self = .authInfoNotFound
        case "01012":       self = .duplicatedLogin
        case "02000":       self = .userDataNotFound
        case "02001":       self = .invalidNickName
        case "02002":       self = .ageNotAccepted
        case "02003":       self = .invalidUserCharacter
        case "02004":       self = .failedEditingUserProfile
        case "02005":       self = .sameNickName
        case "03000":       self = .artistDataNotFound
        case "03001":       self = .dataFailedValidation
        case "04000":       self = .recordDataNotFound
        case "05000":       self = .failedGetNote
        case "05001":       self = .invalidNoteBackground
        case "05002":       self = .invalidNoteState
        case "05003":       self = .failedDeleteNote
        case "05004":       self = .failedEditNote
        case "05005":       self = .exceededTempNotes
        case "06000":       self = .failedGetSong
        case "07000":       self = .failedGetChat
        case "07001":       self = .failedEditChat
        case "07002":       self = .failedDeleteChat
        case "08000":       self = .failedGetLike
        case "08001":       self = .duplicatedLike
        case "09000":       self = .failedGetArtist
        case "09001":       self = .duplicatedLikeArtist
        case "10000":       self = .failedGetBookmark
        case "10001":       self = .duplicatedBookmark
        case "11000":       self = .invalidNoti
        case "11001":       self = .failedSendingNoti
        case "11002":       self = .invalidNotiReceiver
        case "11003":       self = .failedGetNoti
        case "12000":       self = .failedGetReport
        case "12001":       self = .invalidReport
        case "12002":       self = .missingReportData
        case "12003":       self = .alreadyReported
        case "13000":       self = .failedDiscipline
        case "13001":       self = .failedCreateDiscipline
        case "13002":       self = .restrictedAccess
        default:            self = .unknown(errorCode: errorCode)
        }
    }
}
