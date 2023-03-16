//
// Swiftfin is subject to the terms of the Mozilla Public
// License, v2.0. If a copy of the MPL was not distributed with this
// file, you can obtain one at https://mozilla.org/MPL/2.0/.
//
// Copyright (c) 2023 Jellyfin & Jellyfin Contributors
//

import Combine
import Defaults
import Foundation
import JellyfinAPI
import UIKit
import VLCUI

// TODO: better online/offline handling
// TODO: proper error catching
// TODO: better solution for previous/next

class VideoPlayerManager: ViewModel {

    class CurrentProgressHandler: ObservableObject {

        @Published
        var progress: CGFloat = 0
        @Published
        var scrubbedProgress: CGFloat = 0

        @Published
        var seconds: Int = 0
        @Published
        var scrubbedSeconds: Int = 0
    }

    @Published
    var audioTrackIndex: Int = -1
    @Published
    var state: VLCVideoPlayer.State = .opening
    @Published
    var subtitleTrackIndex: Int = -1

    // MARK: ViewModel

    @Published
    var previousViewModel: VideoPlayerViewModel?
    @Published
    var currentViewModel: VideoPlayerViewModel! {
        willSet {
            guard let newValue else { return }
            hasSentStart = false
            getAdjacentEpisodes(for: newValue.item)
        }
    }

    @Published
    var nextViewModel: VideoPlayerViewModel?

    var currentProgressHandler: CurrentProgressHandler = .init()
    let proxy: VLCVideoPlayer.Proxy = .init()

    private var currentProgressWorkItem: DispatchWorkItem?
    private var hasSentStart = false

    func selectNextViewModel() {
        guard let nextViewModel else { return }
        currentViewModel = nextViewModel
        previousViewModel = nil
        self.nextViewModel = nil
    }

    func selectPreviousViewModel() {
        guard let previousViewModel else { return }
        currentViewModel = previousViewModel
        self.previousViewModel = nil
        nextViewModel = nil
    }

    func onTicksUpdated(ticks: Int, playbackInformation: VLCVideoPlayer.PlaybackInformation) {

        if audioTrackIndex != playbackInformation.currentAudioTrack.index {
            audioTrackIndex = playbackInformation.currentAudioTrack.index
        }

        if subtitleTrackIndex != playbackInformation.currentSubtitleTrack.index {
            subtitleTrackIndex = playbackInformation.currentSubtitleTrack.index
        }
    }

    func onStateUpdated(newState: VLCVideoPlayer.State) {
        guard state != newState else { return }
        state = newState

        if !hasSentStart, newState == .playing {
            hasSentStart = true
            sendStartReport()
        }

        if hasSentStart, newState == .paused {
            hasSentStart = false
            sendPauseReport()
        }

        if newState == .stopped || newState == .ended {
            sendStopReport()
        }
    }

    func getAdjacentEpisodes(for item: BaseItemDto) {
        Task { @MainActor in
            guard let seriesID = item.seriesID, item.type == .episode else { return }

            let parameters = Paths.GetEpisodesParameters(
                userID: userSession.user.id,
                fields: ItemFields.minimumCases,
                adjacentTo: item.id!,
                limit: 3
            )
            let request = Paths.getEpisodes(seriesID: seriesID, parameters: parameters)
            let response = try await userSession.client.send(request)

            // 4 possible states:
            //  1 - only current episode
            //  2 - two episodes with next episode
            //  3 - two episodes with previous episode
            //  4 - three episodes with current in middle

            // 1
            guard let items = response.value.items, items.count > 1 else { return }

            var previousItem: BaseItemDto?
            var nextItem: BaseItemDto?

            if items.count == 2 {
                if items[0].id == item.id {
                    // 2
                    nextItem = items[1]

                } else {
                    // 3
                    previousItem = items[0]
                }
            } else {
                nextItem = items[2]
                previousItem = items[0]
            }

            var nextViewModel: VideoPlayerViewModel?
            var previousViewModel: VideoPlayerViewModel?

            if let nextItem, let nextItemMediaSource = nextItem.mediaSources?.first {
                nextViewModel = try await nextItem.videoPlayerViewModel(with: nextItemMediaSource)
            }

            if let previousItem, let previousItemMediaSource = previousItem.mediaSources?.first {
                previousViewModel = try await previousItem.videoPlayerViewModel(with: previousItemMediaSource)
            }

            await MainActor.run {
                self.nextViewModel = nextViewModel
                self.previousViewModel = previousViewModel
            }
        }
    }

