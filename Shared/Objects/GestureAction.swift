//
// Swiftfin is subject to the terms of the Mozilla Public
// License, v2.0. If a copy of the MPL was not distributed with this
// file, you can obtain one at https://mozilla.org/MPL/2.0/.
//
// Copyright (c) 2023 Jellyfin & Jellyfin Contributors
//

import Defaults
import Foundation

// TODO: look at optional values for defaults to remove .none

protocol GestureAction: CaseIterable, Codable, Defaults.Serializable, Displayable {}

enum LongPressAction: String, GestureAction {

    case none
    case gestureLock

    var displayTitle: String {
        switch self {
        case .none:
            return L10n.none
        case .gestureLock:
            return "Gesture Lock"
        }
    }
}

enum MultiTapAction: String, GestureAction {

    case none
    case jump

    var displayTitle: String {
        switch self {
        case .none:
            return L10n.none
        case .jump:
            return "Jump"
        }
    }
}

enum PanAction: String, GestureAction {

    case none
    case audioffset
    case brightness
    case playbackSpeed
    case scrub
    case slowScrub
    case subtitleOffset
    case volume

    var displayTitle: String {
        switch self {
        case .none:
            return L10n.none
        case .audioffset:
            return "Audio Offset"
        case .brightness:
            return "Brightness"
        case .playbackSpeed:
            return "Playback Speed"
        case .scrub:
            return "Scrub"
        case .slowScrub:
            return "Slow Scrub"
        case .subtitleOffset:
            return "Subtitle Offset"
        case .volume:
            return "Volume"
        }
    }
}

enum PinchAction: String, GestureAction {

    case none
    case aspectFill

    var displayTitle: String {
        switch self {
        case .none:
            return L10n.none
        case .aspectFill:
            return "Aspect Fill"
        }
    }
}

enum SwipeAction: String, GestureAction {

    case none
    case jump

    var displayTitle: String {
        switch self {
        case .none:
            return L10n.none
        case .jump:
            return "Jump"
        }
    }
}
