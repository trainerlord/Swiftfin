//
// Swiftfin is subject to the terms of the Mozilla Public
// License, v2.0. If a copy of the MPL was not distributed with this
// file, you can obtain one at https://mozilla.org/MPL/2.0/.
//
// Copyright (c) 2023 Jellyfin & Jellyfin Contributors
//

import CollectionView
import SwiftUI

struct UserListView: View {

    @EnvironmentObject
    private var router: UserListCoordinator.Router

    @ObservedObject
    var viewModel: UserListViewModel

    private var noUserView: some View {
        VStack {
            L10n.signInGetStarted.text
                .frame(minWidth: 50, maxWidth: 240)
                .multilineTextAlignment(.center)

            PrimaryButton(title: L10n.signIn) {
                router.route(to: \.userSignIn, viewModel.server)
            }
            .frame(maxWidth: 300)
            .frame(height: 50)
        }
    }

    @ViewBuilder
    private var gridView: some View {
        CollectionView(items: viewModel.users) { _, user, _ in
            UserProfileButton(user: user, client: viewModel.client)
                .onSelect {
                    viewModel.signIn(user: user)
                }
                .contextMenu {
                    Button(role: .destructive) {
                        viewModel.remove(user: user)
                    } label: {
                        Label(L10n.remove, systemImage: "trash")
                    }
                }
        }
        .layout { _, layoutEnvironment in
            .grid(
                layoutEnvironment: layoutEnvironment,
                layoutMode: .adaptive(withMinItemSize: 120),
                itemSpacing: 30,
                lineSpacing: 30
            )
        }
    }

    var body: some View {
        Group {
            if viewModel.users.isEmpty {
                noUserView
                    .offset(y: -50)
            } else {
                gridView
            }
        }
        .navigationTitle(viewModel.server.name)
        .toolbar {
            ToolbarItemGroup(placement: .navigationBarTrailing) {
                if !viewModel.users.isEmpty {
                    Button {
                        router.route(to: \.userSignIn, viewModel.server)
                    } label: {
                        Image(systemName: "person.crop.circle.fill.badge.plus")
                    }
                }

                Button {
                    router.route(to: \.serverDetail, viewModel.server)
                } label: {
                    Image(systemName: "info.circle.fill")
                }
            }
        }
        .onAppear {
            viewModel.fetchUsers()
        }
    }
}
