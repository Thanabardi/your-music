//
//  ContentView.swift
//  YourMusic
//
//  Created by Thanabardi on 4/5/2567 BE.
//

import SwiftUI
import SwiftData

struct FavoriteView: View {
    @State var path: NavigationPath = .init()

    @Environment(\.modelContext) private var modelContext
    @Query private var favoriteItems: [FavoriteItem]

    @EnvironmentObject var videoPlayerConfig: VideoPlayerConfig
    
    var body: some View {
        NavigationStack(path: $path.animation(.easeOut)) {
            if favoriteItems.count > 0 {
                ZStack(alignment: .bottomTrailing) {
                    VStack {
                        VStack {
                            Text("Favorite").font(.headline)
                                .frame(maxWidth: .infinity)
                        }
                        .ignoresSafeArea(edges: .top)
                        .frame(height: 50)
                        .background(Color(UIColor.systemGray6))
                        .overlay(alignment: .bottom) {
                            Divider().background(Color(UIColor.systemGray5))
                        }
                        ScrollView {
                            VStack(spacing: 20) {
                                if let favoriteItems = favoriteItems[0].favoriteItems {
                                    VStack(spacing: 10) {
                                        ForEach(favoriteItems) { favoriteItem in
                                            NavigationLink(value: RouteModel.favoriteItemView(favoriteItem)) {
                                                HStack(spacing: 10) {
                                                    Image(systemName: "folder.fill")
                                                        .resizable()
                                                        .aspectRatio(contentMode: .fit)
                                                        .frame(maxHeight: 45)
                                                        .contentShape(.rect)
                                                        .foregroundStyle(.red)
                                                    Text(favoriteItem.title)
                                                    Spacer()
                                                    Image(systemName: "chevron.forward")
                                                        .foregroundStyle(Color(UIColor.systemGray))
                                                }
                                            }
                                            .foregroundStyle(.primary)
                                            .contextMenu {
                                                Button(action: {
                                                    deleteItems(favoriteItem: favoriteItem)
                                                }, label: {
                                                    Label("Delete", systemImage: "trash")
                                                })
                                            }
                                            Divider()
                                                .background(Color(UIColor.systemGray3))
                                        }
                                    }
                                }
                                if let playlistInfos = favoriteItems[0].playlistInfos {
                                    ForEach(playlistInfos) { playlistInfo in
                                        PlaylistThumbnailView(playlistInfo: playlistInfo)
                                    }
                                }
                                if let videoInfos = favoriteItems[0].videoInfos {
                                    ForEach(videoInfos) { videoInfo in
                                        Button(
                                            action: {
                                                videoPlayerConfig.currentPlaylist = videoInfos
                                                videoPlayerConfig.updateCurrentVideo(videoId: videoInfo.id)
                                            }, label: {
                                                VideoThumbnailView(videoInfo: videoInfo)
                                            })
                                        .foregroundColor(.primary)
                                    }
                                }
                                Spacer()
                            }
                            .navigationDestination(for: RouteModel.self) { route in
                                route.view
                            }
                            .padding(.horizontal, 10)
                            .padding(.vertical, 20)
                        }
                    }
                    AddFolderButtonView(parent: favoriteItems[0])
                        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottomTrailing)
                        .padding(10)
                }
            }
        }.onAppear {
            if favoriteItems.isEmpty {
                modelContext.insert(FavoriteItem(title: "Favorite"))
            }
        }
    }

    private func deleteItems(favoriteItem: FavoriteItem) {
        withAnimation {
            modelContext.delete(favoriteItem)
        }
    }
}

#Preview {
    FavoriteView()
        .modelContainer(for: FavoriteItem.self, inMemory: true)
}
