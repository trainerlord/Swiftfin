//
// Swiftfin is subject to the terms of the Mozilla Public
// License, v2.0. If a copy of the MPL was not distributed with this
// file, you can obtain one at https://mozilla.org/MPL/2.0/.
//
// Copyright (c) 2022 Jellyfin & Jellyfin Contributors
//

import Defaults
import JellyfinAPI
import SwiftUI

extension HomeView {

    struct LatestInLibraryView: View {

        @EnvironmentObject
        private var router: HomeCoordinator.Router
        @ObservedObject
        var viewModel: LibraryViewModel

        @Default(.Customization.latestInLibraryPosterType)
        var latestInLibraryPosterType

        private var items: [PosterButtonType<BaseItemDto>] {
            if viewModel.isLoading {
                return PosterButtonType.loading.random(in: 3 ..< 8)
            } else {
                return viewModel.items.prefix(20).asArray.map { .item($0) }
            }
        }

        var body: some View {
            PosterHStack(
                title: L10n.latestWithString(viewModel.parent?.displayName ?? .emptyDash),
                type: latestInLibraryPosterType,
                items: items
            )
            .trailing {
                SeeAllButton()
                    .onSelect {
                        router.route(to: \.library, viewModel.libraryCoordinatorParameters)
                    }
            }
            .onSelect { item in
                router.route(to: \.item, item)
            }
        }
    }
}
