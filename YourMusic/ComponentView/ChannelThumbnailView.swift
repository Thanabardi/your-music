//
//  VideoThumbnailView.swift
//  YourTube
//
//  Created by Thanabardi on 29/3/2567 BE.
//

import SwiftUI

struct ChannelThumbnailView: View {
    let channelInfo: InfoModel

    var body: some View {
        HStack(alignment: .top) {
            NavigationLink(value: RouteModel.channelView(channelInfo.id)) {
                AsyncImage(url: URL(string: channelInfo.avatar!))
                { image in
                    image.resizable()
                        .scaledToFill()
                } placeholder: {
                    ProgressView()
                }
                .frame(width: 90, height: 90, alignment: .center)
                .clipped()
                .clipShape(.circle)
                .shadow(radius: 2)
                .padding([.leading, .trailing], 10)
                
                VStack(alignment: .leading) {
                    Text(channelInfo.channel!)
                        .font(.headline)
                        .multilineTextAlignment(.leading)
                        .fixedSize(horizontal: false, vertical: true)
                        .lineLimit(2)
                    if let followers = channelInfo.followers {
                        Text("\(formatFollower(followers)) subscribers").font(.footnote)
                    }
                }
                Spacer()
            }
        }
        .foregroundColor(.primary)
    }
}


//#Preview {
//    ChannelThumbnailView(
//        avatar: "https://yt3.ggpht.com/wZCe5vgTU5_q7Pxx8B12_etuw9bAZ_UMDmMHu1T4KnF1iBOgFTE0v_iPcFuYca7_hy-j8nV0=s176-c-k-c0x00ffffff-no-rj-mo",
//        channel: "SQUARE ENIX MUSIC Channel",
//        followers: 16000
//    )
//}
