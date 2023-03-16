//
// Swiftfin is subject to the terms of the Mozilla Public
// License, v2.0. If a copy of the MPL was not distributed with this
// file, you can obtain one at https://mozilla.org/MPL/2.0/.
//
// Copyright (c) 2023 Jellyfin & Jellyfin Contributors
//

import Foundation

extension FixedWidthInteger {

    var timeLabel: String {
        let hours = self / 3600
        let minutes = (self % 3600) / 60
        let seconds = self % 3600 % 60

        let hourText = hours > 0 ? String(hours).appending(":") : ""
        let minutesText = hours > 0 ? String(minutes).leftPad(toWidth: 2, withString: "0").appending(":") : String(minutes)
            .appending(":")
        let secondsText = String(seconds).leftPad(toWidth: 2, withString: "0")

        return hourText
            .appending(minutesText)
            .appending(secondsText)
    }
}

extension Int {

    /// Format if the current value represents milliseconds
    var millisecondFormat: String {
        let isNegative = self < 0
        let value = abs(self)
        let seconds = "\(value / 1000)"
        let milliseconds = "\(value % 1000)".first ?? "0"

        return seconds
            .appending(".")
            .appending(milliseconds)
            .appending("s")
            .prepending("-", if: isNegative)
    }

    // Format if the current value represents seconds
    var secondFormat: String {
        let isNegative = self < 0
        let value = abs(self)
        let seconds = "\(value)"

        return seconds
            .appending("s")
            .prepending("-", if: isNegative)
    }
}
