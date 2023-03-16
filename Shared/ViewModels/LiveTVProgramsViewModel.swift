//
// Swiftfin is subject to the terms of the Mozilla Public
// License, v2.0. If a copy of the MPL was not distributed with this
// file, you can obtain one at https://mozilla.org/MPL/2.0/.
//
// Copyright (c) 2023 Jellyfin & Jellyfin Contributors
//

import Foundation
import JellyfinAPI

final class LiveTVProgramsViewModel: ViewModel {

    @Published
    var recommendedItems = [BaseItemDto]()
    @Published
    var seriesItems = [BaseItemDto]()
    @Published
    var movieItems = [BaseItemDto]()
    @Published
    var sportsItems = [BaseItemDto]()
    @Published
    var kidsItems = [BaseItemDto]()
    @Published
    var newsItems = [BaseItemDto]()

    private var channels = [String: BaseItemDto]()

    override init() {
        super.init()

        getChannels()
    }

    func findChannel(id: String) -> BaseItemDto? {
        channels[id]
    }

    private func getChannels() {
//        LiveTvAPI.getLiveTvChannels(
//            userId: "123abc",
//            startIndex: 0,
//            limit: 1000,
//            enableImageTypes: [.primary],
//            enableUserData: false,
//            enableFavoriteSorting: true
//        )
//        .trackActivity(loading)
//        .sink(receiveCompletion: { [weak self] completion in
//            self?.handleAPIRequestError(completion: completion)
//        }, receiveValue: { [weak self] response in
//            self?.logger.debug("Received \(response.items?.count ?? 0) Channels")
//            guard let self = self else { return }
//            if let chans = response.items {
//                for chan in chans {
//                    if let chanId = chan.id {
//                        self.channels[chanId] = chan
//                    }
//                }
//                self.getRecommendedPrograms()
//                self.getSeries()
//                self.getMovies()
//                self.getSports()
//                self.getKids()
//                self.getNews()
//            }
//        })
//        .store(in: &cancellables)
    }

    private func getRecommendedPrograms() {
//        LiveTvAPI.getRecommendedPrograms(
//            userId: "123abc",
//            limit: 9,
//            isAiring: true,
//            imageTypeLimit: 1,
//            enableImageTypes: [.primary, .thumb],
//            fields: [.channelInfo, .primaryImageAspectRatio],
//            enableTotalRecordCount: false
//        )
//        .trackActivity(loading)
//        .sink(receiveCompletion: { [weak self] completion in
//            self?.handleAPIRequestError(completion: completion)
//        }, receiveValue: { [weak self] response in
//            self?.logger.debug("Received \(String(response.items?.count ?? 0)) Recommended Programs")
//            guard let self = self else { return }
//            self.recommendedItems = response.items ?? []
//        })
//        .store(in: &cancellables)
    }

    private func getSeries() {
//        let getProgramsRequest = GetProgramsRequest(
//            userId: "123abc",
//            hasAired: false,
//            isMovie: false,
//            isSeries: true,
//            isNews: false,
//            isKids: false,
//            isSports: false,
//            limit: 9,
//            enableTotalRecordCount: false,
//            enableImageTypes: [.primary, .thumb],
//            fields: [.channelInfo, .primaryImageAspectRatio]
//        )

//        LiveTvAPI.getPrograms(getProgramsRequest: getProgramsRequest)
//            .trackActivity(loading)
//            .sink(receiveCompletion: { [weak self] completion in
//                self?.handleAPIRequestError(completion: completion)
//            }, receiveValue: { [weak self] response in
//                self?.logger.debug("Received \(String(response.items?.count ?? 0)) Series Items")
//                guard let self = self else { return }
//                self.seriesItems = response.items ?? []
//            })
//            .store(in: &cancellables)
    }

