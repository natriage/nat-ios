//
//  Date+Extensions.swift
//  Triage
//
//  Created by Francis Li on 3/16/20.
//  Copyright © 2020 Francis Li. All rights reserved.
//

import Foundation

extension Date {
    func asDateString() -> String {
        return DateFormatter.dateFormatter.string(from: self)
    }

    func asISO8601String() -> String {
        return ISO8601DateFormatter.string(from: self)
    }

    func asLocalizedTime() -> String {
        return DateFormatter.localizedString(from: self, dateStyle: .none, timeStyle: .short)
    }

    func asRelativeString() -> String {
        if #available(iOS 13.0, *) {
            return RelativeDateTimeFormatter.localizedString(for: self)
        } else {
            return asTimeString()
        }
    }

    func asTimeDateString() -> String {
        return DateFormatter.timeDateFormatter.string(from: self)
    }

    func asTimeString() -> String {
        return DateFormatter.timeFormatter.string(from: self)
    }

    func dist(to other: Date) -> TimeInterval {
        if #available(iOS 13.0, *) {
            return distance(to: other)
        } else {
            return other.timeIntervalSinceReferenceDate - timeIntervalSinceReferenceDate
        }
    }
}
