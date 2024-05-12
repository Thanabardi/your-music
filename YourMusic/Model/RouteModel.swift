//
//  RouteModel.swift
//  YourMusic
//
//  Created by Thanabardi on 11/5/2567 BE.
//

import SwiftUI

enum RouteModel: Hashable {
    case favoriteItemView(FavoriteItem)
    case channelView(String)
    case playlistView(String)
    
    @ViewBuilder
    var view: some View {
        switch self {
        case .favoriteItemView(let favoriteItem):
            FavoriteItemView(favoriteItem: favoriteItem)
        case .channelView(let channelId):
            ChannelView(channelId: channelId)
        case .playlistView(let playlistId):
            PlaylistView(playlistId: playlistId)
        }
    }
}
