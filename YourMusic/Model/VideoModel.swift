//
//  VideoModel.swift
//  YourMusic
//
//  Created by Thanabardi on 4/5/2567 BE.
//

struct VideoModel: Codable, Equatable {
    let id: String
    let url: String
    let title: String
    let thumbnail: String
    let uploadDate: String
    let channel: String
    let channelId: String
    let channelUrl: String
    let duration: Int
    let description: String
    let chapters: Array<Chapter>?
    let audioUrl: String
    let audioFormat: String
    let videoUrl: String
    let videoFormat: String
    let type: String
}

struct Chapter: Codable, Equatable {
    let startTime: Int
    let title: String
    let endTime: Int
}
