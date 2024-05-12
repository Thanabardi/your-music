//
//  PlayerConfig.swift
//  YourMusic
//
//  Created by Thanabardi on 4/5/2567 BE.
//

import Foundation
import AVFoundation


class VideoPlayerConfig: ObservableObject {
    @Published var currentPlaylist: Array<InfoModel> = []
    @Published public private(set) var isShowPlayer: Bool = false
    @Published public private(set) var canPlayNext: Bool = false
    @Published public private(set) var canPlayPrevious: Bool = false
    @Published public private(set) var currentVideo: VideoModel?
    
    func nextVideoHandler() {
        let currentVideoId = currentPlaylist.firstIndex(where: {$0.id == currentVideo!.id})
        if canPlayNext {
            updateCurrentVideo(videoId: currentPlaylist[currentVideoId! + 1].id)
        }
    }
    
    func previousVideoHandler() {
        let currentVideoId = currentPlaylist.firstIndex(where: {$0.id == currentVideo!.id})
        if canPlayPrevious {
            updateCurrentVideo(videoId: currentPlaylist[currentVideoId! - 1].id)
        }
    }
    
    func canPlayNextHandler() -> Bool {
        let currentVideoId = currentPlaylist.firstIndex(where: {$0.id == currentVideo!.id})
        if currentVideoId != nil && currentVideoId! + 1 < currentPlaylist.count {
            return true
        }
        return false
    }
    
    func canPlayPreviousHandler() -> Bool {
        let currentVideoId = currentPlaylist.firstIndex(where: {$0.id == currentVideo!.id})
        if currentVideoId != nil && currentVideoId! - 1 >= 0 {
            return true
        }
        return false
    }
    
    func updateCurrentVideo(videoId: String) {
        if videoId == currentVideo?.id {
            return
        }
        Task { @MainActor in
            do {
                isShowPlayer = true
                currentVideo = try await getVideoDetail(videoId: videoId, quality: "1080")
                canPlayNext = canPlayNextHandler()
                canPlayPrevious = canPlayPreviousHandler()
            } catch APIEror.invalidURL {
                print("invalid URL")
            } catch APIEror.invalidResponse {
                print("invalid response")
            } catch APIEror.invalidData {
                print("invalid data")
            } catch {
                print("unexpected error")
            }
        }
    }
    
    func clearPlayerConfig() {
        isShowPlayer = false
        currentPlaylist = []
        currentVideo = nil
    }
}
