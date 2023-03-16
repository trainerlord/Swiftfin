//
// Swiftfin is subject to the terms of the Mozilla Public
// License, v2.0. If a copy of the MPL was not distributed with this
// file, you can obtain one at https://mozilla.org/MPL/2.0/.
//
// Copyright (c) 2023 Jellyfin & Jellyfin Contributors
//

import Foundation
import JellyfinAPI
import Stinsen
import SwiftUI

final class CastAndCrewLibraryCoordinator: NavigationCoordinatable {

    let stack = NavigationStack(initial: \CastAndCrewLibraryCoordinator.start)

    @Root
    var start = makeStart
    @Route(.push)
    var library = makeLibrary

    let people: [BaseItemPerson]

    init(people: [BaseItemPerson]) {
        self.people = people
    }

    @ViewBuilder
    func makeStart() -> some View {
        CastAndCrewLibraryView(people: people)
    }

    func makeLibrary(parameters: LibraryCoordinator.Parameters) -> LibraryCoordinator {
        LibraryCoordinator(parameters: parameters)
    }
}
