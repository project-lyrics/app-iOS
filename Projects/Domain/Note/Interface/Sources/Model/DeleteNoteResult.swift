//
//  DeleteNoteResult.swift
//  DomainNoteInterface
//
//  Created by Derrick kim on 11/8/24.
//

import Foundation

public enum DeleteNoteResult: Equatable {
    case none
    case success
    case failure(NoteError)
}
