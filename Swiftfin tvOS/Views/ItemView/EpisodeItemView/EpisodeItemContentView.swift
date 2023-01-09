//
// Swiftfin is subject to the terms of the Mozilla Public
// License, v2.0. If a copy of the MPL was not distributed with this
// file, you can obtain one at https://mozilla.org/MPL/2.0/.
//
// Copyright (c) 2023 Jellyfin & Jellyfin Contributors
//

import SwiftUI

extension EpisodeItemView {

    struct ContentView: View {

        @ObservedObject
        var viewModel: EpisodeItemViewModel

        @EnvironmentObject
        private var router: ItemCoordinator.Router

        var body: some View {
            VStack(spacing: 0) {

                Self.EpisodeCinematicHeaderView(viewModel: viewModel)
                    .frame(height: UIScreen.main.bounds.height - 150)
                    .padding(.bottom, 50)

                ItemView.CastAndCrewHStack(people: viewModel.item.people ?? [])

                if let seriesItem = viewModel.seriesItem {
                    PosterHStack(title: L10n.series, type: .portrait, items: [seriesItem])
                        .onSelect { item in
                            router.route(to: \.item, item)
                        }
                }

                ItemView.AboutView(viewModel: viewModel)
            }
            .background {
                BlurView(style: .dark)
                    .mask {
                        VStack(spacing: 0) {
                            LinearGradient(
                                stops: [
                                    .init(color: .clear, location: 0.5),
                                    .init(color: .white.opacity(0.8), location: 0.7),
                                    .init(color: .white.opacity(0.8), location: 0.95),
                                    .init(color: .white, location: 1),
                                ],
                                startPoint: .top,
                                endPoint: .bottom
                            )
                            .frame(height: UIScreen.main.bounds.height - 150)

                            Color.white
                        }
                    }
            }
        }
    }
}

extension EpisodeItemView.ContentView {

    struct EpisodeCinematicHeaderView: View {

        enum CinematicHeaderFocusLayer: Hashable {
            case top
            case playButton
        }

        @EnvironmentObject
        private var router: ItemCoordinator.Router
        @FocusState
        private var focusedLayer: CinematicHeaderFocusLayer?
        @ObservedObject
        var viewModel: EpisodeItemViewModel

        var body: some View {
            VStack(alignment: .leading) {

                Color.clear
                    .focusable()
                    .focused($focusedLayer, equals: .top)

                HStack(alignment: .bottom) {

                    VStack(alignment: .leading, spacing: 20) {

                        if let seriesName = viewModel.item.seriesName {
                            Text(seriesName)
                                .font(.headline)
                                .fontWeight(.semibold)
                                .foregroundColor(.secondary)
                        }

                        Text(viewModel.item.displayTitle)
                            .font(.title2)
                            .fontWeight(.semibold)
                            .lineLimit(1)
                            .multilineTextAlignment(.leading)
                            .foregroundColor(.white)

                        if let overview = viewModel.item.overview {
                            Text(overview)
                                .font(.subheadline)
                                .lineLimit(4)
                        } else {
                            L10n.noOverviewAvailable.text
                        }

                        HStack {
                            DotHStack {
                                if let premiereYear = viewModel.item.premiereDateYear {
                                    premiereYear.text
                                }

                                if let playButtonitem = viewModel.playButtonItem, let runtime = playButtonitem.getItemRuntime() {
                                    runtime.text
                                }
                            }
                            .font(.caption)
                            .foregroundColor(Color(UIColor.lightGray))

                            ItemView.AttributesHStack(viewModel: viewModel)
                        }
                    }

                    Spacer()

                    VStack {
                        ItemView.PlayButton(viewModel: viewModel)
                            .focused($focusedLayer, equals: .playButton)

                        ItemView.ActionButtonHStack(viewModel: viewModel)
                            .frame(width: 400)
                    }
                    .frame(width: 450)
                    .padding(.leading, 150)
                }
            }
            .padding(.horizontal, 50)
            .onChange(of: focusedLayer) { layer in
                if layer == .top {
                    focusedLayer = .playButton
                }
            }
        }
    }
}
