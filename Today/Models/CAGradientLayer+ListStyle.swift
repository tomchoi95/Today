//
//  CAGradientLayer+ListStyle.swift
//  Today
//
//  Created by Tom Choi on 2/20/26.
//

import UIKit

extension CAGradientLayer {
    private static func colors(for style: ReminderListStyle) -> [CGColor] {
        let beginColor: UIColor
        let endColor: UIColor

        switch style {
        case .all:
            beginColor = .todayGradientAllBegin
            endColor = .todayGradientAllEnd
        case .future:
            beginColor = .todayGradientFutureBegin
            endColor = .todayGradientFutureEnd
        case .today:
            beginColor = .todayGradientTodayBegin
            endColor = .todayGradientTodayEnd
        }
        return [beginColor.cgColor, endColor.cgColor]
    }
}
