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
import SwiftUI

extension BaseItemDto {

    func createItemVideoPlayerViewModel() -> AnyPublisher<[VideoPlayerViewModel], Error> {

        let builder = DeviceProfileBuilder()
        // TODO: fix bitrate settings
        let tempOverkillBitrate = 360_000_000
        builder.setMaxBitrate(bitrate: tempOverkillBitrate)
        let profile = builder.buildProfile()

        let playbackInfoRequest = GetPostedPlaybackInfoRequest(
            userId: SessionManager.main.currentLogin.user.id,
            maxStreamingBitrate: tempOverkillBitrate,
            deviceProfile: profile
        )

        return MediaInfoAPI.getPostedPlaybackInfo(
            itemId: self.id!,
            userId: SessionManager.main.currentLogin.user.id,
            maxStreamingBitrate: tempOverkillBitrate,
            getPostedPlaybackInfoRequest: playbackInfoRequest
        )
        .tryMap { response in
            guard let mediaSources = response.mediaSources else { throw JellyfinAPIError("No media sources given in playback info request.") }
            return mediaSources.map { try! $0.itemVideoPlayerViewModel(with: self, playSessionID: response.playSessionId!) }
        }
        .eraseToAnyPublisher()
    }
    
    func createVideoPlayerViewModel(with mediaSource: MediaSourceInfo) -> AnyPublisher<VideoPlayerViewModel, Error> {
        
        let builder = DeviceProfileBuilder()
        // TODO: fix bitrate settings
        let tempOverkillBitrate = 360_000_000
        builder.setMaxBitrate(bitrate: tempOverkillBitrate)
        let profile = builder.buildProfile()

        let playbackInfoRequest = GetPostedPlaybackInfoRequest(
            userId: SessionManager.main.currentLogin.user.id,
            maxStreamingBitrate: tempOverkillBitrate,
            deviceProfile: profile
        )

        return MediaInfoAPI.getPostedPlaybackInfo(
            itemId: self.id!,
            userId: SessionManager.main.currentLogin.user.id,
            maxStreamingBitrate: tempOverkillBitrate,
            getPostedPlaybackInfoRequest: playbackInfoRequest
        )
        .tryMap { response in
            guard let matchingMediaSource = response.mediaSources?.first(where: { $0.eTag == mediaSource.eTag && $0.name == mediaSource.name }) else { throw JellyfinAPIError("Matching media source not in ") }
            guard let playSessionID = response.playSessionId else { throw JellyfinAPIError("Play session ID not in playback info request") }
            
            return try matchingMediaSource.itemVideoPlayerViewModel(with: self, playSessionID: playSessionID)
        }
        .eraseToAnyPublisher()
    }
}