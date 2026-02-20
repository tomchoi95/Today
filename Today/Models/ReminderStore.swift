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
}
