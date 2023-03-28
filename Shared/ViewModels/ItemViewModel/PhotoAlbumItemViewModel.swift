//
// Swiftfin is subject to the terms of the Mozilla Public
// License, v2.0. If a copy of the MPL was not distributed with this
// file, you can obtain one at https://mozilla.org/MPL/2.0/.
//
// Copyright (c) 2022 Jellyfin & Jellyfin Contributors
//

import Combine
import Foundation
import JellyfinAPI

final class PhotoAlbumItemViewModel: ItemViewModel {

    @Published
    var photoAlbumItems: [BaseItemDto] = []
    
    @Published
    var SelectedPhoto: BaseItemDto? = nil
    
    override init(item: BaseItemDto) {
        super.init(item: item)

        getCollectionItems()
    }

    private func getCollectionItems() {
        Task {
            let parameters = Paths.GetItemsParameters(
                userID: userSession.user.id,
                parentID: item.id,
                fields: ItemFields.allCases
            )
            let request = Paths.getItems(parameters: parameters)
            let response = try await userSession.client.send(request)

            await MainActor.run {
                self.photoAlbumItems = response.value.items ?? []
            }
        }
        
    }
}
