//
//  TodayError.swift
//  Today
//
//  Created by Tom Choi on 2/20/26.
//

import Foundation

enum TodayError: LocalizedError {
    case failedReadingReminders
    case reminderHasNoDueDate
    case accessDenied

    var errorDescription: String? {
        switch self {
        case .failedReadingReminders:
            return NSLocalizedString(
                "Failed to read reminders.",
                comment: "failed reading reminders error description"
            )
        case .reminderHasNoDueDate:
            return NSLocalizedString(
                "A reminder has no due date.",
                comment: "reminder has no due date error description"
            )
        case .accessDenied:
            return NSLocalizedString(
                "The app doesn't have permission to read reminders.",
                comment: "access denied error description"
            )
        }
    }
}

/// 언제 그냥 에러를 쓰는거고
/// 언제 LocalizedError를 쓰는거지?
