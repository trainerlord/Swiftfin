//
// Swiftfin is subject to the terms of the Mozilla Public
// License, v2.0. If a copy of the MPL was not distributed with this
// file, you can obtain one at https://mozilla.org/MPL/2.0/.
//
// Copyright (c) 2022 Jellyfin & Jellyfin Contributors
//

import SwiftUI

extension PhotoAlbumItemView {
    struct ContentView: View {
        @EnvironmentObject
        private var itemRouter: ItemCoordinator.Router
        @ObservedObject
        var viewModel: PhotoAlbumItemViewModel
        var body: some View {
            VStack(alignment: .leading, spacing: 20) {
                if let genres = viewModel.item.genreItems, !genres.isEmpty {
                    ItemView.GenresHStack(genres: genres)

                    Divider()
                }

                // MARK: Studios

                if let studios = viewModel.item.studios, !studios.isEmpty {
                    ItemView.StudiosHStack(studios: studios)

                    Divider()
                }

                // MARK: Items

                if !viewModel.photoAlbumItems.isEmpty {
                    let filtered = viewModel.photoAlbumItems.filter{$0.parentIndexNumber == 0 }
                    PosterHStack(title: L10n.items, type: .portrait, items: filtered)
                        .onSelect { item in
                            itemRouter.route(to: \.item, item)
                    }
                }
            }
        }
    }
}
