//
// Swiftfin is subject to the terms of the Mozilla Public
// License, v2.0. If a copy of the MPL was not distributed with this
// file, you can obtain one at https://mozilla.org/MPL/2.0/.
//
// Copyright (c) 2022 Jellyfin & Jellyfin Contributors
//

import Defaults
import Foundation
import JellyfinAPI
import Stinsen
import SwiftUI

final class SettingsViewModel: ViewModel {

    let server: SwiftfinStore.State.Server
    let user: SwiftfinStore.State.User

    init(server: SwiftfinStore.State.Server, user: SwiftfinStore.State.User) {
        self.server = server
        self.user = user
        super.init()
    }
}