    private func getMovies() {
//        let getProgramsRequest = GetProgramsRequest(
//            userId: "123abc",
//            hasAired: false,
//            isMovie: true,
//            isSeries: false,
//            isNews: false,
//            isKids: false,
//            isSports: false,
//            limit: 9,
//            enableTotalRecordCount: false,
//            enableImageTypes: [.primary, .thumb],
//            fields: [.channelInfo, .primaryImageAspectRatio]
//        )

//        LiveTvAPI.getPrograms(getProgramsRequest: getProgramsRequest)
//            .trackActivity(loading)
//            .sink(receiveCompletion: { [weak self] completion in
//                self?.handleAPIRequestError(completion: completion)
//            }, receiveValue: { [weak self] response in
//                self?.logger.debug("Received \(String(response.items?.count ?? 0)) Movie Items")
//                guard let self = self else { return }
//                self.movieItems = response.items ?? []
//            })
//            .store(in: &cancellables)
    }

    private func getSports() {
//        let getProgramsRequest = GetProgramsRequest(
//            userId: "123abc",
//            hasAired: false,
//            isSports: true,
//            limit: 9,
//            enableTotalRecordCount: false,
//            enableImageTypes: [.primary, .thumb],
//            fields: [.channelInfo, .primaryImageAspectRatio]
//        )

//        LiveTvAPI.getPrograms(getProgramsRequest: getProgramsRequest)
//            .trackActivity(loading)
//            .sink(receiveCompletion: { [weak self] completion in
//                self?.handleAPIRequestError(completion: completion)
//            }, receiveValue: { [weak self] response in
//                self?.logger.debug("Received \(String(response.items?.count ?? 0)) Sports Items")
//                guard let self = self else { return }
//                self.sportsItems = response.items ?? []
//            })
//            .store(in: &cancellables)
    }

    private func getKids() {
//        let getProgramsRequest = GetProgramsRequest(
//            userId: "123abc",
//            hasAired: false,
//            isKids: true,
//            limit: 9,
//            enableTotalRecordCount: false,
//            enableImageTypes: [.primary, .thumb],
//            fields: [.channelInfo, .primaryImageAspectRatio]
//        )

//        LiveTvAPI.getPrograms(getProgramsRequest: getProgramsRequest)
//            .trackActivity(loading)
//            .sink(receiveCompletion: { [weak self] completion in
//                self?.handleAPIRequestError(completion: completion)
//            }, receiveValue: { [weak self] response in
//                self?.logger.debug("Received \(String(response.items?.count ?? 0)) Kids Items")
//                guard let self = self else { return }
//                self.kidsItems = response.items ?? []
//            })
//            .store(in: &cancellables)
    }

    private func getNews() {
//        let getProgramsRequest = GetProgramsRequest(
//            userId: "123abc",
//            hasAired: false,
//            isNews: true,
//            limit: 9,
//            enableTotalRecordCount: false,
//            enableImageTypes: [.primary, .thumb],
//            fields: [.channelInfo, .primaryImageAspectRatio]
//        )

//        LiveTvAPI.getPrograms(getProgramsRequest: getProgramsRequest)
//            .trackActivity(loading)
//            .sink(receiveCompletion: { [weak self] completion in
//                self?.handleAPIRequestError(completion: completion)
//            }, receiveValue: { [weak self] response in
//                self?.logger.debug("Received \(String(response.items?.count ?? 0)) News Items")
//                guard let self = self else { return }
//                self.newsItems = response.items ?? []
//            })
//            .store(in: &cancellables)
    }

//    func fetchVideoPlayerViewModel(item: BaseItemDto, completion: @escaping (LegacyVideoPlayerViewModel) -> Void) {
//        item.createLegacyLiveTVVideoPlayerViewModel()
//            .sink { completion in
//                self.handleAPIRequestError(completion: completion)
//            } receiveValue: { videoPlayerViewModels in
//                if let viewModel = videoPlayerViewModels.first {
//                    completion(viewModel)
//                }
//            }
//            .store(in: &self.cancellables)
//    }
}
