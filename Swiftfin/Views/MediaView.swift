//
// Swiftfin is subject to the terms of the Mozilla Public
// License, v2.0. If a copy of the MPL was not distributed with this
// file, you can obtain one at https://mozilla.org/MPL/2.0/.
//
// Copyright (c) 2022 Jellyfin & Jellyfin Contributors
//

import CollectionView
import JellyfinAPI
import Stinsen
import SwiftUI

struct MediaView: View {

    @EnvironmentObject
    private var router: MediaCoordinator.Router
    @ObservedObject
    var viewModel: MediaViewModel

    private var gridLayout: NSCollectionLayoutSection.GridLayoutMode {
        if UIDevice.isPhone {
            return .fixedNumberOfColumns(2)
        } else {
            return .adaptive(withMinItemSize: PosterType.landscape.width)
        }
    }

    var body: some View {
        CollectionView(items: viewModel.libraryItems) { _, item, _ in
            PosterButton(item: item, type: .landscape)
                .scaleItem(UIDevice.isPhone ? 0.85 : 1)
                .onSelect {
                    print("\(item.library.collectionType ?? "NIL")")
                    switch item.library.collectionType {
                    case "favorites":
                        router.route(to: \.library, .init(parent: item.library, type: .library, filters: .favorites))
                    case "folders":
                        router.route(to: \.library, .init(parent: item.library, type: .folders, filters: .init()))
                    case "liveTV":
                        router.route(to: \.liveTV)
                    case "homevideos":
                        router.route(to: \.library, .init(parent: item.library, type: .homeVideos, filters: .init()))
                    default:
                        router.route(to: \.library, .init(parent: item.library, type: .library, filters: .init()))
                    }
                }
                .imageOverlay {
                    ZStack {
                        Color.black
                            .opacity(0.5)

                        Text(item.library.displayName)
                            .foregroundColor(.white)
                            .font(.title2)
                            .fontWeight(.semibold)
                            .lineLimit(2)
                            .multilineTextAlignment(.center)
                            .frame(alignment: .center)
                    }
                }
        }
        .layout { _, layoutEnvironment in
            .grid(
                layoutEnvironment: layoutEnvironment,
                layoutMode: gridLayout,
                sectionInsets: .init(top: 0, leading: 10, bottom: 0, trailing: 10)
            )
        }
        .configure { configuration in
            configuration.showsVerticalScrollIndicator = false
        }
        .ignoresSafeArea()
        .navigationTitle(L10n.allMedia)
        .toolbar {
            ToolbarItemGroup(placement: .navigationBarTrailing) {
                if viewModel.isLoading {
                    ProgressView()
                }
            }
        }
    }
}
