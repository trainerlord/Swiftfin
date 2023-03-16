//
// Swiftfin is subject to the terms of the Mozilla Public
// License, v2.0. If a copy of the MPL was not distributed with this
// file, you can obtain one at https://mozilla.org/MPL/2.0/.
//
// Copyright (c) 2023 Jellyfin & Jellyfin Contributors
//

import SwiftUI

extension VideoPlayer.Overlay.ActionButtons {

    struct PlayPreviousItem: View {

        @EnvironmentObject
        private var overlayTimer: TimerProxy
        @EnvironmentObject
        private var videoPlayerManager: VideoPlayerManager

        var body: some View {
            SFSymbolButton(systemName: "chevron.left.circle")
                .onSelect {
                    videoPlayerManager.selectPreviousViewModel()
                    overlayTimer.start(5)
                }
                .frame(maxWidth: 30, maxHeight: 30)
        }
    }
}
