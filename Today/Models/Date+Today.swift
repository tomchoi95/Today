//
//  Date+Today.swift
//  Today
//
//  Created by Tom Choi on 2/18/26.
//

import Foundation

// 플레이 그라운드에서 직접 보면서 하기!

extension Date {
    var dayAndTimeText: String {
        let timeText = formatted(date: .omitted, time: .shortened)
        if Locale.current.calendar.isDateInToday(self) {
            let timeFormat = NSLocalizedString(
                "Today at %@",
                comment: "Today at time format string"
            )
            return String(format: timeFormat, timeText)
        } else {
            let dateText = formatted(.dateTime.month(.abbreviated).day())
            let dateAndTimeFormat = NSLocalizedString(
                "%@ at %@",
                comment: "Date and time format string"
            )
            return String(format: dateAndTimeFormat, dateText, timeText)
        }
    }

    var dayText: String {
        if Locale.current.calendar.isDateInToday(self) {
            return NSLocalizedString("Today", comment: "Today due date description")
        } else {
            return formatted(.dateTime.month().day().weekday(.wide))
        }
    }
}
