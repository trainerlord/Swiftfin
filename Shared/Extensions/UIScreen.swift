//
// Swiftfin is subject to the terms of the Mozilla Public
// License, v2.0. If a copy of the MPL was not distributed with this
// file, you can obtain one at https://mozilla.org/MPL/2.0/.
//
// Copyright (c) 2023 Jellyfin & Jellyfin Contributors
//

import UIKit

extension UIScreen {

    func scale(_ x: Int) -> Int {
        Int(nativeScale) * x
    }

    func scale(_ x: CGFloat) -> Int {
        Int(nativeScale * x)
    }

    func maxChildren(width: CGFloat, height: CGFloat) -> Int {
        let screenSize = bounds.height * bounds.width
        let itemSize = width * height
        return Int(screenSize / itemSize)
    }
}
