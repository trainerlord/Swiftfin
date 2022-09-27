//
// Swiftfin is subject to the terms of the Mozilla Public
// License, v2.0. If a copy of the MPL was not distributed with this
// file, you can obtain one at https://mozilla.org/MPL/2.0/.
//
// Copyright (c) 2022 Jellyfin & Jellyfin Contributors
//

import Sliders
import SwiftUI

extension ItemVideoPlayer {
    
    struct Overlay: View {
        
        @ObservedObject
        var viewModel: ItemVideoPlayerViewModel
        
        var body: some View {
            VStack {
                TopBarView(viewModel: viewModel)
                    .frame(height: 50)
                    .padding()
                    .background {
                        Color.black
                            .opacity(0.5)
                    }
                
                Spacer()
                    .allowsHitTesting(false)
                
                BottomBarView(viewModel: viewModel)
                    .frame(height: 50)
                    .padding()
                    .background {
                        Color.black
                            .opacity(0.5)
                    }
            }
        }
    }
}

extension ItemVideoPlayer {
    
    struct GestureHandler: UIViewRepresentable {
        
        func makeUIView(context: Context) -> some UIView {
            UIView()
        }
        
        func updateUIView(_ uiView: UIViewType, context: Context) {
            
        }
    }
    
    class UIGestureHandler: UIView {
        
        
    }
}