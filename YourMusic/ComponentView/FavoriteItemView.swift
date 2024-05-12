//
//  FavoriteItemView.swift
//  YourMusic
//
//  Created by Thanabardi on 12/5/2567 BE.
//

import SwiftUI
import SwiftData

protocol UpdateFavoriteItemDelegate {
    func updateFavoriteItem()
}

struct FavoriteItemView: View, UpdateFavoriteItemDelegate {
    @State var favoriteItem: FavoriteItem

    @Environment(\.modelContext) private var modelContext
    @Query private var favoriteItems: [FavoriteItem]

    @EnvironmentObject var videoPlayerConfig: VideoPlayerConfig

    var body: some View {
        VStack(spacing: 0) {
            HeaderView(title: favoriteItem.title)
            ZStack(alignment: .bottomTrailing) {
                ScrollView {
                    VStack(spacing: 20) {
                        if let favoriteItems = favoriteItem.favoriteItems {
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
                                    }.foregroundStyle(.primary)
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
                        if let playlistInfos = favoriteItem.playlistInfos {
                            ForEach(playlistInfos) { playlistInfo in
                                PlaylistThumbnailView(playlistInfo: playlistInfo)
                            }
                        }
                        if let videoInfos = favoriteItem.videoInfos {
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
                    .padding(.horizontal, 10)
                    .padding(.vertical, 20)
                }
                AddFolderButtonView(parent: favoriteItem, delegate: self)
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottomTrailing)
                    .padding(10)
            }
        }
    }
    
    private func deleteItems(favoriteItem: FavoriteItem) {
        withAnimation {
            modelContext.delete(favoriteItem)
        }
    }
    
    func updateFavoriteItem() {
        for item in favoriteItems {
            if item.id == favoriteItem.id {
                favoriteItem = item
                break
            }
        }
    }
}
