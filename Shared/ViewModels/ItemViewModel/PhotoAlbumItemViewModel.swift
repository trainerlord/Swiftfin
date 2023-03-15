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
        ItemsAPI.getItems(
            userId: SessionManager.main.currentLogin.user.id,
            parentId: item.id,
            fields: ItemFields.allCases
        )
        .trackActivity(loading)
        .sink { [weak self] completion in
            self?.handleAPIRequestError(completion: completion)
        } receiveValue: { [weak self] response in
            self?.photoAlbumItems = response.items ?? []
        }
        .store(in: &cancellables)
    }
}
