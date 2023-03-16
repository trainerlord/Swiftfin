//
// Swiftfin is subject to the terms of the Mozilla Public
// License, v2.0. If a copy of the MPL was not distributed with this
// file, you can obtain one at https://mozilla.org/MPL/2.0/.
//
// Copyright (c) 2023 Jellyfin & Jellyfin Contributors
//

import SwiftUI

struct CinematicItemViewTopRow: View {

    @EnvironmentObject
    var itemRouter: ItemCoordinator.Router
    @ObservedObject
    var viewModel: ItemViewModel
    @Environment(\.isFocused)
    var envFocused: Bool
    @State
    var focused: Bool = false
    @State
    var wrappedScrollView: UIScrollView?
    @State
    var title: String
    @State
    var subtitle: String?
    @State
    private var playButtonText: String = ""
    let showDetails: Bool

    init(
        viewModel: ItemViewModel,
        wrappedScrollView: UIScrollView? = nil,
        title: String,
        subtitle: String? = nil,
        showDetails: Bool = true
    ) {
        self.viewModel = viewModel
        self.wrappedScrollView = wrappedScrollView
        self.title = title
        self.subtitle = subtitle
        self.showDetails = showDetails
    }

    var body: some View {
        ZStack(alignment: .bottom) {
            LinearGradient(
                gradient: Gradient(colors: [.clear, .black.opacity(0.8), .black]),
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()
            .frame(height: 210)

            VStack {
                Spacer()

                HStack(alignment: .bottom) {
                    VStack(alignment: .leading) {
                        //						HStack(alignment: .PlayInformationAlignmentGuide) {
//
                        //						}
                    }

                    VStack(alignment: .leading, spacing: 5) {
                        Text(title)
                            .font(.title2)
                            .lineLimit(2)

                        if let subtitle = subtitle {
                            Text(subtitle)
                        }

                        HStack(spacing: 20) {

                            if showDetails {
                                if viewModel.item.itemType == .series {
                                    if let airTime = viewModel.item.airTime {
                                        Text(airTime)
                                            .font(.subheadline)
                                            .fontWeight(.medium)
                                    }
                                } else {
                                    if let runtime = viewModel.item.getItemRuntime() {
                                        Text(runtime)
                                            .font(.subheadline)
                                            .fontWeight(.medium)
                                    }

                                    if let productionYear = viewModel.item.productionYear {
                                        Text(String(productionYear))
                                            .font(.subheadline)
                                            .fontWeight(.medium)
                                            .lineLimit(1)
                                    }
                                }

                                if let officialRating = viewModel.item.officialRating {
                                    Text(officialRating)
                                        .font(.subheadline)
                                        .fontWeight(.semibold)
                                        .lineLimit(1)
                                        .padding(EdgeInsets(top: 1, leading: 4, bottom: 1, trailing: 4))
                                        .overlay(
                                            RoundedRectangle(cornerRadius: 2)
                                                .stroke(Color.secondary, lineWidth: 1)
                                        )
                                }

                                if viewModel.item.unaired {
                                    if let premiereDate = viewModel.item.airDateLabel {
                                        Text(premiereDate)
                                            .font(.subheadline)
                                            .fontWeight(.medium)
                                            .lineLimit(1)
                                    }
                                }

                                // Dud text in case nothing was shown, something is necessary for proper alignment
                                Text("")
                            } else {
                                Text("")
                            }
                        }
                        .foregroundColor(.secondary)
                    }

                    Spacer()
                }
                .padding(.horizontal, 50)
                .padding(.bottom, 50)
            }
        }
        .onAppear {
            playButtonText = viewModel.playButtonText()
        }
        .onChange(of: viewModel.item, perform: { _ in
            playButtonText = viewModel.playButtonText()
        })
        .onChange(of: envFocused) { envFocus in
            if envFocus == true {
                wrappedScrollView?.scrollToTop()
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.01) {
                    wrappedScrollView?.scrollToTop()
                }
            }

            withAnimation(.linear(duration: 0.15)) {
                self.focused = envFocus
            }
        }
    }
}
