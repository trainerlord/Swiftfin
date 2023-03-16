//
// Swiftfin is subject to the terms of the Mozilla Public
// License, v2.0. If a copy of the MPL was not distributed with this
// file, you can obtain one at https://mozilla.org/MPL/2.0/.
//
// Copyright (c) 2023 Jellyfin & Jellyfin Contributors
//

import JellyfinAPI
import SwiftUI

struct MediaStreamInfoView: View {

    let mediaStream: MediaStream

    var body: some View {
        Form {
            Section {
                ForEach(mediaStream.metadataProperties) { property in
                    TextPairView(property)
                }
            }

            if !mediaStream.colorProperties.isEmpty {
                Section("Color") {
                    ForEach(mediaStream.colorProperties) { property in
                        TextPairView(property)
                    }
                }
            }

            if !mediaStream.deliveryProperties.isEmpty {
                Section("Delivery") {
                    ForEach(mediaStream.deliveryProperties) { property in
                        TextPairView(property)
                    }
                }
            }
        }
        .navigationTitle(mediaStream.displayTitle ?? .emptyDash)
    }
}
