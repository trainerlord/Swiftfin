//
// Swiftfin is subject to the terms of the Mozilla Public
// License, v2.0. If a copy of the MPL was not distributed with this
// file, you can obtain one at https://mozilla.org/MPL/2.0/.
//
// Copyright (c) 2023 Jellyfin & Jellyfin Contributors
//

import UIKit

extension UIColor {

    static let jellyfinPurple = UIColor(red: 172 / 255, green: 92 / 255, blue: 195 / 255, alpha: 1)

    var overlayColor: UIColor {
        var red: CGFloat = 0
        var green: CGFloat = 0
        var blue: CGFloat = 0
        var alpha: CGFloat = 0

        getRed(&red, green: &green, blue: &blue, alpha: &alpha)

        let brightness = ((red * 299) + (green * 587) + (blue * 114)) / 1000

        return brightness < 0.5 ? .white : .black
    }
}
