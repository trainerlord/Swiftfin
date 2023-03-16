//
// Swiftfin is subject to the terms of the Mozilla Public
// License, v2.0. If a copy of the MPL was not distributed with this
// file, you can obtain one at https://mozilla.org/MPL/2.0/.
//
// Copyright (c) 2023 Jellyfin & Jellyfin Contributors
//

import CoreData
import Defaults
import Factory
import Stinsen
import SwiftUI

struct SettingsView: View {

    @Default(.accentColor)
    private var accentColor
    @Default(.appAppearance)
    private var appAppearance
    @Default(.VideoPlayer.videoPlayerType)
    private var videoPlayerType

    @Injected(Container.userSession)
    private var userSession

    @EnvironmentObject
    private var router: SettingsCoordinator.Router

    @ObservedObject
    var viewModel: SettingsViewModel

    var body: some View {
        Form {

            Section {
                HStack {
                    L10n.user.text
                    Spacer()
                    Text(userSession.user.username)
                        .foregroundColor(accentColor)
                }

                ChevronButton(title: L10n.server, subtitle: userSession.server.name)
                    .onSelect {
                        router.route(to: \.serverDetail)
                    }

                ChevronButton(title: L10n.quickConnect)
                    .onSelect {
                        router.route(to: \.quickConnect)
                    }

                Button {
                    router.dismissCoordinator {
                        viewModel.signOut()
                    }
                } label: {
                    L10n.switchUser.text
                        .font(.callout)
                }
            }

            Section {
                EnumPicker(
                    title: "Video Player Type",
                    selection: $videoPlayerType
                )

                ChevronButton(title: "Native Player")
                    .onSelect {
                        router.route(to: \.nativePlayerSettings)
                    }

                ChevronButton(title: L10n.videoPlayer)
                    .onSelect {
                        router.route(to: \.videoPlayerSettings)
                    }
            } header: {
                L10n.videoPlayer.text
            }

            Section {
                EnumPicker(title: L10n.appearance, selection: $appAppearance)

                ChevronButton(title: "App Icon")
                    .onSelect {
                        router.route(to: \.appIconSelector)
                    }

                ChevronButton(title: L10n.customize)
                    .onSelect {
                        router.route(to: \.customizeViewsSettings)
                    }

                ChevronButton(title: L10n.experimental)
                    .onSelect {
                        router.route(to: \.experimentalSettings)
                    }
            } header: {
                L10n.accessibility.text
            }

            Section {
                ColorPicker("Accent Color", selection: $accentColor, supportsOpacity: false)
            } footer: {
                Text("Some views may need an app restart to update.")
            }

            ChevronButton(title: L10n.about)
                .onSelect {
                    router.route(to: \.about)
                }

            ChevronButton(title: "Logs")
                .onSelect {
                    router.route(to: \.log)
                }
        }
        .navigationBarTitle(L10n.settings)
        .navigationBarTitleDisplayMode(.inline)
        .navigationCloseButton {
            router.dismissCoordinator()
        }
    }
}
