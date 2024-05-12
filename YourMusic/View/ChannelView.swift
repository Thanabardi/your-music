//
//  ChannelView.swift
//  YourMusic
//
//  Created by Thanabardi on 9/5/2567 BE.
//

import SwiftUI

struct ChannelView: View {
    let channelId: String
    
    @State private var filter: SearchFilter = SearchFilter.video
    @State private var channel: ChannelModel?

    @State var isRequestInProgress: Bool = false
    
    @EnvironmentObject var videoPlayerConfig: VideoPlayerConfig
    
    var body: some View {
        VStack(spacing: 0) {
            HeaderView(title: "Channel")
            if channel != nil {
                VStack(spacing: -50) {
                    if let banner = channel!.banner {
                        AsyncImage(url: URL(string: banner))
                        { image in
                            image.resizable()
                                .scaledToFill()
                        } placeholder: {
                            ProgressView()
                        }
                        .frame(height: 100, alignment: .center)
                        .clipped()
                        .contentShape(.rect)
                    }
                    VStack {
                        if let avatar = channel!.avatar {
                            AsyncImage(url: URL(string: avatar))
                            { image in
                                image.resizable()
                                    .scaledToFill()
                            } placeholder: {
                                ProgressView()
                            }
                            .frame(width: 100, height: 100, alignment: .center)
                            .clipped()
                            .clipShape(.circle)
                        }
                        Text(channel!.channel)
                        if let followers = channel!.followers {
                            Text("\(formatFollower(followers)) subscribers").font(.footnote)
                        }
                    }.padding(.top, channel?.banner != nil ? 0 : 10)
                }
                .frame(maxWidth: .infinity)
                .background{
                    LinearGradient(stops: [
                        .init(color: Color(UIColor.systemGray3), location: 0.6),
                        .init(color: .clear, location: 1),
                    ], startPoint: .top, endPoint: .bottom)
                }
                VStack(spacing: 20) {
                    HStack {
                        Button("Video") {
                            filter = SearchFilter.video
                            channel!.playlist.removeAll()
                            getChannelDetailHandler()
                        }
                        .font(.footnote)
                        .buttonStyle(.borderedProminent)
                        .foregroundColor(.white)
                        .tint(Color(UIColor.systemGray3))
                        .disabled(filter == SearchFilter.video)
                        Button("Playlist") {
                            filter = SearchFilter.playlist
                            channel!.playlist.removeAll()
                            getChannelDetailHandler()
                        }
                        .font(.footnote)
                        .buttonStyle(.borderedProminent)
                        .foregroundColor(.white)
                        .tint(Color(UIColor.systemGray3))
                        .disabled(filter == SearchFilter.playlist)
                    }
                    ScrollView {
                        LazyVStack(spacing: 20) {
                            ForEach(channel!.playlist, id: \.id) { data in
                                if (data.type == InfoType.video.rawValue) {
                                    Button(
                                        action: {
                                            videoPlayerConfig.currentPlaylist = channel!.playlist
                                            videoPlayerConfig.updateCurrentVideo(videoId: data.id)
                                        }, label: {
                                            VideoThumbnailView(videoInfo: data)
                                                .onAppear(perform: {if (data == channel!.playlist.last) {getChannelDetailHandler()}})
                                                .foregroundColor(.primary)
                                                .frame(maxWidth: .infinity, alignment: .leading)
                                        }
                                    )
                                } else {
                                    PlaylistThumbnailView(playlistInfo: data)
                                        .onAppear(perform: {if (data == channel!.playlist.last) {getChannelDetailHandler()}})
                                }
                            }
                            if (isRequestInProgress) { ProgressView() }
                        }
                        .padding(.leading, 10)
                        .padding(.trailing, 10)
                        .padding(.bottom, 20)
                    }
                }
                .padding(.top, 10)
            } else {
                Spacer()
                ProgressView().onAppear{
                    getChannelDetailHandler()
                }
                Spacer()
            }
        }
    }
    
    private func getChannelDetailHandler() {
        isRequestInProgress = true
        Task { @MainActor in
            do {
                var amount = 10
                var start = 0
                if(filter == SearchFilter.video) {
                    amount = 100
                }
                if let playlistCount = channel?.playlist.count {
                    start = playlistCount
                }
                let channelDetail = try await getChannelDetail(channelId: channelId, filter: filter.rawValue, start: start, amount: amount)
                if channel != nil && channel!.playlist.count > 0 &&
                    channelDetail.playlist.count > 0 &&
                    channel!.playlist[0].type == channelDetail.playlist[0].type {
                    channel!.playlist.append(contentsOf: channelDetail.playlist)
                } else {
                    channel = channelDetail
                }
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
    ChannelView(channelId: "UC4plRabXFGdAE6HP-tBQKdQ").environmentObject(VideoPlayerConfig())
}
