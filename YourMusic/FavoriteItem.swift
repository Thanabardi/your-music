//
//  Item.swift
//  YourMusic
//
//  Created by Thanabardi on 4/5/2567 BE.
//

import Foundation
import SwiftData

@Model
final class FavoriteItem {
    @Attribute(.unique) var id: UUID
    var title: String
    var parent: FavoriteItem?
    @Relationship(deleteRule: .nullify, inverse: \FavoriteItem.parent)
    var favoriteItems: Array<FavoriteItem>?
    var playlistInfos: Array<InfoModel>?
    var videoInfos: Array<InfoModel>?
    
    init(id: UUID = UUID(), title: String, parent: FavoriteItem? = nil, playlistInfos: Array<InfoModel>? = nil, videoInfos: Array<InfoModel>? = nil) {
        self.id = id
        self.title = title
        self.parent = parent
        self.playlistInfos = playlistInfos
        self.videoInfos = videoInfos
    }
}
