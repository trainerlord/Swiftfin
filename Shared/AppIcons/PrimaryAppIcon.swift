//
// Swiftfin is subject to the terms of the Mozilla Public
// License, v2.0. If a copy of the MPL was not distributed with this
// file, you can obtain one at https://mozilla.org/MPL/2.0/.
//
// Copyright (c) 2023 Jellyfin & Jellyfin Contributors
//

import Foundation

enum PrimaryAppIcon: String, AppIcon {

    case primary

    var displayTitle: String {
        switch self {
        case .primary:
            return "Primary"
        }
    }

    static let tag: String = "primary"
}
