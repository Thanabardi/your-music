//
//  VideoThumbnailView.swift
//  YourTube
//
//  Created by Thanabardi on 29/3/2567 BE.
//

import SwiftUI

struct PlaylistThumbnailView: View {
    let playlistInfo: InfoModel

    var body: some View {
        ZStack(alignment: .topTrailing) {
            HStack(alignment: .top) {
                NavigationLink(value: RouteModel.playlistView(playlistInfo.id)) {
                    ZStack {
                        Rectangle().fill(Color(UIColor.systemGray6))
                            .frame(width: 140, height: 90, alignment: .center)
                            .clipShape(.rect(cornerRadius: 5))
                            .shadow(radius: 2)
                            .offset(y: -10)
                        Rectangle().fill(Color(UIColor.systemGray5))
                            .frame(width: 150, height: 90, alignment: .center)
                            .clipShape(.rect(cornerRadius: 5))
                            .shadow(radius: 2)
                            .offset(y: -5)
                        AsyncImage(url: URL(string: playlistInfo.thumbnail!))
                        { image in
                            image.resizable()
                                .scaledToFill()
                        } placeholder: {
                            ProgressView()
                        }
                        .frame(width: 160, height: 90, alignment: .center)
                        .clipped()
                        .clipShape(.rect(cornerRadius: 5))
                        .overlay(alignment: .bottomTrailing) {
                            Text("\(playlistInfo.playlistCount!) videos")
                                .foregroundStyle(.white)
                                .font(.footnote)
                                .padding([.leading, .trailing], 4)
                                .background(.black .opacity(0.8))
                                .clipShape(.rect(cornerRadius: 4))
                                .shadow(radius: 2)
                                .offset(x: -2, y: -2)
                        }
                    }

                    VStack(alignment: .leading) {
                        Text(playlistInfo.title)
                            .font(.headline)
                            .multilineTextAlignment(.leading)
                            .fixedSize(horizontal: false, vertical: true)
                            .lineLimit(2)
                            .padding(.trailing, 15)
                        if let channel = playlistInfo.channel {
                            Text(channel).font(.footnote)
                        }
                        Text("Last updated on \(formatDate(playlistInfo.modifiedDate!))").font(.caption)
                    }
                    Spacer()
                }
            }
            .padding([.top], 10)
            .foregroundColor(.primary)
        AddFavoriteButtonView(info: playlistInfo)
            .padding([.top], 10)
        }
    }
}


#Preview {
    PlaylistThumbnailView(playlistInfo: InfoModel(id: "1234567id", url: "", title: "FF VII Remake OST 太空戰士7重製版原聲帶(全156首)", channel: "pure gamer", channelId: "channelId", channelUrl: "", type: "", thumbnail: "https://i.ytimg.com/vi/jOUG5ZicixQ/hqdefault.jpg?sqp=-oaymwEXCNACELwBSFryq4qpAwkIARUAAIhCGAE=&rs=AOn4CLD1Q9CYyYcDNj5kF5IbwZKrze0wmQ", duration: 0, modifiedDate: "20211003", playlistCount: 156, avatar: "", followers: 0)
    )
}
