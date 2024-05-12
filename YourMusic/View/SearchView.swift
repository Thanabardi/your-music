//
//  SearchScreen.swift
//  YourTube
//
//  Created by Thanabardi on 27/3/2567 BE.
//

import SwiftUI

struct SearchView: View {
    @State var path: NavigationPath = .init()
    
    @State private var query: String = ""
    @State private var filter: SearchFilter = SearchFilter.video
    @State private var searchResult: Array<InfoModel> = []
    @State private var isRequestInProgress: Bool = false
    @State private var isSearchFullScreen: Bool = true
    
    @EnvironmentObject var videoPlayerConfig: VideoPlayerConfig
    
    var body: some View {
        NavigationStack(path: $path.animation(.easeOut)) {
            VStack {
                if (searchResult.isEmpty && isSearchFullScreen) {
                    Text("Your Music").font(.largeTitle).fontWeight(.bold)
                }
                HStack(spacing: 10) {
                    TextField( 
                        "Search",
                        text: $query
                    )
                    .onSubmit {
                        searchResult.removeAll()
                        isSearchFullScreen = false
                        searchHandler()
                    }
                    .textInputAutocapitalization(.never)
                    .autocorrectionDisabled()
                    .textFieldStyle(.roundedBorder)
                    .clipShape(.capsule)
                    .overlay(alignment: .trailing) {
                        RoundedRectangle(cornerRadius: .infinity)
                            .stroke(Color(UIColor.systemGray6), lineWidth: 2)
                    }
                }.ignoresSafeArea()
                    .frame(height: 50)
                    .padding([.leading, .trailing], 10)
                    .background(searchResult.isEmpty && isSearchFullScreen ? Color(UIColor.clear) : Color(UIColor.systemGray6))
                
                HStack {
                    Button("Video") {
                        filter = SearchFilter.video
                    }
                    .font(.footnote)
                    .buttonStyle(.borderedProminent)
                    .foregroundColor(.white)
                    .tint(Color(UIColor.systemGray3))
                    .disabled(filter == SearchFilter.video)
                    Button("Playlist") {
                        filter = SearchFilter.playlist
                    }
                    .font(.footnote)
                    .buttonStyle(.borderedProminent)
                    .foregroundColor(.white)
                    .tint(Color(UIColor.systemGray3))
                    .disabled(filter == SearchFilter.playlist)
                    Button("Channel") {
                        filter = SearchFilter.channel
                    }
                    .font(.footnote)
                    .buttonStyle(.borderedProminent)
                    .foregroundColor(.white)
                    .tint(Color(UIColor.systemGray3))
                    .disabled(filter == SearchFilter.channel)
                }
                
                if (!searchResult.isEmpty || !isSearchFullScreen) {
                    ScrollView {
                        LazyVStack(spacing: 20) {
                            ForEach(searchResult, id: \.id) { result in
                                if (result.type == InfoType.video.rawValue) {
                                    Button(
                                        action: {
                                            videoPlayerConfig.currentPlaylist = searchResult
                                            videoPlayerConfig.updateCurrentVideo(videoId: result.id)
                                        }, label: {
                                            VideoThumbnailView(videoInfo: result)
                                        })
                                        .foregroundColor(.primary)
                                        .onAppear(perform: {if(result == searchResult.last){searchHandler()}})
                                } else if (result.type == InfoType.playlist.rawValue) {
                                    PlaylistThumbnailView(playlistInfo: result)
                                        .onAppear(perform: {if(result == searchResult.last){searchHandler()}})
                                } else if (result.type == InfoType.channel.rawValue) {
                                    ChannelThumbnailView(channelInfo: result)
                                        .onAppear(perform: {if(result == searchResult.last){searchHandler()}})
                                }
                            }
                            if (isRequestInProgress) { ProgressView() }
                        }
                        .padding(.horizontal, 10)
                        .padding(.bottom, 20)
                        .navigationDestination(for: RouteModel.self) { route in
                            route.view
                        }
                    }
                }
            }
        }
    }
    
    private func searchHandler() {
        isRequestInProgress = true
        Task { @MainActor in
            do {
                var amount = 10
                if(filter == SearchFilter.video) {
                    amount = 100
                }
                for result in try await searchYoutube(query: query, filter: filter.rawValue, start: searchResult.count+1, amount: amount) {
                    if (!searchResult.contains(where: { $0.id == result.id })) {
                        searchResult.append(result)
                    }
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
    HomeView()
        .environmentObject(VideoPlayerConfig())
}
