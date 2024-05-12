//
//  VideoThumbnailView.swift
//  YourTube
//
//  Created by Thanabardi on 29/3/2567 BE.
//

import SwiftUI

struct VideoThumbnailView: View {
    let videoInfo: InfoModel

    var body: some View {
        ZStack(alignment: .topTrailing) {
            HStack(alignment: .top) {
                AsyncImage(url: URL(string: videoInfo.thumbnail!))
                { image in
                    image.resizable()
                        .scaledToFill()
                } placeholder: {
                    ProgressView()
                }
                .frame(width: 160, height: 90, alignment: .center)
                .clipped()
                .clipShape(.rect(cornerRadius: 5))
                .shadow(radius: 2)
                .overlay(alignment: .bottomTrailing) {
                    if let duration = videoInfo.duration {
                        Text(formatSeconds(duration))
                            .foregroundStyle(.white)
                            .font(.footnote)
                            .padding([.leading, .trailing], 4)
                            .background(.black .opacity(0.8))
                            .clipShape(.rect(cornerRadius: 4))
                            .offset(x: -2, y: -2)
                    }
                }
                VStack(alignment: .leading) {
                    Text(videoInfo.title)
                        .font(.headline)
                        .multilineTextAlignment(.leading)
                        .fixedSize(horizontal: false, vertical: true)
                        .lineLimit(2)
                        .padding(.trailing, 15)
                    if let channel = videoInfo.channel {
                        Text(channel).font(.footnote)
                    }
                }
                Spacer()
            }
            AddFavoriteButtonView(info: videoInfo)
        }
    }
}

#Preview {
    VideoThumbnailView(
        videoInfo: InfoModel(id: "", url: "", title: "Final Fantasy 7 Remake - OST Full Soundtrack", channel: "GameMusicSound", channelId: "", channelUrl: "", type: "", thumbnail: "https://i.ytimg.com/vi/udgGfmnuPMQ/hq720.jpg?sqp=-oaymwEcCNAFEJQDSFXyq4qpAw4IARUAAIhCGAFwAcABBg==&rs=AOn4CLDMb-PwMHpdXcURo0kt1NJc5WIzng", duration: 9360, modifiedDate: "", playlistCount: 0, avatar: "", followers: 0)
    )
}
