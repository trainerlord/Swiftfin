//
// Swiftfin is subject to the terms of the Mozilla Public
// License, v2.0. If a copy of the MPL was not distributed with this
// file, you can obtain one at https://mozilla.org/MPL/2.0/.
//
// Copyright (c) 2023 Jellyfin & Jellyfin Contributors
//

import Defaults
import SwiftUI

struct DownloadTaskView: View {

    @EnvironmentObject
    private var router: DownloadTaskCoordinator.Router

    @ObservedObject
    var downloadTask: DownloadTask

    var body: some View {
        ScrollView(showsIndicators: false) {
            ContentView(downloadTask: downloadTask)
        }
        .navigationCloseButton {
            router.dismissCoordinator()
        }
    }
}
