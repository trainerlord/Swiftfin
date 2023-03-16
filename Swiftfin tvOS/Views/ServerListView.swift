//
// Swiftfin is subject to the terms of the Mozilla Public
// License, v2.0. If a copy of the MPL was not distributed with this
// file, you can obtain one at https://mozilla.org/MPL/2.0/.
//
// Copyright (c) 2023 Jellyfin & Jellyfin Contributors
//

import CollectionView
import SwiftUI

struct ServerListView: View {

    @EnvironmentObject
    private var router: ServerListCoordinator.Router

    @ObservedObject
    var viewModel: ServerListViewModel

    @State
    private var longPressedServer: SwiftfinStore.State.Server?

    @ViewBuilder
    private var listView: some View {
        ScrollView {
            LazyVStack {
                ForEach(viewModel.servers, id: \.id) { server in
                    ServerButton(server: server)
                        .onSelect {
                            router.route(to: \.userList, server)
                        }
                        .onLongPressGesture {
                            longPressedServer = server
                        }
                        .padding(.horizontal, 100)
                }
            }
            .padding(.top, 50)
        }
        .padding(.top, 50)
    }

    @ViewBuilder
    private var noServerView: some View {
        VStack(spacing: 50) {
            L10n.connectToJellyfinServerStart.text
                .frame(maxWidth: 500)
                .multilineTextAlignment(.center)
                .font(.body)

            Button {
                router.route(to: \.connectToServer)
            } label: {
                L10n.connect.text
                    .bold()
                    .font(.callout)
                    .frame(width: 400, height: 75)
                    .background(Color.jellyfinPurple)
            }
            .buttonStyle(.card)
        }
    }

    @ViewBuilder
    private var innerBody: some View {
        if viewModel.servers.isEmpty {
            noServerView
                .offset(y: -50)
        } else {
            listView
        }
    }

    var body: some View {
        innerBody
            .navigationTitle(L10n.servers)
            .if(!viewModel.servers.isEmpty) { view in
                view.toolbar {
                    ToolbarItemGroup(placement: .navigationBarTrailing) {
                        Button {
                            router.route(to: \.connectToServer)
                        } label: {
                            Image(systemName: "plus.circle.fill")
                        }
                        .contextMenu {
                            Button {
                                router.route(to: \.basicAppSettings)
                            } label: {
                                L10n.settings.text
                            }
                        }
                    }
                }
            }
            .alert(item: $longPressedServer) { server in
                Alert(
                    title: Text(server.name),
                    primaryButton: .destructive(L10n.remove.text, action: { viewModel.remove(server: server) }),
                    secondaryButton: .cancel()
                )
            }
            .onAppear {
                viewModel.fetchServers()
            }
    }
}
