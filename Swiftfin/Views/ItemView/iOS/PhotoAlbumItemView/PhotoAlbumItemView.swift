//
// Swiftfin is subject to the terms of the Mozilla Public
// License, v2.0. If a copy of the MPL was not distributed with this
// file, you can obtain one at https://mozilla.org/MPL/2.0/.
//
// Copyright (c) 2022 Jellyfin & Jellyfin Contributors
//

import Defaults
import SwiftUI
import SwiftUICollection
import CollectionView
import CoreStore
import JellyfinAPI

struct PhotoAlbumItemView: View {

    @StateObject
    var photoModel = PhotoItemViewModel()
    
    @ObservedObject
    var viewModel: PhotoAlbumItemViewModel
    
    @Default(.Customization.itemViewType)
    private var itemViewType
    
    @EnvironmentObject
    private var itemRouter: ItemCoordinator.Router
    
    
    @Default(.Customization.Library.gridPosterType)
    private var libraryGridPosterType

    static let ITEM_SIZE_MIN_IOS:CGFloat = 120
    static let ITEM_SIZE_MAX_IOS:CGFloat = 200
    
    static let ITEM_SIZE_MIN_IPADOS:CGFloat = 200
    static let ITEM_SIZE_MAX_IPADOS:CGFloat = 600
    
    static let ITEM_SPACING:CGFloat = 1
    
    private static func getMaxItemSize() -> CGFloat {
        if UIDevice.isIPad {
            return PhotoAlbumItemView.ITEM_SIZE_MAX_IPADOS
        }
        return PhotoAlbumItemView.ITEM_SIZE_MAX_IOS
    }
    
    private static func getMinItemSize() -> CGFloat {
        if UIDevice.isIPad {
            return PhotoAlbumItemView.ITEM_SIZE_MIN_IPADOS
        }
        return PhotoAlbumItemView.ITEM_SIZE_MIN_IOS
    }
    
    
    private let adpativeColums = [GridItem(.adaptive(minimum: PhotoAlbumItemView.getMinItemSize(), maximum: PhotoAlbumItemView.getMaxItemSize()), spacing: ITEM_SPACING)]
    //private var threeColumnGrid = [GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible())]
    var body: some View {
        ScrollView(.vertical) {
            Spacer()
            ScrollView(.horizontal) {
                LazyHStack {
                    ForEach(viewModel.photoAlbumItems.filter{$0.type == BaseItemKind.photoAlbum}, id: \.hashValue)
                    { album in
                        //Text("\(album.name ?? "NIL"): \(album.album ?? "NIL")")
                        
                        PosterButton(item: album, type: libraryGridPosterType)
                            .scaleItem(libraryGridPosterType == .landscape && UIDevice.isPhone ? 0.85 : 1).onSelect {
                                itemRouter.route(to: \.item, album)
                            }
                    }
                }.padding(10)
            }
            LazyVGrid(columns: adpativeColums, spacing: PhotoAlbumItemView.ITEM_SPACING) {
                ForEach(Array(viewModel.photoAlbumItems.enumerated()), id: \.element.hashValue) { index, item in
                    Button {
                        withAnimation(.easeInOut) {
                            
                            photoModel.photoAlbumItems = viewModel.photoAlbumItems
                            photoModel.SelectedPhoto = index
                            itemRouter.route(to: \.photo, photoModel)
                        }
                    } label: {
                        ImageView(item.imageSource(.primary, maxWidth: PhotoAlbumItemView.getMaxItemSize()))
                            .failure {
                                InitialFailureView(item.displayName.initials)
                            }
                    }.frame(minWidth: 0, maxWidth: .infinity)
                        .aspectRatio(1, contentMode: .fill)
                        .clipped()
                }
            }
        }.environmentObject(photoModel)
    }
}
