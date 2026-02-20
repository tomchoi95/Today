//
//  ReminderStore.swift
//  Today
//
//  Created by Tom Choi on 2/20/26.
//

import EventKit
import Foundation

final class ReminderStore {
    static let shared = ReminderStore()

    private var ekStore = EKEventStore()

    var isAvailable: Bool {
        EKEventStore.authorizationStatus(for: .reminder) == .fullAccess
    }

    func readAll() async throws -> [Reminder] {
        guard isAvailable else { throw TodayError.accessDenied }

        let predicate = ekStore.predicateForReminders(in: nil)
        let ekReminders = try await ekStore.reminders(matching: predicate)
        let reminders: [Reminder] = try ekReminders.compactMap { ekReminder in
            do {
                return try Reminder(with: ekReminder)
            } catch TodayError.reminderHasNoDueDate {
                return nil
            }
        }
        return reminders
    }
}
