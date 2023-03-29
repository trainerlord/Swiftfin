//
// Swiftfin is subject to the terms of the Mozilla Public
// License, v2.0. If a copy of the MPL was not distributed with this
// file, you can obtain one at https://mozilla.org/MPL/2.0/.
//
// Copyright (c) 2023 Jellyfin & Jellyfin Contributors
//

import SwiftUI

struct PhotoView: View {
    
    @ObservedObject
    var photoModel: PhotoItemViewModel
    
    @State private var tabSelection = 0
    @State private var offset = CGSize.zero
    @State private var swipe: Double = 1
    @GestureState private var dragInfo: CGPoint? = nil

    
    var body: some View {
            ZStack {
                Color.black
                VStack {
                    TabView(selection: $tabSelection) {
                        ForEach(  Array(photoModel.photoAlbumItems.enumerated()), id: \.element.id) {index, image in
                            Group {
                                ImageView(image.imageSource(.primary, maxWidth: UIScreen.main.bounds.width, maxHeight: UIScreen.main.bounds.height)).failure {
                                    InitialFailureView(image.displayTitle.initials)
                                }.resizingMode(.aspectFit).frame(width: UIScreen.main.bounds.width).opacity(swipe)
                            }.tag(index)
                        }
                    }.tabViewStyle(.page(indexDisplayMode: .never)).onAppear {
                        tabSelection = photoModel.SelectedPhoto
                    }
                    HStack {
                        Button {
                            tabSelection = tabSelection - 1
                            if (tabSelection < 0) {tabSelection = 0}
                        } label: {Text("Previos")}
                        Button {
                            tabSelection = tabSelection + 1
                            if (tabSelection >= photoModel.photoAlbumItems.count) {tabSelection = photoModel.photoAlbumItems.count-1}
                        } label: {Text("Next")}
                        
                    }
                }
                
            }.ignoresSafeArea().zIndex(4)
        
        
    }

}
