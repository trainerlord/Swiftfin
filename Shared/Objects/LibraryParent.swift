//
// Swiftfin is subject to the terms of the Mozilla Public
// License, v2.0. If a copy of the MPL was not distributed with this
// file, you can obtain one at https://mozilla.org/MPL/2.0/.
//
// Copyright (c) 2022 Jellyfin & Jellyfin Contributors
//

import Foundation

protocol LibraryParent: Displayable {
    var id: String? { get }
}

// TODO: Remove so multiple people/studios can be used
enum LibraryParentType {
    case library
    case folders
    case person
    case studio
    case homeVideos
}
