//
// Swiftfin is subject to the terms of the Mozilla Public
// License, v2.0. If a copy of the MPL was not distributed with this
// file, you can obtain one at https://mozilla.org/MPL/2.0/.
//
// Copyright (c) 2023 Jellyfin & Jellyfin Contributors
//

import CollectionView
import Defaults
import JellyfinAPI
import SwiftUI

// Manual tab bar hiding is necessary as SwiftUI does not detect
// the underlying UICollectionView for handling

struct PagingLibraryView: View {

    @Default(.Customization.Library.cinematicBackground)
    private var cinematicBackground
    @Default(.Customization.Library.gridPosterType)
    private var libraryPosterType
    @Default(.Customization.showPosterLabels)
    private var showPosterLabels

    @FocusState
    private var focusedItem: BaseItemDto?

    @ObservedObject
    private var viewModel: PagingLibraryViewModel

    @State
    private var isShowingTabBar = true
    @State
    private var presentBackground = false
    @State
    private var scrollViewOffset: CGPoint = .zero
    @State
    private var tabBarController: UITabBarController?

    @StateObject
    private var cinematicBackgroundViewModel: CinematicBackgroundView<BaseItemDto>.ViewModel = .init()

    private var onSelect: (BaseItemDto) -> Void

    private func layout(layoutEnvironment: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection {
        switch libraryPosterType {
        case .portrait:
            return .grid(
                layoutEnvironment: layoutEnvironment,
                layoutMode: .fixedNumberOfColumns(7),
                lineSpacing: 50
            )
        case .landscape:
            return .grid(
                layoutEnvironment: layoutEnvironment,
                layoutMode: .adaptive(withMinItemSize: 400),
                lineSpacing: 50,
                itemSize: .estimated(400),
                sectionInsets: .zero
            )
        }
    }

    var body: some View {
        ZStack {
            if cinematicBackground {
                CinematicBackgroundView(viewModel: cinematicBackgroundViewModel)
                    .visible(presentBackground)
                    .blurred()
            }

            CollectionView(items: viewModel.items.elements) { _, item, _ in
                PosterButton(item: item, type: libraryPosterType)
                    .onSelect {
                        onSelect(item)
                    }
                    .focused($focusedItem, equals: item)
            }
            .layout { _, layoutEnvironment in
                layout(layoutEnvironment: layoutEnvironment)
            }
            .willReachEdge(insets: .init(top: 0, leading: 0, bottom: 600, trailing: 0)) { edge in
                if !viewModel.isLoading && edge == .bottom {
                    viewModel.requestNextPage()
                }
            }
            .scrollViewOffset($scrollViewOffset)
        }
        .id(libraryPosterType.hashValue)
        .id(showPosterLabels)
        .introspectTabBarController { tabBarController in
            self.tabBarController = tabBarController
        }
        .onChange(of: focusedItem) { newValue in
            guard let newValue else {
                withAnimation {
                    presentBackground = false
                }
                return
            }

            cinematicBackgroundViewModel.select(item: newValue)

            if !presentBackground {
                withAnimation {
                    presentBackground = true
                }
            }
        }
        .onChange(of: scrollViewOffset) { newValue in
            if newValue.y < 50 && !isShowingTabBar {
                isShowingTabBar = true
            } else if newValue.y > 50 && isShowingTabBar {
                isShowingTabBar = false
            }
        }
        .onChange(of: isShowingTabBar) { newValue in
            UIView.animate(withDuration: 0.3) {
                tabBarController?.tabBar.alpha = newValue ? 1 : 0
            }
        }
    }
}

extension PagingLibraryView {

    init(viewModel: PagingLibraryViewModel) {
        self.init(
            viewModel: viewModel, onSelect: { _ in }
        )
    }

    func onSelect(_ action: @escaping (BaseItemDto) -> Void) -> Self {
        copy(modifying: \.onSelect, with: action)
    }
}
