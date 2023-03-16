//
// Swiftfin is subject to the terms of the Mozilla Public
// License, v2.0. If a copy of the MPL was not distributed with this
// file, you can obtain one at https://mozilla.org/MPL/2.0/.
//
// Copyright (c) 2023 Jellyfin & Jellyfin Contributors
//

import Foundation
import Stinsen
import SwiftUI

final class MainTabCoordinator: TabCoordinatable {
    var child = TabChild(startingItems: [
        \MainTabCoordinator.home,
        \MainTabCoordinator.tvShows,
        \MainTabCoordinator.movies,
        \MainTabCoordinator.search,
        \MainTabCoordinator.media,
        \MainTabCoordinator.settings,
    ])

    @Route(tabItem: makeHomeTab)
    var home = makeHome
    @Route(tabItem: makeTvTab)
    var tvShows = makeTVShows
    @Route(tabItem: makeMoviesTab)
    var movies = makeMovies
    @Route(tabItem: makeSearchTab)
    var search = makeSearch
    @Route(tabItem: makeMediaTab)
    var media = makeMedia
    @Route(tabItem: makeSettingsTab)
    var settings = makeSettings

    func makeHome() -> NavigationViewCoordinator<HomeCoordinator> {
        NavigationViewCoordinator(HomeCoordinator())
    }

    @ViewBuilder
    func makeHomeTab(isActive: Bool) -> some View {
        HStack {
            Image(systemName: "house")
            L10n.home.text
        }
    }

    func makeTVShows() -> NavigationViewCoordinator<BasicLibraryCoordinator> {
        let parameters = BasicLibraryCoordinator.Parameters(
            title: nil,
            viewModel: ItemTypeLibraryViewModel(itemTypes: [.series], filters: .init())
        )
        return NavigationViewCoordinator(BasicLibraryCoordinator(parameters: parameters))
    }

    @ViewBuilder
    func makeTvTab(isActive: Bool) -> some View {
        HStack {
            Image(systemName: "tv")
            L10n.tvShows.text
        }
    }

    func makeMovies() -> NavigationViewCoordinator<BasicLibraryCoordinator> {
        let parameters = BasicLibraryCoordinator.Parameters(
            title: nil,
            viewModel: ItemTypeLibraryViewModel(itemTypes: [.movie], filters: .init())
        )
        return NavigationViewCoordinator(BasicLibraryCoordinator(parameters: parameters))
    }

    @ViewBuilder
    func makeMoviesTab(isActive: Bool) -> some View {
        HStack {
            Image(systemName: "film")
            L10n.movies.text
        }
    }

    func makeSearch() -> NavigationViewCoordinator<SearchCoordinator> {
        NavigationViewCoordinator(SearchCoordinator())
    }

    @ViewBuilder
    func makeSearchTab(isActive: Bool) -> some View {
        HStack {
            Image(systemName: "magnifyingglass")
            L10n.search.text
        }
    }

    func makeMedia() -> NavigationViewCoordinator<MediaCoordinator> {
        NavigationViewCoordinator(MediaCoordinator())
    }

    @ViewBuilder
    func makeMediaTab(isActive: Bool) -> some View {
        HStack {
            Image(systemName: "rectangle.stack")
            L10n.media.text
        }
    }

    func makeSettings() -> NavigationViewCoordinator<SettingsCoordinator> {
        NavigationViewCoordinator(SettingsCoordinator())
    }

    @ViewBuilder
    func makeSettingsTab(isActive: Bool) -> some View {
        Image(systemName: "gearshape.fill")
            .accessibilityLabel(L10n.settings)
    }
}