    func sendStartReport() {

        #if DEBUG
        guard Defaults[.sendProgressReports] else { return }
        #endif

        currentProgressWorkItem?.cancel()

        print("sent start report")

        Task {
            let startInfo = PlaybackStartInfo(
                audioStreamIndex: audioTrackIndex,
                itemID: currentViewModel.item.id,
                mediaSourceID: currentViewModel.mediaSource.id,
                playbackStartTimeTicks: Int(Date().timeIntervalSince1970) * 10_000_000,
                positionTicks: currentProgressHandler.seconds * 10_000_000,
                sessionID: currentViewModel.playSessionID,
                subtitleStreamIndex: subtitleTrackIndex
            )

            let request = Paths.reportPlaybackStart(startInfo)
            let _ = try await userSession.client.send(request)

            let progressTask = DispatchWorkItem {
                self.sendProgressReport()
            }

            currentProgressWorkItem = progressTask

            DispatchQueue.main.asyncAfter(deadline: .now() + 5, execute: progressTask)
        }
    }

    func sendStopReport() {

        #if DEBUG
        guard Defaults[.sendProgressReports] else { return }
        #endif

        print("sent stop report")

        currentProgressWorkItem?.cancel()

        Task {
            let stopInfo = PlaybackStopInfo(
                itemID: currentViewModel.item.id,
                mediaSourceID: currentViewModel.mediaSource.id,
                positionTicks: currentProgressHandler.seconds * 10_000_000,
                sessionID: currentViewModel.playSessionID
            )

            let request = Paths.reportPlaybackStopped(stopInfo)
            let _ = try await userSession.client.send(request)
        }
    }

    func sendPauseReport() {

        #if DEBUG
        guard Defaults[.sendProgressReports] else { return }
        #endif

        print("sent pause report")

        currentProgressWorkItem?.cancel()

        Task {
            let startInfo = PlaybackStartInfo(
                audioStreamIndex: audioTrackIndex,
                isPaused: true,
                itemID: currentViewModel.item.id,
                mediaSourceID: currentViewModel.mediaSource.id,
                positionTicks: currentProgressHandler.seconds * 10_000_000,
                sessionID: currentViewModel.playSessionID,
                subtitleStreamIndex: subtitleTrackIndex
            )

            let request = Paths.reportPlaybackStart(startInfo)
            let _ = try await userSession.client.send(request)
        }
    }

    func sendProgressReport() {

        #if DEBUG
        guard Defaults[.sendProgressReports] else { return }
        #endif

        let progressTask = DispatchWorkItem {
            self.sendProgressReport()
        }

        currentProgressWorkItem = progressTask

        DispatchQueue.main.asyncAfter(deadline: .now() + 5, execute: progressTask)

        Task {
            let progressInfo = PlaybackProgressInfo(
                audioStreamIndex: audioTrackIndex,
                isPaused: false,
                itemID: currentViewModel.item.id,
                mediaSourceID: currentViewModel.item.id,
                playSessionID: currentViewModel.playSessionID,
                positionTicks: currentProgressHandler.seconds * 10_000_000,
                sessionID: currentViewModel.playSessionID,
                subtitleStreamIndex: subtitleTrackIndex
            )

            let request = Paths.reportPlaybackProgress(progressInfo)
            let _ = try await userSession.client.send(request)

            print("sent progress task")
        }
    }
}

// TODO: move to own file
class OnlineVideoPlayerManager: VideoPlayerManager {

    init(item: BaseItemDto, mediaSource: MediaSourceInfo) {
        super.init()

        Task {
            let viewModel = try await item.videoPlayerViewModel(with: mediaSource)

            await MainActor.run {
                self.currentViewModel = viewModel
            }
        }
    }
}

// TODO: move to own file
class DownloadVideoPlayerManager: VideoPlayerManager {

    init(downloadTask: DownloadTask) {
        super.init()

        guard let playbackURL = downloadTask.getMediaURL() else {
            logger.error("Download task does not have media url for item: \(downloadTask.item.displayTitle)")

            return
        }

        self.currentViewModel = .init(
            playbackURL: playbackURL,
            item: downloadTask.item,
            mediaSource: .init(),
            playSessionID: "",
            videoStreams: downloadTask.item.videoStreams,
            audioStreams: downloadTask.item.audioStreams,
            subtitleStreams: downloadTask.item.subtitleStreams,
            selectedAudioStreamIndex: 1,
            selectedSubtitleStreamIndex: 1,
            chapters: downloadTask.item.fullChapterInfo,
            streamType: .direct
        )
    }

    override func getAdjacentEpisodes(for item: BaseItemDto) {}

    override func sendStartReport() {}

    override func sendPauseReport() {}

    override func sendStopReport() {}

    override func sendProgressReport() {}
}
