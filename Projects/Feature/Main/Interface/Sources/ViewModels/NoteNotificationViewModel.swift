//
//  NoteNotificationViewModel.swift
//  FeatureMainInterface
//
//  Created by 황인우 on 9/29/24.
//

import Combine
import Foundation

import Domain

public final class NoteNotificationViewModel {
    @Published private (set) var fetchedNotifications: [NoteNotification] = [
        .init(
            id: 1,
            type: .report,
            image: nil,
            hasRead: true,
            content: "이 내용은 모두가 공감했으면 좋겠어요/n 정말로 그랬으면 좋겠어",
            time: .distantPast
        ),
        .init(
            id: 2,
            type: .report,
            image: nil,
            hasRead: false,
            content: "이 내용은 모두가 공감했으면 좋겠어요/n 정말로 그랬으면 좋겠어. 혼나요 진짜로. 그렇게 살면 안됩니다. 경고했습니다. 제발 말씀. 어 왜 그랬어. 잘 못했지",
            time: .distantPast
        )
    ]
    
    public init() {
        
    }
}
