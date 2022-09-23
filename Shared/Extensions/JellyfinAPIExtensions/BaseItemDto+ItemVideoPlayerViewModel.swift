//
// Swiftfin is subject to the terms of the Mozilla Public
// License, v2.0. If a copy of the MPL was not distributed with this
// file, you can obtain one at https://mozilla.org/MPL/2.0/.
//
// Copyright (c) 2022 Jellyfin & Jellyfin Contributors
//

import Combine
import Factory
import Foundation
import JellyfinAPI
import VLCUI

class ItemVideoPlayerViewModel: ObservableObject, VLCVideoPlayerDelegate {

    @Published
    var currentSeconds: Int = 0
    @Published
    var state: VLCVideoPlayer.State = .opening
    @Published
    var subtitlesEnabled: Bool = false {
        willSet {
            let trackIndex = newValue ? selectedSubtitleTrackIndex : -1
            eventSubject.send(.setSubtitleTrack(.absolute(trackIndex)))
        }
    }
    @Published
    var selectedSubtitleTrackIndex: Int32 = -1
    var lastPositiveSubtitleTrackIndex: Int32 = -1
    @Published
    var playerSubtitleTracks: [Int32: String] = [:]
    @Published
    var playerAudioTracks: [Int32: String] = [:]
    @Published
    var playerPlaybackSpeed: PlaybackSpeed = .one
    @Published
    var isAspectFilled: Bool = false

    var eventSubject: CurrentValueSubject<VLCVideoPlayer.Event?, Never> = .init(nil)

    let playbackURL: URL
    let item: BaseItemDto
    let audioStreams: [MediaStream]
    let subtitleStreams: [MediaStream]

    init(
        playbackURL: URL,
        item: BaseItemDto,
        audioStreams: [MediaStream],
        subtitleStreams: [MediaStream]
    ) {
        self.playbackURL = playbackURL
        self.item = item
        self.audioStreams = audioStreams
        self.subtitleStreams = subtitleStreams
    }

    func jump(to ticks: Int32) {
        eventSubject.send(.setTime(.ticks(ticks)))
    }

    func vlcVideoPlayer(didUpdateTicks ticks: Int32, with playbackInformation: VLCVideoPlayer.PlaybackInformation) {
        self.currentSeconds = Int(ticks / 1000)
        
        if selectedSubtitleTrackIndex != playbackInformation.currentSubtitleTrack.index {
            lastPositiveSubtitleTrackIndex = max(selectedSubtitleTrackIndex, playbackInformation.currentSubtitleTrack.index)
            selectedSubtitleTrackIndex = playbackInformation.currentSubtitleTrack.index
            subtitlesEnabled = lastPositiveSubtitleTrackIndex != -1
        }
        
        if playerSubtitleTracks != playbackInformation.subtitleTracks {
            playerSubtitleTracks = playbackInformation.subtitleTracks
        }
        
        if playerAudioTracks != playbackInformation.audioTracks {
            playerAudioTracks = playbackInformation.audioTracks
        }
    }

    func vlcVideoPlayer(didUpdateState state: VLCVideoPlayer.State, with playbackInformation: VLCVideoPlayer.PlaybackInformation) {
        self.state = state
    }
    
    func videoSubtitleStreamIndex(of subtitleStreamIndex: Int) -> Int32 {
        let externalSubtitleStreams = subtitleStreams.filter { $0.isExternal == true }

        guard let externalSubtitleStreamIndex = externalSubtitleStreams.firstIndex(where: { $0.index == subtitleStreamIndex }) else {
            return Int32(subtitleStreamIndex)
        }

        let embeddedSubtitleStreamCount = subtitleStreams.count - externalSubtitleStreams.count
        let embeddedStreamCount = 1 + audioStreams.count + embeddedSubtitleStreamCount

        return Int32(embeddedStreamCount + externalSubtitleStreamIndex)
    }
}

extension BaseItemDto {

    func createItemVideoPlayerViewModel() -> AnyPublisher<[ItemVideoPlayerViewModel], Error> {

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
        .map { response in
            response.mediaSources!.map { $0.itemVideoPlayerViewModel(with: self, playSessionID: response.playSessionId!) }
        }
        .eraseToAnyPublisher()
    }
}