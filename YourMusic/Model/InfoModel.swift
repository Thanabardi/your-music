//
//  SearchResultModel.swift
//  YourMusic
//
//  Created by Thanabardi on 4/5/2567 BE.
//

struct InfoModel: Codable, Equatable, Identifiable {
    let id: String
    let url: String
    let title: String
    let channel: String?
    let channelId: String?
    let channelUrl: String?
    let type: String
    // videoInfo
    let thumbnail: String?
    let duration: Int?
    // playlistInfo
    let modifiedDate: String?
    let playlistCount: Int?
    // channelInfo
    let avatar: String?
    let followers: Int?
}

enum SearchFilter: String {
    case video = "video"
    case playlist = "playlist"
    case channel = "channel"
}

enum InfoType: String {
    case video = "video_info"
    case playlist = "playlist_info"
    case channel = "channel_info"
}

//struct PlaylistInfoModel: Decodable {
//    let id: String
//    let url: String
//    let title: String
//    let thumbnail: String
//    let modifiedDate: String
//    let playlistCount: Int
//    let channel: String
//    let channelId: String?
//    let channelUrl: String?
//    let type: String
//}
//
//struct VideoInfoModel: Decodable {
//    let id: String
//    let url: String
//    let title: String
//    let thumbnail: String
//    let channel: String
//    let channelId: String
//    let channelUrl: String
//    let duration: Int
//    let type: String
//}
//
//struct ChannelInfoModel: Decodable {
//    let id: String
//    let url: String
//    let title: String
//    let avatar: String
//    let channel: String
//    let channelId: String?
//    let channelUrl: String?
//    let followers: Int?
//    let type: String
//}
