//
// Swiftfin is subject to the terms of the Mozilla Public
// License, v2.0. If a copy of the MPL was not distributed with this
// file, you can obtain one at https://mozilla.org/MPL/2.0/.
//
// Copyright (c) 2023 Jellyfin & Jellyfin Contributors
//

import Foundation
import JellyfinAPI
import CoreStore
import Combine

class ServerDetailViewModel: ViewModel {

    var server: ServerState

    init(server: ServerState) {
        self.server = server
    }

    
    func setServerCurrentURI(uri: String) {
        
        let newURL = server.urls.filter{ $0.absoluteString == uri }[0]
        
        userSession
    }
}
