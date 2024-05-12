//
//  PlaylistModel.swift
//  YourMusic
//
//  Created by Thanabardi on 5/5/2567 BE.
//

import Foundation

struct PlaylistModel: Decodable {
    let id: String
    let url: String
    let title: String
    let thumbnail: String
    let modifiedDate: String
    let playlistCount: Int
    let channel: String
    let channelId: String?
    let channelUrl: String?
    let type: String
    var videos: Array<InfoModel> = []
}
