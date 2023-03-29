//
// Swiftfin is subject to the terms of the Mozilla Public
// License, v2.0. If a copy of the MPL was not distributed with this
// file, you can obtain one at https://mozilla.org/MPL/2.0/.
//
// Copyright (c) 2023 Jellyfin & Jellyfin Contributors
//

import SwiftUI

extension PhotoItemView {
    
    struct ContentView: View {
        
        @StateObject
        var photoModel = PhotoItemViewModel()
        
        @ObservedObject
        var viewModel: PhotoAlbumItemViewModel
        
        @EnvironmentObject
        private var router: ItemCoordinator.Router
        
        
        static let ITEM_SIZE_MIN_TVOS:CGFloat = 350
        static let ITEM_SIZE_MAX_TVOS:CGFloat = 450
        
        static let ITEM_SPACING:CGFloat = 5
        
        
        static let gridItem: GridItem = GridItem(.flexible(minimum: PhotoItemView.ContentView.ITEM_SIZE_MIN_TVOS, maximum: PhotoItemView.ContentView.ITEM_SIZE_MAX_TVOS), spacing: ITEM_SPACING)
        private let columns = [GridItem(.fixed(ITEM_SIZE_MIN_TVOS)),GridItem(.fixed(ITEM_SIZE_MIN_TVOS)),GridItem(.fixed(ITEM_SIZE_MIN_TVOS)),GridItem(.fixed(ITEM_SIZE_MIN_TVOS)),GridItem(.fixed(ITEM_SIZE_MIN_TVOS))]
        var body: some View {
            VStack(spacing: 0) {
                ScrollView(.vertical, showsIndicators: false) {
                    
                    PosterHStack(type: .landscape, items: viewModel.photoAlbumItems.filter{$0.type == .photoAlbum}).onSelect { album in
                        
                        router.route(to: \.item, album)
                    }

                    LazyVGrid(columns: columns, spacing: PhotoItemView.ContentView.ITEM_SPACING) {
                        ForEach(Array(viewModel.photoAlbumItems.enumerated()), id: \.element.hashValue) { index, item in
                            Button {
                                withAnimation(.easeInOut) {
                                    
                                    photoModel.photoAlbumItems = viewModel.photoAlbumItems
                                    photoModel.SelectedPhoto = index
                                    
                                    router.route(to: \.photo, photoModel)
                                }
                            } label: {
                                ImageView(item.imageSource(.primary, maxWidth: PhotoItemView.ContentView.ITEM_SIZE_MIN_TVOS))
                                    .failure {
                                        InitialFailureView(item.displayTitle.initials)
                                    }.padding(0)
                            }.frame(width: PhotoItemView.ContentView.ITEM_SIZE_MIN_TVOS)
                                .aspectRatio(1, contentMode: .fill)
                                .clipped()
                                .buttonStyle(.plain)
                        }
                    }.padding(20)
                }.environmentObject(photoModel)
            }
            //Color.black
        }
    }
}
