//
//  PlaylistView.swift
//  YourMusic
//
//  Created by Thanabardi on 9/5/2567 BE.
//

import SwiftUI

struct PlaylistView: View {
    let playlistId: String
    
    @State private var playlist: PlaylistModel?
    @State private var isRequestInProgress: Bool = false
    
    @EnvironmentObject var videoPlayerConfig: VideoPlayerConfig
    
    var body: some View {
        VStack(spacing: 0){
            HeaderView(title: "Playlist")
            if playlist != nil {
                VStack(alignment: .leading, spacing: 5) {
                    if let banner = playlist?.thumbnail {
                        AsyncImage(url: URL(string: banner))
                        { image in
                            image.resizable()
                                .scaledToFill()
                        } placeholder: {
                            ProgressView()
                        }
                        .frame(maxWidth: .infinity, alignment: .center)
                        .clipShape(.rect(cornerRadius: 10))
                        .padding(.bottom, 10)
                    }
                    Text(playlist!.title)
                        .font(.title3)
                        .fontWeight(.semibold)
                    NavigationLink(value: RouteModel.channelView(playlist!.channelId!)) {
                        Text(playlist!.channel).font(.callout)
                    }
                    .foregroundColor(.primary)
                    HStack {
                        Text("\(playlist!.playlistCount) videos")
                        Text("Last Updated \(formatDate(playlist!.modifiedDate))")
                    }.font(.footnote)
                    
                    if let firstVideo = playlist?.videos[0] {
                        Button(
                            action: {
                                videoPlayerConfig.currentPlaylist = playlist!.videos
                                videoPlayerConfig.updateCurrentVideo(videoId: firstVideo.id)
                            }, label: {
                                Text("Play All")
                                    .font(.headline)
                                    .frame(maxWidth: .infinity)
                                
                            }
                        )
                        .buttonStyle(.borderedProminent)
                        .foregroundColor(Color(UIColor.systemBackground))
                        .tint(.primary)
                        .clipShape(.capsule)
                        .padding(.vertical, 15)
                    }
                }
                .padding(15)
                .frame(maxWidth: .infinity, alignment: .leading)
                .background{
                    LinearGradient(stops: [
                        .init(color: Color(UIColor.systemGray3), location: 0.6),
                        .init(color: .clear, location: 1),
                    ], startPoint: .top, endPoint: .bottom)
                }
                
                ScrollView {
                    LazyVStack(spacing: 20) {
                        ForEach(playlist!.videos) { video in
                            Button(
                                action: {
                                    videoPlayerConfig.currentPlaylist = playlist!.videos
                                    videoPlayerConfig.updateCurrentVideo(videoId: video.id)
                                }, label: {
                                    VideoThumbnailView(videoInfo: video)
                                        .foregroundColor(.primary)
                                }
                            )
                        }
                        if (isRequestInProgress) { ProgressView() }
                    }
                    .padding(.leading, 10)
                    .padding(.trailing, 10)
                    .padding(.bottom, 20)
                }
            } else {
                Spacer()
                ProgressView().onAppear{
                    getPlaylistDetailHandler()
                }
                Spacer()
            }
        }
    }
    
    private func getPlaylistDetailHandler() {
        isRequestInProgress = true
        Task { @MainActor in
            do {
                playlist = try await getPlaylistDetail(playlistId: playlistId)
                playlist!.videos.removeAll(where: {$0.title.lowercased().contains("[deleted video]")})
            } catch APIEror.invalidURL {
                print("invalid URL")
            } catch APIEror.invalidResponse {
                print("invalid response")
            } catch APIEror.invalidData {
                print("invalid data")
            } catch {
                print("unexpected error")
            }
            do {
                isRequestInProgress = false
            }
        }
    }
}

#Preview {
    PlaylistView(playlistId: "PL3F5C011EB4F8EA47").environmentObject(VideoPlayerConfig())
}
